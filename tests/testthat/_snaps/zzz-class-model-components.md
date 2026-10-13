# model_property cannot be overwritten

    Code
      meas_mod <- lcdm()
      meas_mod@model <- "dina"
    Condition
      Error in `<dcmstan::LCDM>@model`:
      ! Can't set read-only property.

---

    Code
      strc_mod <- loglinear()
      strc_mod@model <- "hdcm"
    Condition
      Error in `<dcmstan::LOGLINEAR>@model`:
      ! Can't set read-only property.

# public model constructors initialize the model once

    Code
      x <- dina()
      x@model <- "dino"
    Condition
      Error in `<dcmstan::DINA>@model`:
      ! Can't set read-only property.

# public models retain parent validation

    Code
      model <- S7::S7_class(dina())
      model(model = "unknown")
    Condition
      Error in `measurement()`:
      ! <dcmstan::measurement> object properties are invalid:
      - @model must be one of "lcdm", "dina", "dino", "nida", "nido", "ncrum", or "crum", not
      - @model "unknown"

---

    Code
      model <- S7::S7_class(loglinear())
      model(model = "unknown")
    Condition
      Error in `structural()`:
      ! <dcmstan::structural> object properties are invalid:
      - @model must be one of "unconstrained", "independent", "loglinear", "hdcm", or
      - @model "bayesnet", not "unknown"

---

    Code
      x <- dina()
      x@model_args <- list(max_interaction = 1)
    Condition
      Error:
      ! <dcmstan::DINA> object is invalid:
      - @model_args contains unknown arguments for `dina()`: `max_interaction`

---

    Code
      x <- loglinear()
      x@model_args <- list(hierarchy = "att1 -> att2")
    Condition
      Error:
      ! <dcmstan::LOGLINEAR> object is invalid:
      - @model_args contains unknown arguments for `loglinear()`: `hierarchy`

