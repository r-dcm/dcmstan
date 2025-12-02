# Coerce a dcmprior object to a tibble

When specifying prior distributions, it is often useful to see which
parameters are included in a given model. Using the Q-matrix and type of
diagnostic model to estimated, we can create a list of all included
parameters for which a prior can be specified.

## Usage

``` r
prior_tibble(x, ...)
```

## Arguments

- x:

  A model specification (e.g.,
  [`dcm_specify()`](https://dcmstan.r-dcm.org/dev/reference/dcm_specify.md),
  measurement model (e.g.,
  [`lcdm()`](https://dcmstan.r-dcm.org/dev/reference/measurement-model.md)),
  or structural model (e.g.,
  [`unconstrained()`](https://dcmstan.r-dcm.org/dev/reference/structural-model.md))
  object.

- ...:

  Additional arguments passed to methods. See details.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)
showing the specified priors.

## Details

Additional arguments passed to methods:

`.keep_all`: Logical indicating if all components should be returned.
When `FALSE` (the default), only the `@type`, `@coefficient`, and
`@prior` elements of the
[dcmprior](https://dcmstan.r-dcm.org/dev/reference/prior.md) object is
return. When `TRUE`, the `@distribtuion`, `@lower_bound`, and
`@upper_bound` are also returned.

## Examples

``` r
prior_tibble(default_dcm_priors(lcdm()))
#> # A tibble: 3 × 3
#>   type        coefficient prior          
#>   <chr>       <chr>       <chr>          
#> 1 intercept   NA          normal(0, 2)   
#> 2 maineffect  NA          lognormal(0, 1)
#> 3 interaction NA          normal(0, 2)   

prior_tibble(default_dcm_priors(dina(), independent()))
#> # A tibble: 3 × 3
#>   type       coefficient prior      
#>   <chr>      <chr>       <chr>      
#> 1 slip       NA          beta(5, 25)
#> 2 guess      NA          beta(5, 25)
#> 3 structural NA          beta(1, 1) 
```
