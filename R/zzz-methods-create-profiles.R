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
#' create_profiles(unconstrained(), attributes = c("att1", "att2"))
#'
#' create_profiles(hdcm("att1 -> att2 -> att3"),
#'                 attributes = c("att1", "att2", "att3"))
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
#' `attributes`: When `x` is a [structural model][structural-model], a vector of
#' attribute names, as in the `qmatrix_meta$attribute_names` of a
#' [DCM specification][dcm_specify()].
#' @name create_profiles
S7::method(create_profiles, structural) <- function(x, attributes) {
  create_profiles(length(attributes))
}


# specific structural models ---------------------------------------------------
S7::method(create_profiles, HDCM) <-
  function(x, attributes) {
    if (is.null(x@model_args$hierarchy)) {
      return(create_profiles(S7::super(x, to = structural),
                             attributes = attributes))
    }

    if (is.null(names(attributes))) {
      attributes <- rlang::set_names(attributes, attributes)
    }

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
