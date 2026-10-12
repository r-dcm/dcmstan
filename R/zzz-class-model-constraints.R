#' Scoring model constraint definitions for diagnostic classification models

#' @rdname scoring-constraint
#' @export
none <- function() {
  NONE(constraint = "none")
}
#' @rdname scoring-constraint
#' @export
posterior <- function() {
  POSTERIOR(constraint = "posterior")
}


# Define scoring model constraint classes --------------------------------------
#' S7 class for scoring model constraints
#'
#' @noRd
scoring <- S7::new_class(
  "scoring",
  package = "dcmstan",
  properties = list(
    constraint = S7::new_property(
      class = S7::class_character,
      validator = function(value) {
        opts <- cli::cli_vec(cnst_choices(), style = list("vec-last" = ", or "))
        err <- cli::cli_fmt(cli::cli_text(
          "must be one of {.val {opts}}, ",
          "not {.val {value}}"
        ))
        if (!(value %in% cnst_choices())) {
          err
        }
      },
      default = "none"
    )
  )
)

# Define child classes for scoring model constraints ---------------------------
constraint_property <- S7::new_property(
  class = S7::class_character,
  setter = function(self, value) {
    if (!is.null(self@constraint)) {
      stop("@constraint is read-only", call. = FALSE)
    }
  }
)

## Measurement models -----
NONE <- S7::new_class(
  "NONE",
  parent = scoring,
  properties = list(constraint = constraint_property)
)

POSTERIOR <- S7::new_class(
  "POSTERIOR",
  parent = scoring,
  properties = list(constraint = constraint_property)
)
