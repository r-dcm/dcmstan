# S7 model specification class

The `dcm_specification` constructor is exported to facilitate the
defining of methods in other packages. We do not expect or recommend
calling this function directly. Rather, to create a model specification,
one should use
[`dcm_specify()`](https://dcmstan.r-dcm.org/reference/dcm_specify.md).

## Usage

``` r
dcm_specification(
  qmatrix = list(),
  qmatrix_meta = list(),
  measurement_model = measurement(),
  structural_model = structural(),
  priors = dcmprior()
)
```

## Arguments

- qmatrix:

  A cleaned Q-matrix, as returned by
  [`rdcmchecks::clean_qmatrix()`](https://rdcmchecks.r-dcm.org/reference/check_qmatrix.html).

- qmatrix_meta:

  A list of Q-matrix metadata consisting of the other (not Q-matrix)
  elements returned by
  [`rdcmchecks::clean_qmatrix()`](https://rdcmchecks.r-dcm.org/reference/check_qmatrix.html).

- measurement_model:

  A [measurement
  model](https://dcmstan.r-dcm.org/reference/measurement-model.md)
  object.

- structural_model:

  A [structural
  model](https://dcmstan.r-dcm.org/reference/structural-model.md)
  object.

- priors:

  A [prior](https://dcmstan.r-dcm.org/reference/prior.md) object.

## Value

A `dcm_specification` object.

## See also

[`dcm_specify()`](https://dcmstan.r-dcm.org/reference/dcm_specify.md)

## Examples

``` r
qmatrix <- tibble::tibble(
  att1 = sample(0:1, size = 15, replace = TRUE),
  att2 = sample(0:1, size = 15, replace = TRUE),
  att3 = sample(0:1, size = 15, replace = TRUE),
  att4 = sample(0:1, size = 15, replace = TRUE)
)

dcm_specification(qmatrix = qmatrix,
                  qmatrix_meta = list(attribute_names = paste0("att", 1:4),
                                      item_identifier = NULL,
                                      item_names = 1:15),
                  measurement_model = lcdm(),
                  structural_model = unconstrained(),
                  priors = default_dcm_priors(lcdm(), unconstrained()))
#> A loglinear cognitive diagnostic model (LCDM) measuring 4 attributes with
#> 15 items.
#> 
#> ℹ Attributes:
#> 
#> ℹ Attribute structure:
#>   Unconstrained
#> 
#> ℹ Prior distributions:
#>   intercept ~ normal(0, 2)
#>   maineffect ~ lognormal(0, 1)
#>   interaction ~ normal(0, 2)
#>   `Vc` ~ dirichlet()
```
