#' Measurement models for diagnostic classification
#'
#' The measurement model defines how the items relate to the attributes. The
#' currently supported options for measurement models are:
#' `r print_choices(names(meas_choices()), sep = "; ", last = "; and ")`.
#' See details for additional information on each model.
#'
#' @param max_interaction For the LCDM, the highest item-level interaction to
#'   include in the model.
#'
#' @returns A measurement model object.
#'
#' @details
#' The LCDM (Henson et al., 2009; Henson & Templin, 2019) is a general
#' diagnostic classification model that subsumes the other more restrictive
#' models. The probability of a respondent providing a correct response is
#' parameterized like a regression model. For each item, the LCDM includes an
#' intercept, which represents the log-odds of providing a correct response
#' when none of the attributes required by the item are present. Main effect
#' parameters represent the increase in the log-odds for each required attribute
#' that is present. Finally, interaction terms define the change in log-odds
#' (after the main effects) when more than one of the required attributes are
#' present.
#'
#' The C-RUM (Hartz, 2002) is similar to the LCDM, but is constrained to only
#' include the intercept and main effect parameters. That is, no interaction
#' terms are included for the C-RUM.
#'
#' The DINA model (de la Torre & Douglas, 2004; Junker & Sijtsma, 2001) is a
#' restrictive non-compensatory model. For each item two parameters are
#' estimated. A guessing parameter defines the probability of a respondent
#' providing a correct response when not all of the required attributes are
#' present. Conversely, a slipping parameter defines the probability of
#' providing an incorrect response when all of the required attributes are
#' present. Thus, the DINA model takes an "all-or-nothing" approach. Either a
#' respondent has all of the attributes required for an item, or they do not.
#' There is no increase in the probability of providing a correct response if
#' only a subset of the required attributes is present.
#'
#' The DINO model (Templin & Henson, 2006) is the inverse of the DINA model.
#' Whereas the DINA model is "all-or-nothing", the DINO model can be thought of
#' as "anything-or-nothing". In the DINO model, the guessing parameter defines
#' the probability of a correct response when none of the required attributes
#' are present. The slipping parameter is the probability of an incorrect
#' response when any of the required attributes is present. Therefore, when
#' using the DINO model, the presence of any of the required attributes results
#' in an increased probability of a correct response, and there is no additional
#' increase in probability for the presence of more than one of the required
#' attributes.
#'
#' @name measurement-model
#' @seealso [Structural models][structural-model]
#' @export
#'
#' @references de la Torre, J., & Douglas, J. A. (2004). Higher-order latent
#'   trait models for cognitive diagnosis. *Psychometrika, 69*(3), 333-353.
#'   \doi{10.1007/BF02295640}
#' @references Hartz, S. M. (2002). *A Bayesian framework for the unified model
#'   for assessing cognitive abilities: Blending theory with practicality*
#'   (Publication No. 3044108) \[Doctoral dissertation, University of Illinois
#'   at Urbana-Champaign\]. ProQuest Dissertations Publishing.
#' @references Henson, R. A., Templin, J. L., & Willse, J. T. (2009). Defining
#'   a family of cognitive diagnosis models using log-linear models with latent
#'   variables. *Psychometrika, 74*(2), 191-210. \doi{10.1007/s11336-008-9089-5}
#' @references Henson, R., & Templin, J. L. (2019). Loglinear cognitive
#'   diagnostic model (LCDM). In M. von Davier & Y.-S. Lee (Eds.), *Handbook of
#'   Diagnostic Classification Models* (pp. 171-185). Springer International
#'   Publishing. \doi{10.1007/978-3-030-05584-4_8}
#' @references Junker, B. W., & Sijtsma, K. (2001). Cognitive assessment models
#'   with few assumptions, and connections with nonparametric item response
#'   theory. *Applied Psychological Measurement, 25*(3), 258-272.
#'   \doi{10.1177/01466210122032064}
#' @references Templin, J. L., & Henson, R. A. (2006). Measurement of
#'   psychological disorders using cognitive diagnosis models. *Psychological
#'   Methods, 11*(3), 287-305. \doi{10.1037/1082-989X.11.3.287}
#'
#' @examples
#' lcdm()
#'
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


#' Structural models for diagnostic classification
#'
#' Structural models define how the attributes are related to one another.
#' The currently supported options for structural models are:
#' `r print_choices(names(strc_choices()), sep = "; ", last = "; and ")`.
#' See details for additional information on each model.
#'
#' @returns A structural model object.
#'
#' @details
#' The unconstrained structural model places no constraints on how the
#' attributes relate to each other. This is equivalent to a saturated model
#' described by Hu & Templin (2020) and in Chapter 8 of Rupp et al. (2010).
#'
#' The independent attributes model assumes that the presence of the attributes
#' are unrelated to each other. That is, there is no relationship between the
#' presence of one attribute and the presence of any other. For an example of
#' independent attributes model, see Lee (2016).
#'
#' @name structural-model
#' @seealso [Measurement models][measurement-model]
#' @export
#'
#' @references Hu, B., & Templin, J. (2020). Using diagnostic classification
#'   models to validate attribute hierarchies and evaluate model fit in Bayesian
#'   Networks. *Multivariate Behavioral Research, 55*(2), 300-311.
#'   \doi{10.1080/00273171.2019.1632165}
#' @references Lee, S. Y. (2016). *Cognitive diagnosis model: DINA model with
#'   independent attributes*.
#'   https://mc-stan.org/documentation/case-studies/dina_independent.html
#' @references Rupp, A. A., Templin, J., & Henson, R. A. (2010). *Diagnostic
#'   measurement: Theory, methods, and applications*. Guilford Press.
#'
#' @examples
#' unconstrained()
#'
#' independent()
unconstrained <- function() {
  UNCONSTRAINED(model = "unconstrained")
}

#' @rdname structural-model
#' @export
independent <- function() {
  INDEPENDENT(model = "independent")
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
                    "{.var {diff}}")
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
                    "{.var {diff}}")
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


## Structural models -----
UNCONSTRAINED <- S7::new_class("UNCONSTRAINED", parent = structural,
                               package = "dcmstan",
                               properties = list(model = model_property))
INDEPENDENT <- S7::new_class("INDEPENDENT", parent = structural,
                             package = "dcmstan",
                             properties = list(model = model_property))
