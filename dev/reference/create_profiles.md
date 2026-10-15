# Possible attribute profiles

`create_profiles()` determines the possible attribute profiles.

## Usage

``` r
create_profiles(x, ...)

## S7 method for class <dcmstan::dcm_specification>
create_profiles(x, keep_names = TRUE)

## S7 method for class <dcmstan::structural>
create_profiles(x, attributes, keep_names = TRUE)

## S7 method for class <dcmstan::HDCM>
create_profiles(x, attributes = NULL, keep_names = TRUE)
```

## Arguments

- x:

  An object used to generate the possible patterns. This could be a
  number (the number of attributes; e.g., `3`, `4`), or an object that
  defines attribute relationships (e.g., a [structural
  model](https://dcmstan.r-dcm.org/dev/reference/structural-model.md) or
  [model
  specification](https://dcmstan.r-dcm.org/dev/reference/dcm_specify.md)).

- ...:

  Additional arguments passed to methods.

- keep_names:

  Logical. Should the real attribute names be used (`TRUE`; the default)
  or replaced with generic names (`FALSE`; e.g., `"att1"`, `"att2"`,
  `"att3"`).

- attributes:

  A named vector of attributes, as in the `qmatrix_meta$attribute_names`
  of a [DCM
  specification](https://dcmstan.r-dcm.org/dev/reference/dcm_specify.md).
  For
  [`hdcm()`](https://dcmstan.r-dcm.org/dev/reference/structural-model.md)
  structural models, `attributes` may be `NULL` (the default), in which
  case attribute names are pulled from the specified hierarchy.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)
with all possible attribute patterns. Each row is a profile, and each
column indicates whether the attribute in that column was present (1) or
not (0).

## Methods

`create_profiles()` is an S7 generic with methods available for the
following classes:

- `dcmstan::HDCM`

- [`dcmstan::dcm_specification`](https://dcmstan.r-dcm.org/dev/reference/dcm_specification.md)

- `dcmstan::structural`

- `double`

- `integer`

## Examples

``` r
create_profiles(3L)
#> # A tibble: 8 × 3
#>    att1  att2  att3
#>   <int> <int> <int>
#> 1     0     0     0
#> 2     1     0     0
#> 3     0     1     0
#> 4     0     0     1
#> 5     1     1     0
#> 6     1     0     1
#> 7     0     1     1
#> 8     1     1     1

create_profiles(5)
#> # A tibble: 32 × 5
#>     att1  att2  att3  att4  att5
#>    <int> <int> <int> <int> <int>
#>  1     0     0     0     0     0
#>  2     1     0     0     0     0
#>  3     0     1     0     0     0
#>  4     0     0     1     0     0
#>  5     0     0     0     1     0
#>  6     0     0     0     0     1
#>  7     1     1     0     0     0
#>  8     1     0     1     0     0
#>  9     1     0     0     1     0
#> 10     1     0     0     0     1
#> # ℹ 22 more rows

create_profiles(unconstrained(), attributes = c("math", "science"))
#> # A tibble: 4 × 2
#>    math science
#>   <int>   <int>
#> 1     0       0
#> 2     1       0
#> 3     0       1
#> 4     1       1

create_profiles(hdcm("first -> second -> third"), keep_names = FALSE)
#> # A tibble: 4 × 3
#>    att1  att2  att3
#>   <int> <int> <int>
#> 1     0     0     0
#> 2     1     0     0
#> 3     1     1     0
#> 4     1     1     1
```
