#' Specify a diagnostic classification model
#'
#' Create the specifications for a Bayesian diagnostic classification model.
#' Choose the measurement and structural models that match your assumptions of
#' your data. Then choose your prior distributions, or use the defaults. The
#' model specification can then be used to generate the 'Stan' code needed to
#' estimate the model.
#'
#' @param qmatrix The Q-matrix. A data frame with 1 row per item and 1 column
#'   per attribute. May optionally include an additional column of item
#'   identifiers. If an identifier column is included, this should be specified
#'   with `identifier`. All cells for the remaining attribute columns should be
#'   either 0 (item does not measure the attribute) or 1 (item does measure the
#'   attribute).
#' @param identifier Optional. If present, the quoted name of the column in the
#'   `qmatrix` that contains item identifiers.
#' @param measurement_model A measurement model object (e.g., [lcdm()],
#'   [dina()]).
#' @param structural_model A structural model object (e.g., [unconstrained()],
#'   [independent()]).
#' @param priors A prior object created by [prior()]. If `NULL` (the default),
#'   default prior distributions defined by [default_dcm_priors()] are used.
#'
#' @returns A `dcm_specification` object.
#' @export
#'
#' @examples
#' qmatrix <- data.frame(
#'   att1 = sample(0:1, size = 15, replace = TRUE),
#'   att2 = sample(0:1, size = 15, replace = TRUE),
#'   att3 = sample(0:1, size = 15, replace = TRUE),
#'   att4 = sample(0:1, size = 15, replace = TRUE)
#' )
#'
#' dcm_specify(qmatrix = qmatrix,
#'             measurement_model = lcdm(),
#'             structural_model = unconstrained())
dcm_specify <- function(qmatrix, identifier = NULL,
                        measurement_model = lcdm(),
                        structural_model = unconstrained(),
                        priors = NULL) {
  check_string(identifier, allow_null = TRUE)
  qmatrix <- rdcmchecks::clean_qmatrix(qmatrix, identifier = identifier)
  S7::check_is_S7(measurement_model, measurement)
  S7::check_is_S7(structural_model, structural)
  if (is.null(priors)) {
    priors <- default_dcm_priors(measurement_model = measurement_model,
                                 structural_model = structural_model)
  } else {
    S7::check_is_S7(priors, dcmprior)
    priors <- c(priors,
                default_dcm_priors(measurement_model = measurement_model,
                                   structural_model = structural_model),
                replace = TRUE)
  }

  dcm_specification(
    qmatrix = qmatrix$clean_qmatrix,
    qmatrix_meta = list(
      attribute_names = qmatrix$attribute_names,
      item_identifier = qmatrix$item_identifier,
      item_names = qmatrix$item_names
    ),
    measurement_model = measurement_model,
    structural_model = structural_model,
    priors = priors
  )
}


# Model specification class ----------------------------------------------------
dcm_specification <- S7::new_class("dcm_specification", package = "dcmstan",
  properties = list(
    qmatrix = S7::new_property(
      class = S7::class_data.frame,
      setter = function(self, value) {
        if (!is.null(self@qmatrix)) {
          stop("@qmatrix is read-only", call. = FALSE)
        }
        self@qmatrix <- value
        self
      },
      validator = function(value) {
        if (!all(vapply(value, is.numeric, logical(1)))) {
          "must contain only numeric values of 0 or 1"
        } else if (!all(vapply(value, \(x) all(x %in% c(0L, 1L)), logical(1)))) {
          "must contain only values of 0 or 1"
        }
      }
    ),
    qmatrix_meta = S7::new_property(
      class = S7::class_list,
      setter = function(self, value) {
        if (!is.null(self@qmatrix_meta)) {
          stop("@qmatrix_meta is read-only", call. = FALSE)
        }
        self@qmatrix_meta <- value
        self
      }
    ),
    measurement_model = S7::new_property(
      class = measurement,
      default = lcdm()
    ),
    structural_model = S7::new_property(
      class = structural,
      default = unconstrained()
    ),
    priors = dcmprior
  ),
  validator = function(self) {
    all_params <- dplyr::bind_rows(
      get_parameters(self@measurement_model, qmatrix = self@qmatrix),
      get_parameters(self@structural_model, qmatrix = self@qmatrix)
    )

    bad_type <- prior_tibble(self@priors) |>
      dplyr::anti_join(all_params, by = "type") |>
      dplyr::pull("type") |>
      unique() |>
      cli::cli_vec()
    type_text <- paste0(
      "{.arg priors} contain types not included in the model: {.val {bad_type}}"
    )
    type_err <- cli::cli_fmt(cli::cli_text(type_text))

    bad_coef <- prior_tibble(self@priors) |>
      dplyr::filter(!is.na(.data$coefficient)) |>
      dplyr::anti_join(all_params, by = c("type", "coefficient")) |>
      dplyr::pull("coefficient") |>
      unique()
    coef_text <- paste0(
      "{.arg priors} contain coefficients not included in the models: ",
      "{.val {bad_coef}}"
    )
    coef_err <- cli::cli_fmt(cli::cli_text(coef_text))

    if (length(bad_type)) {
      type_err
    } else if (length(bad_coef)) {
      coef_err
    }
  }
)


# dcm_specification methods ----------------------------------------------------
# x <- dcm_specify(qmatrix = dcmdata::dtmr_qmatrix, identifier = "item")


S7::method(print, dcm_specification) <- function(x) {
  att_items <- glue::glue("{{.val {names(x@qmatrix_meta$attribute_names)}}} ",
                          "({{{colSums(x@qmatrix)}}} item{{?s}})")
  mod_name <- names(meas_choices())[
    which(meas_choices() == x@measurement_model@model)
  ]
  mod_name <- gsub("(?<!model) (\\([A-Z]*\\))", " \\1 model",
                   mod_name, perl = TRUE)
  mod_name <- gsub("^([A-Z])", "\\L\\1", mod_name, perl = TRUE)

  cli::cli_text("A {mod_name} measuring ",
                "{length(x@qmatrix_meta$attribute_names)} attributes with ",
                "{nrow(x@qmatrix)} items.")
  cli::cli_text("")
  cli::cli_alert_info("Attributes:")
  cli::cli_bullets(rlang::set_names(att_items, "*"))
  cli::cli_text("")
  cli::cli_alert_info("Attribute structure:")
  cli::cli_text()
}
