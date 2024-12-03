#' Identify parameters included in a diagnostic classification model
#'
#' When specifying prior distributions, it is often useful to see which
#' parameters are included in a given model. Using the Q-matrix and type of
#' diagnostic model to estimated, we can create a list of all included
#' parameters for which a prior can be specified.
#'
#' @param x A model specification (e.g., [dcm_specify()], measurement model
#'   (e.g., [lcdm()]), or structural model (e.g., [unconstrained()]) object.
#' @param qmatrix The Q-matrix. A data frame with 1 row per item and 1 column
#'   per attribute. May optionally include an additional column of item
#'   identifiers. If an identifier column is included, this should be specified
#'   with `identifier`. All cells for the remaining attribute columns should be
#'   either 0 (item does not measure the attribute) or 1 (item does measure the
#'   attribute).
#' @param identifier Optional. If present, the quoted name of the column in the
#'   `qmatrix` that contains item identifiers.
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

# Methods for measurement models -----------------------------------------------
S7::method(get_parameters, LCDM) <- function(x, qmatrix, identifier = NULL) {
  check_number_whole(x@model_args$max_interaction, min = 1L,
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
