#' Prior definitions for diagnostic classification models
#'
#' Define prior distributions for types of parameters or specific parameters
#' within a model. For a complete list of types and parameters available for a
#' given model, see [get_parameters()].
#'
#' @param distribution A distribution statement for the prior
#'   (e.g., `normal(0, 2)`). For a complete list of available distributions, see
#'   the *Stan* documentation at <https://mc-stan.org/docs/>.
#' @param type The type of parameter to apply the prior to. Parameter types will
#'   vary by model. Use [get_parameters()] to see list of possible types for
#'   the chosen model.
#' @param coefficient Name of a specific parameter within the defined parameter
#'   type. If `NA` (the default), the prior is applied to all parameters within
#'   the type.
#' @param lower_bound Optional. The lower bound where the distribution should be
#'   truncated.
#' @param upper_bound Optional. The upper bound where the distribution should be
#'   truncated.
#' @param ... Additional arguments passed to [prior()].
#'
#' @details
#' [prior()] should be used for directly specifying priors. That is, when you
#' are directly typing out or providing the distribution statement to the
#' function. If you have previously created a variable with a distribution
#' statement as a character string (e.g., `dist <- "normal(0, 2)"`), then you
#' should use [prior_string()] to create your prior. See examples.
#'
#' @returns A `dcmprior` object.
#' @seealso [get_parameters()]
#' @export
#'
#' @examples
#' prior(normal(0, 2), type = "intercept")
#'
#' c(prior(beta(5, 17), type = "slip"),
#'   prior(beta(5, 25), type = "guess"))
#'
#' my_prior <- "normal(0, 2)"
#' prior_string(my_prior, type = "intercept")
prior <- function(
  distribution,
  type,
  coefficient = NA,
  lower_bound = NA,
  upper_bound = NA
) {
  call <- as.list(match.call()[-1])
  call <- lapply(call, deparse_no_string)
  if (any(names(call) %in% c("lower_bound", "upper_bound"))) {
    call[which(names(call) %in% c("lower_bound", "upper_bound"))] <-
      lapply(
        call[which(names(call) %in% c("lower_bound", "upper_bound"))],
        as.numeric
      )
  }
  do.call(dcmprior, call)
}

#' @rdname prior
#' @export
prior_string <- function(distribution, ...) {
  dcmprior(distribution, ...)
}

# Default priors ---------------------------------------------------------------
#' Default priors for diagnostic classification models
#'
#' View the prior distributions that are applied by default when using a given
#' measurement and structural model.
#'
#' @inheritParams dcm_specify
#'
#' @returns A `dcmprior` object.
#' @export
#'
#' @examples
#' default_dcm_priors(lcdm(), unconstrained())
#' default_dcm_priors(dina(), independent())
#' default_dcm_priors(lcdm(), loglinear())
default_dcm_priors <- function(
  measurement_model = NULL,
  structural_model = NULL
) {
  meas_priors <- if (is.null(measurement_model)) {
    NULL
  } else {
    S7::check_is_S7(measurement_model, class = measurement)
    switch(
      measurement_model@model,
      lcdm = lcdm_priors(
        max_interaction = measurement_model@model_args$max_interaction
      ),
      dina = dina_priors(),
      dino = dino_priors(),
      nida = nida_priors(),
      nido = nido_priors(),
      ncrum = ncrum_priors(),
      crum = crum_priors()
    )
  }

  strc_priors <- if (is.null(structural_model)) {
    NULL
  } else {
    S7::check_is_S7(structural_model, class = structural)
    switch(
      structural_model@model,
      unconstrained = unconstrained_priors(),
      independent = independent_priors(),
      loglinear = loglinear_priors(),
      hdcm = hdcm_priors()
    )
  }

  c(dcmprior(), meas_priors, strc_priors)
}

## measurement model defaults -----
lcdm_priors <- function(max_interaction) {
  prior <- c(
    prior("normal(0, 2)", type = "intercept"),
    prior("lognormal(0, 1)", type = "maineffect")
  )
  if (max_interaction > 1) {
    prior <- c(prior, prior("normal(0, 2)", type = "interaction"))
  }

  prior
}

dina_priors <- function() {
  c(prior("beta(5, 25)", type = "slip"), prior("beta(5, 25)", type = "guess"))
}

dino_priors <- dina_priors

nido_priors <- function() {
  c(
    prior("normal(0, 2)", type = "intercept"),
    prior("lognormal(0, 1)", type = "maineffect")
  )
}

nida_priors <- dina_priors

ncrum_priors <- function() {
  prior <- c(
    prior("beta(15, 3)", type = "baseline"),
    prior("beta(2, 2)", type = "penalty")
  )

  prior
}

crum_priors <- function() {
  c(
    prior("normal(0, 2)", type = "intercept"),
    prior("lognormal(0, 1)", type = "maineffect")
  )
}

## structural model defaults -----
unconstrained_priors <- function() {
  prior("dirichlet(rep_vector(1, C))", type = "structural", coefficient = "Vc")
}

independent_priors <- function() {
  prior("beta(1, 1)", type = "structural")
}

loglinear_priors <- function() {
  prior("normal(0, 10)", type = "structural")
}

hdcm_priors <- unconstrained_priors

