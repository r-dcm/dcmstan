#' Measurement models for diagnostic classification
#'
#' The measurement model defines how the items relate to the attributes. The
#' currently supported options for measurement models are: loglinear cognitive
#' diagnostic model (LCDM); deterministic input, noisy "and" gate (DINA);
#' deterministic input, noisy "or" gate (DINO); and compensatory reparameterized
#' unified model (C-RUM). See details for additional information on each model.
#'
#' @param max_interaction For the LCDM, the highest item-level interaction to
#'   include in the model.
#'
#' @returns A measurement model object.
#'
#' @details
#' Additional details...
#'
#' @name measurement-model
#' @export
#' @examples
#' lcdm()
#' lcdm(max_interaction = 2)
#'
#' dina()
lcdm <- function(max_interaction = Inf) {
  LCDM(model = "lcdm", list(max_interaction = max_interaction))
}

#' @rdname measurement-model
#' @export
dina <- function() {
  DINA(model = "dina")
}

#' @rdname measurement-model
#' @export
dino <- function() {
  DINO(model = "dino")
}

#' @rdname measurement-model
#' @export
crum <- function() {
  CRUM(model = "crum")
}

#' @rdname measurement-model
#' @export
hdcm <- function() {
  HDCM(model = "hdcm")
}


#' Structural models for diagnostic classification
#'
#' Structural models define how the attributes are related to one another.
#' The currently supported options for structural models are: unconstrained and
#' independent. See details for additional information on each model.
#'
#' @returns A structural model object.
#' @export
#'
#' @name structural-model
#' @examples
unconstrained <- function() {
  UNCONSTRAINED(model = "unconstrained")
}

#' @rdname structural-model
#' @export
independent <- function() {
  INDEPENDENT(model = "independent")
}

#' @rdname structural-model
#' @export
hierarchical <- function() {
  HIERARCHICAL(model = "hierarchical")
}


# Define component classes -----------------------------------------------------
#' S7 class for measurement models
#'
#' @param model The type of measurement model to be used. Must be one of
#'   `r print_choices(meas_choices())`.
#' @param model_args A named list of arguments to be passed on to the
#'   corresponding `meas_*()` function.
#'
#' @noRd
measurement <- S7::new_class("measurement", package = "dcmstan",
  properties = list(
    model = S7::new_property(
      class = S7::class_character,
      validator = function(value) {
        opts <- cli::cli_vec(meas_choices(), style = list("vec-last" = ", or "))
        err <- cli::cli_fmt(cli::cli_text("must be one of {.val {opts}}, ",
                                          "not {.val {value}}"))
        if (!(value %in% meas_choices())) {
          err
        }
      },
      default = "lcdm"
    ),
    model_args = S7::new_property(
      class = S7::class_list,
      default = list()
    )
  ),
  validator = function(self) {
    provided <- names(self@model_args)
    opts <- cli::cli_vec(names(formals(paste0("meas_", self@model))))
    diff <- setdiff(provided, opts)
    err <- cli::cli_fmt(
      cli::cli_text("@model_args contains unknown arguments for ",
                    "{.fun {paste0('meas_', self@model)}}: ",
                    "{.val {diff}}")
    )
    if (!all(names(self@model_args) %in%
               names(as.list(formals(paste0("meas_", self@model)))))) {
      err
    }
  }
)

#' S7 class for structural models
#'
#' @param model The type of structural model to be used. Must be one of
#'   `r print_choices(strc_choices())`.
#' @param model_args A named list of arguments to be passed on to the
#'   corresponding `strc_*()` function.
#'
#' @noRd
structural <- S7::new_class("structural", package = "dcmstan",
  properties = list(
    model = S7::new_property(
      class = S7::class_character,
      validator = function(value) {
        opts <- cli::cli_vec(strc_choices(), style = list("vec-last" = ", or "))
        err <- cli::cli_fmt(cli::cli_text("must be one of {.val {opts}}, ",
                                          "not {.val {value}}"))
        if (!(value %in% strc_choices())) {
          err
        }
      },
      default = "unconstrained"
    ),
    model_args = S7::new_property(
      class = S7::class_list,
      default = list()
    )
  ),
  validator = function(self) {
    provided <- names(self@model_args)
    opts <- names(formals(paste0("strc_", self@model)))
    diff <- setdiff(provided, opts)
    err <- cli::cli_fmt(
      cli::cli_text("@model_args contains unknown arguments for ",
                    "{.fun {paste0('strc_', self@model)}}: ",
                    "{.val {diff}}")
    )
    if (!all(names(self@model_args) %in%
             names(as.list(formals(paste0("strc_", self@model)))))) {
      err
    }
  }
)


# Define child classes for measurement and structural models -------------------
model_property <- S7::new_property(
  class = S7::class_character,
  setter = function(self, value) {
    if (!is.null(self@model)) {
      stop("@model is read-only", call. = FALSE)
    }
    self@model <- value
  }
)

## Measurement models -----
LCDM <- S7::new_class("LCDM", parent = measurement, package = "dcmstan",
                      properties = list(model = model_property))
DINA <- S7::new_class("DINA", parent = measurement, package = "dcmstan",
                      properties = list(model = model_property))
DINO <- S7::new_class("DINO", parent = measurement, package = "dcmstan",
                      properties = list(model = model_property))
CRUM <- S7::new_class("CRUM", parent = measurement, package = "dcmstan",
                      properties = list(model = model_property))
HDCM <- S7::new_class("HDCM", parent = measurement, package = "dcmstan",
                      properties = list(model = model_property))

## Structural models -----
UNCONSTRAINED <- S7::new_class("UNCONSTRAINED", parent = structural,
                               package = "dcmstan",
                               properties = list(model = model_property))
INDEPENDENT <- S7::new_class("INDEPENDENT", parent = structural,
                             package = "dcmstan",
                             properties = list(model = model_property))
HIERARCHICAL <- S7::new_class("HIERARCHICAL", parent = structural,
                              package = "dcmstan",
                              properties = list(model = model_property))
