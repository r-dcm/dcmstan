
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dcmstan <a href="https://dcmstan.r-dcm.org"><img src="man/figures/logo.png" align="right" height="138" alt="dcmstan website" /></a>

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![R package
version](https://www.r-pkg.org/badges/version/dcmstan)](https://cran.r-project.org/web/packages/dcmstan)
[![Package
downloads](https://cranlogs.r-pkg.org/badges/grand-total/dcmstan)](https://cran.r-project.org/web/packages/dcmstan)</br>
[![R-CMD-check](https://github.com/r-dcm/dcmstan/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r-dcm/dcmstan/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/r-dcm/dcmstan/graph/badge.svg?token=D6qTsKTROZ)](https://app.codecov.io/gh/r-dcm/dcmstan)
[![pages-build-deployment](https://github.com/r-dcm/dcmstan/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/r-dcm/dcmstan/actions/workflows/pages/pages-build-deployment)</br>
[![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/wjakethompson)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/mit)
<!-- badges: end -->

dcmstan provides functionality to automatically generate
[*Stan*](https://mc-stan.org) code for estimating diagnostic
classification models. Using dcmstan, you can:

- Mix and match different
  [measurement](https://dcmstan.r-dcm.org/reference/measurement-model)
  and [structural](https://dcmstan.r-dcm.org/reference/structural-model)
  models to specify a diagnostic model with `dcm_specify()`,
- Define `prior()` distributions, and
- Generate Stan code for the model, given the specifications and priors
  with `stan_code()`

dcmstan is used as a backend for generating the Stan code needed to
estimate and evaluate with the [measr](https://measr.info) package. If
you use measr to estimate your models, you will not need to use dcmstan
to generate Stan code yourself.

## Installation

You can install the released version of dcmstan from
[CRAN](https://cran.r-project.org/) with:

``` r
install.packages("dcmstan")
```

And the development version from [GitHub](https://github.com) with:

``` r
# install.packages("pak")
pak::pak("r-dcm/dcmstan")
```

## Usage

We can create a specification for a diagnostic model using
`dcm_specify()`, which requires a Q-matrix, the name of the item
identifier column in the Q-matrix (optional), and the choice of
measurement and structural models.

``` r
library(dcmstan)
library(dcmdata)

new_model <- dcm_specify(
  qmatrix = mdm_qmatrix,
  identifier = "item",
  measurement_model = lcdm(),
  structural_model = unconstrained()
)

new_model
#> A loglinear cognitive diagnostic model (LCDM) measuring 1 attributes with 4
#> items.
#> 
#> ℹ Attributes:
#> • "multiplication" (4 items)
#> 
#> ℹ Attribute structure:
#>   Unconstrained
#> 
#> ℹ Prior distributions:
#>   intercept ~ normal(0, 2)
#>   maineffect ~ lognormal(0, 1)
#>   `Vc` ~ dirichlet(1)
```

We can then generate the *Stan* code and data list required for
estimating the model with `{rstan}` or `{cmdstanr}`.

``` r
stan_code(new_model)
#> data {
#>   int<lower=1> I;                      // number of items
#>   int<lower=1> R;                      // number of respondents
#>   int<lower=1> N;                      // number of observations
#>   int<lower=1> C;                      // number of classes
#>   array[N] int<lower=1,upper=I> ii;    // item for observation n
#>   array[N] int<lower=1,upper=R> rr;    // respondent for observation n
#>   array[N] int<lower=0,upper=1> y;     // score for observation n
#>   array[R] int<lower=1,upper=N> start; // starting row for respondent R
#>   array[R] int<lower=1,upper=I> num;   // number items for respondent R
#> }
#> parameters {
#>   simplex[C] Vc;
#> 
#>   ////////////////////////////////// item intercepts
#>   real l1_0;
#>   real l2_0;
#>   real l3_0;
#>   real l4_0;
#> 
#>   ////////////////////////////////// item main effects
#>   real<lower=0> l1_11;
#>   real<lower=0> l2_11;
#>   real<lower=0> l3_11;
#>   real<lower=0> l4_11;
#> }
#> transformed parameters {
#>   vector[C] log_Vc = log(Vc);
#>   matrix[I,C] pi;
#> 
#>   ////////////////////////////////// probability of correct response
#>   pi[1,1] = inv_logit(l1_0);
#>   pi[1,2] = inv_logit(l1_0+l1_11);
#>   pi[2,1] = inv_logit(l2_0);
#>   pi[2,2] = inv_logit(l2_0+l2_11);
#>   pi[3,1] = inv_logit(l3_0);
#>   pi[3,2] = inv_logit(l3_0+l3_11);
#>   pi[4,1] = inv_logit(l4_0);
#>   pi[4,2] = inv_logit(l4_0+l4_11);
#> }
#> model {
#>   ////////////////////////////////// priors
#>   Vc ~ dirichlet(rep_vector(1, C));
#>   l1_0 ~ normal(0, 2);
#>   l1_11 ~ lognormal(0, 1);
#>   l2_0 ~ normal(0, 2);
#>   l2_11 ~ lognormal(0, 1);
#>   l3_0 ~ normal(0, 2);
#>   l3_11 ~ lognormal(0, 1);
#>   l4_0 ~ normal(0, 2);
#>   l4_11 ~ lognormal(0, 1);
#> 
#>   ////////////////////////////////// likelihood
#>   for (r in 1:R) {
#>     row_vector[C] ps;
#>     for (c in 1:C) {
#>       array[num[r]] real log_items;
#>       for (m in 1:num[r]) {
#>         int i = ii[start[r] + m - 1];
#>         log_items[m] = y[start[r] + m - 1] * log(pi[i,c]) +
#>                        (1 - y[start[r] + m - 1]) * log(1 - pi[i,c]);
#>       }
#>       ps[c] = log_Vc[c] + sum(log_items);
#>     }
#>     target += log_sum_exp(ps);
#>   }
#> }

stan_data(new_model, data = mdm_data, identifier = "respondent") |>
  str()
#> List of 9
#>  $ I    : int 4
#>  $ R    : int 142
#>  $ N    : int 568
#>  $ C    : int 2
#>  $ ii   : num [1:568] 1 2 3 4 1 2 3 4 1 2 ...
#>  $ rr   : num [1:568] 1 1 1 1 2 2 2 2 3 3 ...
#>  $ y    : int [1:568] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ start: int [1:142] 1 5 9 13 17 21 25 29 33 37 ...
#>  $ num  : int [1:142] 4 4 4 4 4 4 4 4 4 4 ...
```

------------------------------------------------------------------------

## Contributions and Code of Conduct

Contributions are welcome. To ensure a smooth process, please review the
[Contributing Guide](https://dcmstan.r-dcm.org/CONTRIBUTING.html).
Please note that the dcmstan project is released with a [Contributor
Code of Conduct](https://dcmstan.r-dcm.org/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
