# Coerce a dcmprior object to a tibble

`prior_tibble()` converts prior specifications into a
[tibble](https://tibble.tidyverse.org/reference/tibble-package.html),
with one row per prior.

## Usage

``` r
prior_tibble(x, ...)

## S7 method for class <dcmstan::dcmprior>
prior_tibble(x, .keep_all = FALSE)
```

## Arguments

- x:

  An object containing prior specifications (e.g., a
  [`dcmprior`](https://dcmstan.r-dcm.org/dev/reference/prior.md)
  object).

- ...:

  Additional arguments passed to methods.

- .keep_all:

  Logical indicating if all components should be returned. When `FALSE`
  (the default), only the `@type`, `@coefficient`, and `@prior`
  properties of the
  [`dcmprior`](https://dcmstan.r-dcm.org/dev/reference/prior.md) object
  are returned. When `TRUE`, the `@distribution`, `@lower_bound`, and
  `@upper_bound` properties are also returned.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)
showing the specified priors.

## Methods

`prior_tibble()` is an S7 generic with methods available for the
following classes:

- [`dcmstan::dcmprior`](https://dcmstan.r-dcm.org/dev/reference/dcmprior.md)

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
