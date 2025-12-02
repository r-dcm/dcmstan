# Generate mastery profiles

Given the number of attributes or model specification, generate all
possible attribute patterns.

## Usage

``` r
create_profiles(x, ...)
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

  Additional arguments passed to methods. See details.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)
with all possible attribute patterns. Each row is a profile, and each
column indicates whether the attribute in that column was present (1) or
not (0).

## Details

Additional arguments passed to methods:

`keep_names`: When `x` is a [model
specification](https://dcmstan.r-dcm.org/dev/reference/dcm_specify.md),
should the real attribute names be used (`TRUE`; the default), or
replaced with generic names (`FALSE`; e.g., `"att1"`, `"att2"`,
`"att3"`).

`attributes`: When `x` is a [structural
model](https://dcmstan.r-dcm.org/dev/reference/structural-model.md), a
vector of attribute names, as in the `qmatrix_meta$attribute_names` of a
[DCM
specification](https://dcmstan.r-dcm.org/dev/reference/dcm_specify.md).

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

create_profiles(unconstrained(), attributes = c("att1", "att2"))
#> # A tibble: 4 × 2
#>    att1  att2
#>   <int> <int>
#> 1     0     0
#> 2     1     0
#> 3     0     1
#> 4     1     1

create_profiles(hdcm("att1 -> att2 -> att3"),
                attributes = c("att1", "att2", "att3"))
#> # A tibble: 4 × 3
#>    att1  att2  att3
#>   <int> <int> <int>
#> 1     0     0     0
#> 2     1     0     0
#> 3     1     1     0
#> 4     1     1     1
```
