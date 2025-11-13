# Specify a diagnostic classification model

Create the specifications for a Bayesian diagnostic classification
model. Choose the measurement and structural models that match your
assumptions of your data. Then choose your prior distributions, or use
the defaults. The model specification can then be used to generate the
'Stan' code needed to estimate the model.

## Usage

``` r
dcm_specify(
  qmatrix,
  identifier = NULL,
  measurement_model = lcdm(),
  structural_model = unconstrained(),
  priors = NULL
)
```

## Arguments

- qmatrix:

  The Q-matrix. A data frame with 1 row per item and 1 column per
  attribute. May optionally include an additional column of item
  identifiers. If an identifier column is included, this should be
  specified with `identifier`. All cells for the remaining attribute
  columns should be either 0 (item does not measure the attribute) or 1
  (item does measure the attribute).

- identifier:

  Optional. If present, the quoted name of the column in the `qmatrix`
  that contains item identifiers.

- measurement_model:

  A [measurement
  model](https://dcmstan.r-dcm.org/reference/measurement-model.md)
  object.

- structural_model:

  A [structural
  model](https://dcmstan.r-dcm.org/reference/structural-model.md)
  object.

- priors:

  A prior object created by
  [`prior()`](https://dcmstan.r-dcm.org/reference/prior.md). If `NULL`
  (the default), default prior distributions defined by
  [`default_dcm_priors()`](https://dcmstan.r-dcm.org/reference/default_dcm_priors.md)
  are used.

## Value

A `dcm_specification` object.

## See also

[measurement-model](https://dcmstan.r-dcm.org/reference/measurement-model.md),
[structural-model](https://dcmstan.r-dcm.org/reference/structural-model.md)

## Examples

``` r
qmatrix <- data.frame(
  att1 = sample(0:1, size = 15, replace = TRUE),
  att2 = sample(0:1, size = 15, replace = TRUE),
  att3 = sample(0:1, size = 15, replace = TRUE),
  att4 = sample(0:1, size = 15, replace = TRUE)
)

dcm_specify(qmatrix = qmatrix,
            measurement_model = lcdm(),
            structural_model = unconstrained())
#> A loglinear cognitive diagnostic model (LCDM) measuring 4 attributes with
#> 15 items.
#> 
#> ℹ Attributes:
#> • "att1" (9 items)
#> • "att2" (8 items)
#> • "att3" (10 items)
#> • "att4" (4 items)
#> 
#> ℹ Attribute structure:
#>   Unconstrained
#> 
#> ℹ Prior distributions:
#>   intercept ~ normal(0, 2)
#>   maineffect ~ lognormal(0, 1)
#>   interaction ~ normal(0, 2)
#>   `Vc` ~ dirichlet(1, 1, 1, 1)
```