# dcmprior class ---------------------------------------------------------------
#' S7 prior class
#'
#' The `dcmprior` constructor is exported to facilitate the defining
#' of methods in other packages. We do not expect or recommend calling this
#' function directly. Rather, to create a model specification, one should use
#' [prior()] or [default_dcm_priors()].
#'
#' @inheritParams prior
#'
#' @returns A `dcmprior` object.
#' @seealso [prior()], [default_dcm_priors()]
#' @export
#'
#' @examples
#' dcmprior(
#'   distribution = "normal(0, 1)",
#'   type = "intercept"
#' )
dcmprior <- S7::new_class(
  "dcmprior",
  package = "dcmstan",
  properties = list(
    distribution = S7::new_property(
      class = S7::class_character,
      validator = function(value) {
        err <- cli::cli_fmt(cli::cli_text(
          "must be a complete distribution statement, not {.val {value}}"
        ))
        if (any(!grepl("^[a-z_]+\\(.+\\)$", value))) {
          err
        }
      }
    ),
    type = S7::new_property(
      class = S7::class_character,
      default = NA_character_
    ),
    coefficient = S7::new_property(
      class = S7::class_character,
      default = NA_character_
    ),
    lower_bound = S7::new_property(
      class = S7::class_numeric,
      default = NA_real_
    ),
    upper_bound = S7::new_property(
      class = S7::class_numeric,
      default = NA_real_
    ),
    prior = S7::new_property(
      class = S7::class_character,
      getter = function(self) {
        if (!length(self@distribution)) {
          return(character())
        }
        mapply(
          function(lb, ub, dist) {
            if (is.na(lb) && is.na(ub)) {
              return(dist)
            }
            as.character(glue::glue("{dist}T[{lb},{ub}]", .na = ""))
          },
          self@lower_bound,
          self@upper_bound,
          self@distribution,
          USE.NAMES = FALSE
        )
      }
    )
  ),
  validator = function(self) {
    reverse <- mapply(
      \(dist, lb, ub) lb >= ub,
      self@prior,
      self@lower_bound,
      self@upper_bound
    )
    if (length(reverse)) {
      bad <- cli::cli_vec(
        names(reverse[reverse & !is.na(reverse)]),
        style = list("vec-last" = ", and ")
      )
      err <- cli::cli_fmt(cli::cli_text(
        "@lower_bound must be less than ",
        "@upper_bound. ",
        "Problematic specifications: ",
        "{.val {bad}}"
      ))
    }
    if (any(reverse, na.rm = TRUE)) {
      err
    }
  }
)


# dcmprior methods -------------------------------------------------------------
#' Coerce a dcmprior object to a tibble
#'
#' When specifying prior distributions, it is often useful to see which
#' parameters are included in a given model. Using the Q-matrix and type of
#' diagnostic model to estimated, we can create a list of all included
#' parameters for which a prior can be specified.
#'
#' @param x A model specification (e.g., [dcm_specify()], measurement model
#'   (e.g., [lcdm()]), or structural model (e.g., [unconstrained()]) object.
#' @param ... Additional arguments passed to methods. See details.
#'
#' @details
#' Additional arguments passed to methods:
#'
#' @return A [tibble][tibble::tibble-package] showing the specified priors.
#' @export
#'
#' @examples
#' prior_tibble(default_dcm_priors(lcdm()))
#'
#' prior_tibble(default_dcm_priors(dina(), independent()))
prior_tibble <- S7::new_generic("prior_tibble", "x")

#' @details
#' `.keep_all`: Logical indicating if all components should be returned. When
#'   `FALSE` (the default), only the `@type`, `@coefficient`, and `@prior`
#'   elements of the [dcmprior][prior()] object is return. When `TRUE`, the
#'   `@distribtuion`, `@lower_bound`, and `@upper_bound` are also returned.
#' @name prior_tibble
S7::method(prior_tibble, dcmprior) <- function(x, .keep_all = FALSE) {
  tib <- tibble::tibble(
    distribution = x@distribution,
    type = x@type,
    coefficient = x@coefficient,
    lower_bound = x@lower_bound,
    upper_bound = x@upper_bound,
    prior = x@prior
  )
  if (!.keep_all) {
    tib <- dplyr::select(tib, "type", "coefficient", "prior")
  }

  tib
}

S7::method(print, dcmprior) <- function(x, ...) {
  print(prior_tibble(x), ...)
}

S7::method(c, dcmprior) <- function(x, ..., replace = FALSE) {
  check_bool(replace)

  dots <- list(...)
  dots_class <- sapply(dots, function(x) inherits(x, dcmprior))
  if (length(dots) && !all(dots_class)) {
    cli::cli_abort(
      message = "All objects must be dcmprior objects"
    )
  }

  all_priors <- if (!replace) {
    do.call(
      dplyr::bind_rows,
      lapply(list(x, ...), prior_tibble, .keep_all = TRUE)
    )
  } else {
    do.call(
      dplyr::bind_rows,
      lapply(list(x, ...), prior_tibble, .keep_all = TRUE)
    ) |>
      dplyr::distinct(.data$type, .data$coefficient, .keep_all = TRUE)
  }

  out <- do.call(dcmprior, as.list(dplyr::select(all_priors, -"prior")))

  out
}
