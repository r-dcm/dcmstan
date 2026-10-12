
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
