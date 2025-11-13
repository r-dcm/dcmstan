# Prior definitions for diagnostic classification models

Define prior distributions for types of parameters or specific
parameters within a model. For a complete list of types and parameters
available for a given model, see
[`get_parameters()`](https://dcmstan.r-dcm.org/reference/get_parameters.md).

## Usage

``` r
prior(distribution, type, coefficient = NA, lower_bound = NA, upper_bound = NA)

prior_string(distribution, ...)
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

- ...:

  Additional arguments passed to `prior()`.

## Value

A `dcmprior` object.

## Details

`prior()` should be used for directly specifying priors. That is, when
you are directly typing out or providing the distribution statement to
the function. If you have previously created a variable with a
distribution statement as a character string (e.g.,
`dist <- "normal(0, 2)"`), then you should use `prior_string()` to
create your prior. See examples.

## See also

[`get_parameters()`](https://dcmstan.r-dcm.org/reference/get_parameters.md)

## Examples

``` r
prior(normal(0, 2), type = "intercept")
#> # A tibble: 1 × 3
#>   type      coefficient prior       
#>   <chr>     <chr>       <chr>       
#> 1 intercept NA          normal(0, 2)

c(prior(beta(5, 17), type = "slip"),
  prior(beta(5, 25), type = "guess"))
#> # A tibble: 2 × 3
#>   type  coefficient prior      
#>   <chr> <chr>       <chr>      
#> 1 slip  NA          beta(5, 17)
#> 2 guess NA          beta(5, 25)

my_prior <- "normal(0, 2)"
prior_string(my_prior, type = "intercept")
#> # A tibble: 1 × 3
#>   type      coefficient prior       
#>   <chr>     <chr>       <chr>       
#> 1 intercept NA          normal(0, 2)
```
