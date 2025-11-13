# Default priors for diagnostic classification models

View the prior distributions that are applied by default when using a
given measurement and structural model.

## Usage

``` r
default_dcm_priors(measurement_model = NULL, structural_model = NULL)
```

## Arguments

- measurement_model:

  A [measurement
  model](https://dcmstan.r-dcm.org/reference/measurement-model.md)
  object.

- structural_model:

  A [structural
  model](https://dcmstan.r-dcm.org/reference/structural-model.md)
  object.

## Value

A `dcmprior` object.

## Examples

``` r
default_dcm_priors(lcdm(), unconstrained())
#> # A tibble: 4 × 3
#>   type        coefficient prior                      
#>   <chr>       <chr>       <chr>                      
#> 1 intercept   NA          normal(0, 2)               
#> 2 maineffect  NA          lognormal(0, 1)            
#> 3 interaction NA          normal(0, 2)               
#> 4 structural  Vc          dirichlet(rep_vector(1, C))
default_dcm_priors(dina(), independent())
#> # A tibble: 3 × 3
#>   type       coefficient prior      
#>   <chr>      <chr>       <chr>      
#> 1 slip       NA          beta(5, 25)
#> 2 guess      NA          beta(5, 25)
#> 3 structural NA          beta(1, 1) 
default_dcm_priors(lcdm(), loglinear())
#> # A tibble: 5 × 3
#>   type                   coefficient prior          
#>   <chr>                  <chr>       <chr>          
#> 1 intercept              NA          normal(0, 2)   
#> 2 maineffect             NA          lognormal(0, 1)
#> 3 interaction            NA          normal(0, 2)   
#> 4 structural_maineffect  NA          normal(0, 10)  
#> 5 structural_interaction NA          normal(0, 10)  
```
