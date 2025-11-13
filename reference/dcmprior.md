# S7 prior class

The `dcmprior` constructor is exported to facilitate the defining of
methods in other packages. We do not expect or recommend calling this
function directly. Rather, to create a model specification, one should
use [`prior()`](https://dcmstan.r-dcm.org/reference/prior.md) or
[`default_dcm_priors()`](https://dcmstan.r-dcm.org/reference/default_dcm_priors.md).

## Usage

``` r
dcmprior(
  distribution = character(0),
  type = NA_character_,
  coefficient = NA_character_,
  lower_bound = NA_real_,
  upper_bound = NA_real_
)
```

## Arguments

- distribution:

  A distribution statement for the prior (e.g., `normal(0, 2)`). For a
  complete list of available distributions, see the *Stan* documentation
  at <https://mc-stan.org/docs/>.

- type:

  The type of parameter to apply the prior to. Parameter types will vary
  by model. Use
  [`get_parameters()`](https://dcmstan.r-dcm.org/reference/get_parameters.md)
  to see list of possible types for the chosen model.

- coefficient:

  Name of a specific parameter within the defined parameter type. If
  `NA` (the default), the prior is applied to all parameters within the
  type.

- lower_bound:

  Optional. The lower bound where the distribution should be truncated.

- upper_bound:

  Optional. The upper bound where the distribution should be truncated.

## Value

A `dcmprior` object.

## See also

[`prior()`](https://dcmstan.r-dcm.org/reference/prior.md),
[`default_dcm_priors()`](https://dcmstan.r-dcm.org/reference/default_dcm_priors.md)

## Examples

``` r
dcmprior(
  distribution = "normal(0, 1)",
  type = "intercept"
)
#> # A tibble: 1 × 3
#>   type      coefficient prior       
#>   <chr>     <chr>       <chr>       
#> 1 intercept NA          normal(0, 1)
```
