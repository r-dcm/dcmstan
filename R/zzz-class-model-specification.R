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
#' @param measurement_model A [measurement model][measurement-model] object.
#' @param structural_model A [structural model][structural-model] object.
#' @param priors A prior object created by [prior()]. If `NULL` (the default),
#'   default prior distributions defined by [default_dcm_priors()] are used.
#'
#' @returns A `dcm_specification` object.
#' @seealso [measurement-model], [structural-model]
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
dcm_specify <- function(
  qmatrix,
  identifier = NULL,
  measurement_model = lcdm(),
  structural_model = unconstrained(),
  priors = NULL
) {
  check_string(identifier, allow_null = TRUE)
  qmatrix <- rdcmchecks::clean_qmatrix(qmatrix, identifier = identifier)
  S7::check_is_S7(measurement_model, measurement)
  S7::check_is_S7(structural_model, structural)
  if (!is.null(structural_model@model_args$hierarchy)) {
    check_hierarchy_names(
      structural_model@model_args$hierarchy,
      attribute_names = names(qmatrix$attribute_names),
      arg = rlang::caller_arg(structural_model)
    )
  }

  # tweak measurement model as needed ------------------------------------------
  if (measurement_model@model == "lcdm" && ncol(qmatrix$clean_qmatrix) == 1) {
    measurement_model@model_args$max_interaction <- 1L
  } else if (
    measurement_model@model == "lcdm" &&
      all(rowSums(qmatrix$clean_qmatrix) == 1)
  ) {
    measurement_model@model_args$max_interaction <- 1L
  }

  if (
    measurement_model@model %in%
      c("lcdm", "dina", "dino", "nida", "nido", "ncrum", "crum") &&
      S7::S7_inherits(structural_model, HDCM)
  ) {
    measurement_model@model_args$hierarchy <-
      structural_model@model_args$hierarchy
  }

  # define priors --------------------------------------------------------------
  if (is.null(priors)) {
    priors <- default_dcm_priors(
      measurement_model = measurement_model,
      structural_model = structural_model
    )
  } else {
    S7::check_is_S7(priors, dcmprior)
    priors <- c(
      priors,
      default_dcm_priors(
        measurement_model = measurement_model,
        structural_model = structural_model
      ),
      replace = TRUE
    )
  }

  # create specification -------------------------------------------------------
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
#' S7 model specification class
#'
#' The `dcm_specification` constructor is exported to facilitate the defining
#' of methods in other packages. We do not expect or recommend calling this
#' function directly. Rather, to create a model specification, one should use
#' [dcm_specify()].
#'
#' @param qmatrix A cleaned Q-matrix, as returned by
#'   [rdcmchecks::clean_qmatrix()].
#' @param qmatrix_meta A list of Q-matrix metadata consisting of the other
#'   (not Q-matrix) elements returned by [rdcmchecks::clean_qmatrix()].
#' @param measurement_model A [measurement model][measurement-model] object.
#' @param structural_model A [structural model][structural-model] object.
#' @param priors A [prior][prior()] object.
#'
#' @returns A `dcm_specification` object.
#' @seealso [dcm_specify()]
#' @export
#'
#' @examples
#' qmatrix <- tibble::tibble(
#'   att1 = sample(0:1, size = 15, replace = TRUE),
#'   att2 = sample(0:1, size = 15, replace = TRUE),
#'   att3 = sample(0:1, size = 15, replace = TRUE),
#'   att4 = sample(0:1, size = 15, replace = TRUE)
#' )
#'
#' dcm_specification(qmatrix = qmatrix,
#'                   qmatrix_meta = list(attribute_names = paste0("att", 1:4),
#'                                       item_identifier = NULL,
#'                                       item_names = 1:15),
#'                   measurement_model = lcdm(),
#'                   structural_model = unconstrained(),
#'                   priors = default_dcm_priors(lcdm(), unconstrained()))
dcm_specification <- S7::new_class(
  "dcm_specification",
  package = "dcmstan",
  properties = list(
    qmatrix = S7::new_property(
      class = S7::class_list,
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
        } else if (
          !all(vapply(value, \(x) all(x %in% c(0L, 1L)), logical(1)))
        ) {
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
      default = NULL
    ),
    structural_model = S7::new_property(
      class = structural,
      default = NULL
    ),
    priors = S7::new_property(
      class = dcmprior,
      default = NULL
    )
  ),
  validator = function(self) {
    all_params <- dplyr::bind_rows(
      get_parameters(
        self@measurement_model,
        qmatrix = self@qmatrix,
        attributes = self@qmatrix_meta$attribute_names
      ),
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
S7::method(print, dcm_specification) <- function(x, ...) {
  # model name -----
  mod_name <- names(meas_choices())[
    which(meas_choices() == x@measurement_model@model)
  ]
  mod_name <- gsub(
    "(?<!model) (\\([A-Z]*\\))",
    " \\1 model",
    mod_name,
    perl = TRUE
  )

  # count items per attribute -----
  att_items <- glue::glue(
    "{{.val {names(x@qmatrix_meta$attribute_names)}}} ",
    "({{{colSums(x@qmatrix)}}} item{{?s}})"
  )

  # structural model name -----
  strc_mod_name <- names(strc_choices())[
    which(strc_choices() == x@structural_model@model)
  ]
  strc_mod_name <- gsub("^([a-z])", "\\U\\1", strc_mod_name, perl = TRUE)
  if (!rlang::is_empty(x@structural_model@model_args$hierarchy)) {
    strc_mod_name <- c(
      paste0(strc_mod_name, ","),
      "with structure:",
      gsub("\n", ";", x@structural_model@model_args$hierarchy)
    )
  } else if (
    S7::S7_inherits(x@structural_model, LOGLINEAR) &&
      !is.infinite(x@structural_model@model_args$max_interaction)
  ) {
    max_int <- x@structural_model@model_args$max_interaction
    label <- dplyr::if_else(
      max_int == 1,
      "only main effects",
      paste0("up to ", max_int, "-way interactions")
    )

    strc_mod_name <- paste0(strc_mod_name, ", with ", label)
  }

  # prior distributions -----
  prior_statements <- x@priors |>
    prior_tibble() |>
    dplyr::mutate(
      class = dplyr::case_when(
        .data$type == "structural" ~ "structural",
        .default = "measurement"
      ),
      prior = gsub(
        "rep_vector\\(([0-9\\.]+), C\\)",
        paste(rep("\\1", length(att_items)), collapse = ", "),
        .data$prior
      ),

      prior = dplyr::case_when(
        is.na(.data$coefficient) ~
          glue::glue("{{.emph {.data$type}}} ~ {.data$prior}"),
        !is.na(.data$coefficient) ~
          glue::glue("{{.var {.data$coefficient}}} ~ {.data$prior}")
      )
    ) |>
    dplyr::arrange(.data$class, .data$coefficient) |>
    dplyr::pull("prior")

  # printing -----
  cli::cli_text(
    "A {mod_name} measuring ",
    "{length(x@qmatrix_meta$attribute_names)} attributes with ",
    "{nrow(x@qmatrix)} items."
  )
  cli::cli_text("")
  cli::cli_alert_info("Attributes:")
  cli::cli_bullets(rlang::set_names(att_items, "*"))
  cli::cli_text("")
  cli::cli_alert_info("Attribute structure:")
  cli::cli_bullets(rlang::set_names(strc_mod_name, " "))
  cli::cli_text("")
  cli::cli_alert_info("Prior distributions:")
  cli::cli_bullets(rlang::set_names(prior_statements, " "))
}
