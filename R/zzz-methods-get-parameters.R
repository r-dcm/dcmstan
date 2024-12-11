#' Identify parameters included in a diagnostic classification model
#'
#' When specifying prior distributions, it is often useful to see which
#' parameters are included in a given model. Using the Q-matrix and type of
#' diagnostic model to estimated, we can create a list of all included
#' parameters for which a prior can be specified.
#'
#' @inheritParams dcm_specify
#' @param x A model specification (e.g., [dcm_specify()], measurement model
#'   (e.g., [lcdm()]), or structural model (e.g., [unconstrained()]) object.
#' @param ... Additional arguments passed to methods.
#'
#' @return A [tibble][tibble::tibble-package] showing the available parameter
#'   types and coefficients for a specified model.
#' @export
#'
#' @examples
#' qmatrix <- tibble::tibble(item = paste0("item_", 1:10),
#'                           att1 = sample(0:1, size = 10, replace = TRUE),
#'                           att2 = sample(0:1, size = 10, replace = TRUE),
#'                           att3 = sample(0:1, size = 10, replace = TRUE),
#'                           att4 = sample(0:1, size = 10, replace = TRUE))
#' get_parameters(dina(), qmatrix = qmatrix, identifier = "item")
get_parameters <- S7::new_generic("get_parameters", "x",
                                  function(x, qmatrix, ..., identifier = NULL) {
                                    check_string(identifier, allow_null = TRUE)
                                    S7::S7_dispatch()
                                  })

# Method for DCM specification -------------------------------------------------
S7::method(get_parameters, dcm_specification) <- function(x, qmatrix,
                                                          identifier = NULL) {
  if (lifecycle::is_present(qmatrix) || !is.null(identifier)) {
    arg <- rlang::caller_arg(x)
    cli::cli_warn(
      glue::glue("{{.arg qmatrix}} and {{.arg identifier}} should not be
                 specified for {{.cls dcm_specification}} objects. Using",
                 "{{.code {arg}@qmatrix}} instead.",
                 .sep = " ")
    )
  }

  dplyr::bind_rows(
    get_parameters(x@measurement_model, qmatrix = x@qmatrix),
    get_parameters(x@structural_model, qmatrix = x@qmatrix)
  )
}

# Methods for measurement models -----------------------------------------------
S7::method(get_parameters, LCDM) <- function(x, qmatrix, identifier = NULL) {
  check_number_whole(x@model_args$max_interaction, min = 1,
                     allow_infinite = TRUE)
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)

  lcdm_parameters(qmatrix = qmatrix, identifier = identifier,
                  max_interaction = x@model_args$max_interaction)
}

S7::method(get_parameters, DINA) <- function(x, qmatrix, identifier = NULL) {
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)

  dina_parameters(qmatrix = qmatrix, identifier = identifier)
}

S7::method(get_parameters, DINO) <- function(x, qmatrix, identifier = NULL) {
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)

  dina_parameters(qmatrix = qmatrix, identifier = identifier)
}

S7::method(get_parameters, CRUM) <- function(x, qmatrix, identifier = NULL) {
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)

  lcdm_parameters(qmatrix = qmatrix, identifier = identifier,
                  max_interaction = 1L)
}

S7::method(get_parameters, HDCM) <- function(x, qmatrix, identifier = NULL) {
  check_number_whole(x@model_args$max_interaction, min = 1,
                     allow_infinite = TRUE)
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)

  lcdm_parameters(qmatrix = qmatrix, identifier = identifier,
                  max_interaction = x@model_args$max_interaction)
}

# Methods for structural models ------------------------------------------------
S7::method(get_parameters, UNCONSTRAINED) <- function(x, qmatrix,
                                                      identifier = NULL) {
  tibble::tibble(type = "structural", coefficient = "Vc")
}

S7::method(get_parameters, INDEPENDENT) <- function(x, qmatrix,
                                                    identifier = NULL) {
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)
  att_names <- if (is.null(identifier)) {
    colnames(qmatrix)
  } else {
    colnames(qmatrix[, -which(colnames(qmatrix) == identifier)])
  }
  tibble::tibble(type = "structural",
                 attributes = att_names,
                 coefficient = paste0("eta[", seq_along(att_names), "]"))
}
