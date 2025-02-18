#' Generate mastery profiles
#'
#' Given the number of attributes or model specification, generate all possible
#' attribute patterns.
#'
#' @param x An object used to generate the possible patterns. This could be a
#'   number (the number of attributes; e.g., `3`, `4`), or an object that
#'   defines attribute relationships (e.g., a
#'   [structural model][structural-model] or
#'   [model specification][dcm_specify()]).
#' @param ... Additional arguments passed to methods.
#'
#' @return A [tibble][tibble::tibble-package] with all possible attribute
#'   patterns. Each row is a profile, and each column indicates whether
#'   the attribute in that column was present (1) or not (0).
#' @export
#'
#' @examples
#' create_profiles(3L)
#' create_profiles(5)
#' create_profiles(unconstrained(), attributes = 2)
create_profiles <- S7::new_generic("create_profiles", "x")


# general methods --------------------------------------------------------------
S7::method(create_profiles, S7::class_numeric) <- function(x) {
  check_number_whole(x, min = 1)

  rep(list(c(0L, 1L)), times = x) |>
    stats::setNames(glue::glue("att{seq_len(x)}")) |>
    expand.grid() |>
    dplyr::rowwise() |>
    dplyr::mutate(total = sum(dplyr::c_across(dplyr::everything()))) |>
    dplyr::select("total", dplyr::everything()) |>
    dplyr::arrange(.data$total,
                   dplyr::desc(dplyr::across(dplyr::everything()))) |>
    dplyr::ungroup() |>
    dplyr::select(-"total") |>
    tibble::as_tibble()
}

#' @param keep_names When `x` is a [model specification][dcm_specify()], should
#'   the real attribute names be used (`TRUE`; the default), or replaced with
#'   generic names (`FALSE`; e.g., `"att1"`, `"att2"`, `"att3"`).
#' @name create_profiles
S7::method(create_profiles, dcm_specification) <-
  function(x, keep_names = TRUE) {
    profs <- create_profiles(
      x@structural_model,
      attributes = length(x@qmatrix_meta$attribute_names
    ))

    if (keep_names) {
      colnames(profs) <- names(x@qmatrix_meta$attribute_names)
    }

    profs
  }

#' @param attributes When `x` is a [structural model][structural-model], the
#'   number of attributes that should be used to generate the profiles.
#' @name create_profiles
S7::method(create_profiles, structural) <- function(x, attributes) {
  create_profiles(attributes)
}


# specific structural models ---------------------------------------------------
