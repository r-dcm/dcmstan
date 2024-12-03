dcm_specify <- function(qmatrix, identifier = NULL,
                        measurement_model, structural_model,
                        priors = NULL) {
  check_string(identifier, allow_null = TRUE)
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)
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

  # dcm_specification(
  #   qmatrix = ,
  #   qmatrix_meta = list(
  #     attribute_names = c(),
  #     item_identifier =
  #   ),
  #   measurement_model = measurement_model,
  #   structural_model = structural_model,
  #   priors = priors
  # )
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
    if (!self@item_identifier %in% colnames(self@qmatrix)) {
      "@item_identifier must be a column in @qmatrix"
    }
  }
)

