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
    if (!is.null(x@measurement_model@model_args$hierarchy)) {
      profs <- create_profiles(
        x = x@structural_model,
        attributes = length(x@qmatrix_meta$attribute_names),
        att_names = names(x@qmatrix_meta$attribute_names),
        hierarchy = x@measurement_model@model_args$hierarchy
      )
    } else {
      profs <- create_profiles(
        x@structural_model,
        attributes = length(x@qmatrix_meta$attribute_names)
      )
    }

    if (keep_names) {
      colnames(profs) <- names(x@qmatrix_meta$attribute_names)
    }

    profs
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
  function(x, attributes, att_names, hierarchy) {
    hierarchy <- glue::glue(" dag { <hierarchy> } ", .open = "<", .close = ">")
    hierarchy <- ggdag::tidy_dagitty(hierarchy)

    filtered_hierarchy <- hierarchy |>
      tibble::as_tibble() |>
      dplyr::filter(!is.na(.data$direction)) |>
      dplyr::select("name", "direction", "to")

    possible_profiles <- create_profiles(attributes)
    colnames(possible_profiles) <- att_names

    possible_profiles <- possible_profiles |>
      dplyr::mutate(allowed = NA)

    for (jj in seq_len(nrow(filtered_hierarchy))) {
      from <- filtered_hierarchy$name[jj]
      to <- filtered_hierarchy$to[jj]

      possible_profiles <- possible_profiles |>
        dplyr::mutate(allowed = dplyr::case_when(!!sym(to) > !!sym(from) ~
                                                   FALSE,
                                                 TRUE ~ .data$allowed))
    }

    possible_profiles <- possible_profiles |>
      dplyr::mutate(allowed = dplyr::case_when(is.na(.data$allowed) ~ TRUE,
                                               TRUE ~ .data$allowed)) |>
      dplyr::filter(.data$allowed) |>
      dplyr::select(-"allowed")

    return(possible_profiles)
  }

#' @details
#' `attributes`: When `x` is an [unconstrained][structural-model], the number of
#'   attributes that should be used to generate the profiles.
#' @name create_profiles
S7::method(create_profiles, UNCONSTRAINED) <- function(x, attributes) {
  create_profiles(attributes)
}

#' @details
#' `attributes`: When `x` is an [independent][structural-model], the number of
#'   attributes that should be used to generate the profiles.
#' @name create_profiles
S7::method(create_profiles, INDEPENDENT) <- function(x, attributes) {
  create_profiles(attributes)
}
