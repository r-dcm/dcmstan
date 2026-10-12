# public model constructors initialize the model once

    Code
      x <- dina()
      x@model <- "dino"
    Condition
      Error:
      ! @model is read-only

