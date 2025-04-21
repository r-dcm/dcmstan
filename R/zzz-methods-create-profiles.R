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
#' @param ... Additional arguments passed to methods. See details.
#'
#' @details
#' Additional arguments passed to methods:
#'
#' @return A [tibble][tibble::tibble-package] with all possible attribute
#'   patterns. Each row is a profile, and each column indicates whether
#'   the attribute in that column was present (1) or not (0).
#' @export
#'
#' @examples
#' create_profiles(3L)
#'
#' create_profiles(5)
#'
#' create_profiles(hdcm(), attributes = 2, att_names = c("a", "b"),
#'                 hierarchy = "a -> b")
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

#' @details
#' `keep_names`: When `x` is a [model specification][dcm_specify()], should
#'   the real attribute names be used (`TRUE`; the default), or replaced with
#'   generic names (`FALSE`; e.g., `"att1"`, `"att2"`, `"att3"`).
#' @name create_profiles
S7::method(create_profiles, dcm_specification) <-
  function(x, keep_names = TRUE) {
    profs <- create_profiles(
      x@structural_model,
      attributes = x@qmatrix_meta$attribute_names
    )

    if (keep_names) {
      colnames(profs) <- names(x@qmatrix_meta$attribute_names)
    }

    profs
  }

#' @details
#' `attributes`: When `x` is a [structural model][structural-model], the
#'   number of attributes that should be used to generate the profiles.
#' @name create_profiles
S7::method(create_profiles, structural) <- function(x, attributes) {
  create_profiles(length(attributes))
}


# specific structural models ---------------------------------------------------
#' @details
#' `attributes`: When `x` is an [hdcm][structural-model], the number of
#'   attributes that should be used to generate the profiles.
#' `att_names`: When `x` is an [hdcm][structural-model], the names of the
#'   attributes.
#' `hierarchy`: When `x` is an [hdcm][structural-model], the attribute
#'   structure defining which attributes must be mastered before other
#'   attributes can be mastered.
#' @name create_profiles
S7::method(create_profiles, HDCM) <-
  function(x, attributes) {
    hierarchy <- glue::glue(" dag { <x@model_args$hierarchy> } ",
                            .open = "<", .close = ">")
    hierarchy <- ggdag::tidy_dagitty(hierarchy)

    filtered_hierarchy <- hierarchy |>
      tibble::as_tibble() |>
      dplyr::filter(!is.na(.data$direction)) |>
      dplyr::select("name", "direction", "to") |>
      dplyr::mutate(name = attributes[.data$name],
                    to = attributes[.data$to])

    possible_profiles <- create_profiles(length(attributes))

    for (jj in seq_len(nrow(filtered_hierarchy))) {
      possible_profiles <- possible_profiles |>
        dplyr::filter(!(!!sym(filtered_hierarchy$to[jj]) >
                          !!sym(filtered_hierarchy$name[jj])))
    }

    possible_profiles
  }
