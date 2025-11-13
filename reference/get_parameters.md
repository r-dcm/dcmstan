# Identify parameters included in a diagnostic classification model

When specifying prior distributions, it is often useful to see which
parameters are included in a given model. Using the Q-matrix and type of
diagnostic model to estimated, we can create a list of all included
parameters for which a prior can be specified.

## Usage

``` r
get_parameters(x, qmatrix, ..., identifier = NULL)
```

## Arguments

- x:

  A model specification (e.g.,
  [`dcm_specify()`](https://dcmstan.r-dcm.org/reference/dcm_specify.md),
  measurement model (e.g.,
  [`lcdm()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)),
  or structural model (e.g.,
  [`unconstrained()`](https://dcmstan.r-dcm.org/reference/structural-model.md))
  object.

- qmatrix:

  The Q-matrix. A data frame with 1 row per item and 1 column per
  attribute. May optionally include an additional column of item
  identifiers. If an identifier column is included, this should be
  specified with `identifier`. All cells for the remaining attribute
  columns should be either 0 (item does not measure the attribute) or 1
  (item does measure the attribute).

- ...:

  Additional arguments passed to methods.

- identifier:

  Optional. If present, the quoted name of the column in the `qmatrix`
  that contains item identifiers.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)
showing the available parameter types and coefficients for a specified
model.

## Examples

``` r
qmatrix <- tibble::tibble(item = paste0("item_", 1:10),
                          att1 = sample(0:1, size = 10, replace = TRUE),
                          att2 = sample(0:1, size = 10, replace = TRUE),
                          att3 = sample(0:1, size = 10, replace = TRUE),
                          att4 = sample(0:1, size = 10, replace = TRUE))
get_parameters(dina(), qmatrix = qmatrix, identifier = "item")
#> # A tibble: 20 × 3
#>    item    type  coefficient
#>    <chr>   <chr> <chr>      
#>  1 item_1  slip  slip[1]    
#>  2 item_1  guess guess[1]   
#>  3 item_2  slip  slip[2]    
#>  4 item_2  guess guess[2]   
#>  5 item_3  slip  slip[3]    
#>  6 item_3  guess guess[3]   
#>  7 item_4  slip  slip[4]    
#>  8 item_4  guess guess[4]   
#>  9 item_5  slip  slip[5]    
#> 10 item_5  guess guess[5]   
#> 11 item_6  slip  slip[6]    
#> 12 item_6  guess guess[6]   
#> 13 item_7  slip  slip[7]    
#> 14 item_7  guess guess[7]   
#> 15 item_8  slip  slip[8]    
#> 16 item_8  guess guess[8]   
#> 17 item_9  slip  slip[9]    
#> 18 item_9  guess guess[9]   
#> 19 item_10 slip  slip[10]   
#> 20 item_10 guess guess[10]  
```
