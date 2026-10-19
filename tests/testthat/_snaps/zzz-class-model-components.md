# public models retain parent validation

    Code
      model <- S7::S7_class(dina())
      cat(error_message(model(model = "unknown")), "\n", sep = "")
    Output
      <dcmstan::measurement> object properties are invalid:
      - @model must be one of "lcdm", "dina", "dino", "nida", "nido", "ncrum", or "crum", not
      - @model "unknown"
    Code
      model <- S7::S7_class(loglinear())
      cat(error_message(model(model = "unknown")), "\n", sep = "")
    Output
      <dcmstan::structural> object properties are invalid:
      - @model must be one of "unconstrained", "independent", "loglinear", "hdcm", or
      - @model "bayesnet", not "unknown"
    Code
      x <- dina()
      cat(error_message(x@model_args <- list(max_interaction = 1)), "\n", sep = "")
    Output
      <dcmstan::DINA> object is invalid:
      - @model_args contains unknown arguments for `dina()`: `max_interaction`
    Code
      x <- loglinear()
      cat(error_message(x@model_args <- list(hierarchy = "att1 -> att2")), "\n", sep = "")
    Output
      <dcmstan::LOGLINEAR> object is invalid:
      - @model_args contains unknown arguments for `loglinear()`: `hierarchy`

# model identifiers reject assignment of their current value

    Code
      x <- lcdm()
      x@model <- "lcdm"
    Condition
      Error in `<dcmstan::LCDM>@model`:
      ! Can't set read-only property.

---

    Code
      x <- loglinear()
      x@model <- "loglinear"
    Condition
      Error in `<dcmstan::LOGLINEAR>@model`:
      ! Can't set read-only property.
