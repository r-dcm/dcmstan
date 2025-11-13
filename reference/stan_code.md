# Generate 'Stan' code for a diagnostic classification models

Given a specification for a diagnostic classification model or a
generated quantities definition, automatically generate the 'Stan' code
necessary to estimate the model. For details on how the code blocks
relate to diagnostic models, see da Silva et al. (2017), Jiang and
Carter (2019), and Thompson (2019).

## Usage

``` r
stan_code(x, ...)
```

## Arguments

- x:

  A [model
  specification](https://dcmstan.r-dcm.org/reference/dcm_specify.md) or
  [generated
  quantities](https://dcmstan.r-dcm.org/reference/generated-quantities.md)
  object.

- ...:

  Additional arguments passed to methods.

## Value

A [glue](https://glue.tidyverse.org/reference/as_glue.html) object
containing the 'Stan' code for the specified model.

## References

da Silva, M. A., de Oliveira, E. S. B., von Davier, A. A., and Bazán, J.
L. (2017). Estimating the DINA model parameters using the No-U-Turn
sampler. *Biometrical Journal, 60*(2), 352-368.
[doi:10.1002/bimj.201600225](https://doi.org/10.1002/bimj.201600225)

Jiang, Z., & Carter, R. (2019). Using Hamiltonian Monte Carlo to
estimate the log-linear cognitive diagnosis model via Stan. *Behavior
Research Methods, 51*, 651-662.
[doi:10.3758/s13428-018-1069-9](https://doi.org/10.3758/s13428-018-1069-9)

Thompson, W. J. (2019). *Bayesian psychometrics for diagnostic
assessments: A proof of concept* (Research Report No. 19-01). University
of Kansas; Accessible Teaching, Learning, and Assessment Systems.
[doi:10.35542/osf.io/jzqs8](https://doi.org/10.35542/osf.io/jzqs8)

## Examples

``` r
qmatrix <- data.frame(
  att1 = sample(0:1, size = 5, replace = TRUE),
  att2 = sample(0:1, size = 5, replace = TRUE)
)

model_spec <- dcm_specify(qmatrix = qmatrix,
                          measurement_model = lcdm(),
                          structural_model = unconstrained())

stan_code(model_spec)
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
#>   real l5_0;
#> 
#>   ////////////////////////////////// item main effects
#>   real<lower=0> l1_11;
#>   real<lower=0> l1_12;
#>   real<lower=0> l2_11;
#>   real<lower=0> l3_12;
#>   real<lower=0> l4_11;
#>   real<lower=0> l5_12;
#> 
#>   ////////////////////////////////// item interactions
#>   real<lower=-1 * min([l1_11,l1_12])> l1_212;
#> }
#> transformed parameters {
#>   vector[C] log_Vc = log(Vc);
#>   matrix[I,C] pi;
#> 
#>   ////////////////////////////////// probability of correct response
#>   pi[1,1] = inv_logit(l1_0);
#>   pi[1,2] = inv_logit(l1_0+l1_11);
#>   pi[1,3] = inv_logit(l1_0+l1_12);
#>   pi[1,4] = inv_logit(l1_0+l1_11+l1_12+l1_212);
#>   pi[2,1] = inv_logit(l2_0);
#>   pi[2,2] = inv_logit(l2_0+l2_11);
#>   pi[2,3] = inv_logit(l2_0);
#>   pi[2,4] = inv_logit(l2_0+l2_11);
#>   pi[3,1] = inv_logit(l3_0);
#>   pi[3,2] = inv_logit(l3_0);
#>   pi[3,3] = inv_logit(l3_0+l3_12);
#>   pi[3,4] = inv_logit(l3_0+l3_12);
#>   pi[4,1] = inv_logit(l4_0);
#>   pi[4,2] = inv_logit(l4_0+l4_11);
#>   pi[4,3] = inv_logit(l4_0);
#>   pi[4,4] = inv_logit(l4_0+l4_11);
#>   pi[5,1] = inv_logit(l5_0);
#>   pi[5,2] = inv_logit(l5_0);
#>   pi[5,3] = inv_logit(l5_0+l5_12);
#>   pi[5,4] = inv_logit(l5_0+l5_12);
#> }
#> model {
#>   ////////////////////////////////// priors
#>   Vc ~ dirichlet(rep_vector(1, C));
#>   l1_0 ~ normal(0, 2);
#>   l1_11 ~ lognormal(0, 1);
#>   l1_12 ~ lognormal(0, 1);
#>   l1_212 ~ normal(0, 2);
#>   l2_0 ~ normal(0, 2);
#>   l2_11 ~ lognormal(0, 1);
#>   l3_0 ~ normal(0, 2);
#>   l3_12 ~ lognormal(0, 1);
#>   l4_0 ~ normal(0, 2);
#>   l4_11 ~ lognormal(0, 1);
#>   l5_0 ~ normal(0, 2);
#>   l5_12 ~ lognormal(0, 1);
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
```
