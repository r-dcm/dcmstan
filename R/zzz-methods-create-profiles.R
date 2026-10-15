#' Possible attribute profiles
#'
#' @description
#' `create_profiles()` determines the possible attribute profiles.
#'
#' # Methods
#' `create_profiles()` is an S7 generic with methods available for the following
#' classes:
#'
#' `r doclisting::methods_list("create_profiles")`
#'
#' @param x An object used to generate the possible patterns. This could be a
#'   number (the number of attributes; e.g., `3`, `4`), or an object that
#'   defines attribute relationships (e.g., a
#'   [structural model][structural-model] or
#'   [model specification][dcm_specify()]).
#' @param ... Additional arguments passed to methods. See details.
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
#' create_profiles(unconstrained(), attributes = c("math", "science"))
#'
#' create_profiles(hdcm("first -> second -> third"), keep_names = FALSE)
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
    dplyr::arrange(
      .data$total,
      dplyr::desc(dplyr::across(dplyr::everything()))
    ) |>
    dplyr::ungroup() |>
    dplyr::select(-"total") |>
    tibble::as_tibble()
}

#' Possible attribute profiles for a DCM specification
#'
#' [create_profiles()] for a DCM specification, as determined by the structural
#' model and the Q-matrix defined in the specification object.
#'
#' @param x A [`dcm_specification`][dcm_specify()] object.
#' @param keep_names Logical. Should the real attribute names be used (`TRUE`;
#'   the default) or replaced with generic names (`FALSE`; e.g., `"att1"`,
#'   `"att2"`, `"att3"`).
#'
#' @returns A [tibble][tibble::tibble-package] with all possible attribute
#'   patterns. Each row is a profile, and each column indicates whether
#'   the attribute in that column was present (1) or not (0).
#' @aliases create_profiles-dcmstan-dcm_specification-method
S7::method(create_profiles, dcm_specification) <-
  function(x, keep_names = TRUE) {
    create_profiles(
      x@structural_model,
      attributes = x@qmatrix_meta$attribute_names,
      keep_names = keep_names
    )
  }

#' Possible attribute profiles for a DCM structural model
#'
#' [create_profiles()] for a structural model, as determined by the properties
#' of the structural model (e.g., a hierarchy) and the list of attributes.
#'
#' @param x A [`structural`][unconstrained()] object.
#' @param attributes A named vector of attributes, as in the
#'   `qmatrix_meta$attribute_names` of a [DCM specification][dcm_specify()].
#' @param keep_names Logical. Should the real attribute names as defined in
#'   `attributes` be used (`TRUE`; the default) or replaced with generic names
#'   (`FALSE`; e.g., `"att1"`, `"att2"`, `"att3"`).
#'
#' @returns A [tibble][tibble::tibble-package] with all possible attribute
#'   patterns. Each row is a profile, and each column indicates whether
#'   the attribute in that column was present (1) or not (0).
#' @aliases create_profiles-dcmstan-structural-method
S7::method(create_profiles, structural) <-
  function(x, attributes, keep_names = TRUE) {
    profs <- create_profiles(length(attributes))

    if (keep_names) {
      if (is.null(names(attributes))) {
        attributes <- rlang::set_names(
          paste0("att", seq_along(attributes)),
          attributes
        )
      }
      colnames(profs) <- names(attributes)
    }

    profs
  }


# specific structural models ---------------------------------------------------
#' Possible attribute profiles for a hierarchical DCM
#'
#' [create_profiles()] for a hierarchical DCM, as determined by the defined
#' hierarchy.
#'
#' @param x An [`HDCM`][hdcm()] structural model.
#' @param attributes A named vector of attributes, as in the
#'   `qmatrix_meta$attribute_names` of a [DCM specification][dcm_specify()]. If
#'   `NULL` (the default), attribute names are pulled from the hierarchy specified
#'   in [hdcm()].
#' @param keep_names Logical. Should the real attribute names be used (`TRUE`;
#'   the default) or replaced with generic names (`FALSE`; e.g., `"att1"`,
#'   `"att2"`, `"att3"`).
#'
#' @returns A [tibble][tibble::tibble-package] with all possible attribute
#'   patterns. Each row is a profile, and each column indicates whether
#'   the attribute in that column was present (1) or not (0).
#' @aliases create_profiles-dcmstan-HDCM-method
S7::method(create_profiles, HDCM) <-
  function(x, attributes = NULL, keep_names = TRUE) {
    if (is.null(x@model_args$hierarchy)) {
      return(create_profiles(
        S7::super(x, to = structural),
        attributes = attributes
      ))
    }

    hierarchy <- x@model_args$hierarchy
    hierarchy_tib <- glue::glue(
      " dag { <x@model_args$hierarchy> } ",
      .open = "<",
      .close = ">"
    )
    hierarchy_tib <- ggdag::tidy_dagitty(hierarchy_tib)
    hier_atts <- ggdag::pull_dag_data(hierarchy_tib) |>
      dplyr::pull("name") |>
      unique()

    if (is.null(attributes)) {
      att_order <- hier_atts
      attributes <- rlang::set_names(
        paste0("att", seq_along(hier_atts)),
        sort(hier_atts)
      )
    } else if (is.null(names(attributes))) {
      att_order <- attributes
      attributes <- rlang::set_names(
        paste0("att", seq_along(attributes)),
        sort(attributes)
      )
    } else {
      att_order <- names(attributes)
      attributes <- rlang::set_names(
        paste0("att", seq_along(attributes)),
        sort(names(attributes))
      )
    }
    check_hierarchy_names(
      hierarchy,
      names(attributes),
      present_in = "attributes"
    )

    filt_hierarchy <- hierarchy_tib |>
      tibble::as_tibble() |>
      dplyr::filter(!is.na(.data$direction)) |>
      dplyr::select("name", "direction", "to") |>
      dplyr::mutate(name = attributes[.data$name], to = attributes[.data$to])

    profs <- create_profiles(length(attributes))

    for (jj in seq_len(nrow(filt_hierarchy))) {
      profs <- profs |>
        dplyr::filter(
          !(!!sym(filt_hierarchy$to[jj]) > !!sym(filt_hierarchy$name[jj]))
        )
    }
    colnames(profs) <- names(attributes)
    profs <- dplyr::select(profs, dplyr::all_of(att_order))

    if (!keep_names) {
      profs <- dplyr::rename_with(profs, ~ paste0("att", seq_along(att_order)))
    }

    profs
  }
