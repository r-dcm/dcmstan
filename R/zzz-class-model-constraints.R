
# Define scoring model constraint classes --------------------------------------
#' S7 class for scoring model constraints
#'
#' @noRd
constrain <- S7::new_class(
  "constrain",
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
  parent = constrain,
  properties = list(constraint = constraint_property)
)

POSTERIOR <- S7::new_class(
  "POSTERIOR",
  parent = constrain,
  properties = list(constraint = constraint_property)
)
