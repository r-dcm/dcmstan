# Introduction to dcmstan

dcmstan is an R package that generates the [*Stan*](https://mc-stan.org)
code needed for estimating diagnostic classification models (DCMs; also
known as cognitive diagnostic models \[CDMs\]). dcmstan provides
functionality for all major DCMs that are used in practice and supports
the specification of both measurement and structural models. Here,
you’ll find a brief overview of how to specify a diagnostic model and
generate the associated *Stan* code.

``` r
library(dcmstan)
```

## Specifying a DCM

We create a specification using
[`dcm_specify()`](https://dcmstan.r-dcm.org/reference/dcm_specify.md).
First, we must define our Q-matrix, which represents how the assessment
items relate to the latent attributes. For this example, we’ll create a
specification for the simulated “Diagnostic Teachers’ Multiplicative
Reasoning” (DTMR) data. In the DTMR data, there are 27 items that
collectively measure 4 attributes (for more information see
[`?dcmdata::dtmr`](https://dcmdata.r-dcm.org/reference/dtmr.html)).

``` r
library(dcmdata)

dtmr_qmatrix
#> # A tibble: 27 × 5
#>    item  referent_units partitioning_iterating appropriateness
#>    <chr>          <dbl>                  <dbl>           <dbl>
#>  1 1                  1                      0               0
#>  2 2                  0                      0               1
#>  3 3                  0                      1               0
#>  4 4                  1                      0               0
#>  5 5                  1                      0               0
#>  6 6                  0                      1               0
#>  7 7                  1                      0               0
#>  8 8a                 0                      0               1
#>  9 8b                 0                      0               1
#> 10 8c                 0                      0               1
#> # ℹ 17 more rows
#> # ℹ 1 more variable: multiplicative_comparison <dbl>
```

In the Q-matrix, a `1` indicates that the attribute (in the columns) is
measured by a given item (in the rows). Our Q-matrix also includes an
item identifier with the item names or identifiers. We pass the Q-matrix
and the (optional) identifier to
[`dcm_specify()`](https://dcmstan.r-dcm.org/reference/dcm_specify.md).
We can then specify our chosen measurement and structural models. Here,
we keep the default
[`unconstrained()`](https://dcmstan.r-dcm.org/reference/structural-model.md)
structural model but overwrite the default
[`lcdm()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)
measurement model to specify a
[`dina()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)
model. These options are described in more detail in the following
sections.

``` r
spec <- dcm_specify(
  qmatrix = dtmr_qmatrix,
  identifier = "item",
  measurement_model = dina(),
  structural_model = bayesnet()
)

spec
#> A deterministic input, noisy "and" gate (DINA) model measuring 4
#> attributes with 27 items.
#> 
#> ℹ Attributes:
#> • "referent_units" (15 items)
#> • "partitioning_iterating" (10 items)
#> • "appropriateness" (5 items)
#> • "multiplicative_comparison" (5 items)
#> 
#> ℹ Attribute structure:
#>   Bayesian network,
#>   with structure:
#>   referent_units -> partitioning_iterating referent_units ->
#>   appropriateness referent_units -> multiplicative_comparison
#>   partitioning_iterating -> appropriateness partitioning_iterating ->
#>   multiplicative_comparison appropriateness -> multiplicative_comparison
#> 
#> ℹ Prior distributions:
#>   slip ~ beta(5, 25)
#>   guess ~ beta(5, 25)
#>   structural_intercept ~ normal(0, 2)
#>   structural_maineffect ~ lognormal(0, 1)
#>   structural_interaction ~ normal(0, 2)
```

### Measurement models

The measurement model defines how attributes relate to the items. For
example, take item 10b in the DTMR Q-matrix, which measures both
Referent Units and Multiplicative Comparison. Does a respondent need to
be proficient on both attributes in order to answer the item correct?
Just one of the attributes? Or maybe proficiency on one of the
attributes makes it more likely the respondent will provide a correct
response, but not as likely as if they were proficient on both?

These relationships are determined by the measurement model. dcmstan
supports several measurement models that each make different assumptions
about how items relate to the measured attributes. Specifically, we
support the six core DCMs identified by ([Rupp et al.,
2010](#ref-rupp-dcm)), as well as the general loglinear cognitive
diagnostic model (LCDM; [Henson et al., 2009](#ref-lcdm); [Henson &
Templin, 2019](#ref-lcdm-handbook)) which subsumes the more restrictive
core DCMs. For more information on each measurement model, see
[`` ?`measurement-model` ``](https://dcmstan.r-dcm.org/reference/measurement-model.md)
and the accompanying references.

| Model                                         | Abbreviation |                 Reference                 |                                dcmstan                                |
|:----------------------------------------------|:------------:|:-----------------------------------------:|:---------------------------------------------------------------------:|
| Loglinear cognitive diagnostic model          |     LCDM     |     Henson et al. ([2009](#ref-lcdm))     | [`lcdm()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)  |
| Deterministic input, noisy “and” gate         |     DINA     | de la Torre & Douglas ([2004](#ref-dina)) | [`dina()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)  |
| Deterministic input, noisy “or” gate          |     DINO     |   Templin & Henson ([2006](#ref-dino))    | [`dino()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)  |
| Noisy-input, deterministic “and” gate         |     NIDA     |   Junker & Sijtsma ([2001](#ref-nida))    | [`nida()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)  |
| Noisy-input, deterministic “or” gate          |     NIDO     |        Templin ([2006](#ref-nido))        | [`nido()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)  |
| Noncompensatory reparameterized unified model |    NC-RUM    |    DiBello et al. ([1995](#ref-ncrum))    | [`ncrum()`](https://dcmstan.r-dcm.org/reference/measurement-model.md) |
| Compensatory reparameterized unified model    |    C-RUM     |         Hartz ([2002](#ref-crum))         | [`crum()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)  |

Supported measurement models

### Structural models

Whereas the measurement model defines how the attributes relate to the
items, the structural model defines how the attributes relate to each
other. For example, it could be that the attributes following a specific
ordering or hierarchy, such as a learning progression, where a
respondent must be proficient on one attribute prior to gaining
proficiency on another. Or perhaps the proficiency statuses of different
attributes are completely independent.

The inter-attribute relationships are defined by the structural model.
dcmstan supports several structural models that each allow for different
specifications for how the attributes relate to each other.
Specifically, we support a range of interrelatedness from unconstrained
to fully independent attributes with the unconstrained, independent, and
loglinear models. We also support the specification of specific
relationships and hierarchies through the hierarchical diagnostic
classification model and Bayesian network structural models. For more
information on each structural model, see
[`` ?`structural-model` ``](https://dcmstan.r-dcm.org/reference/structural-model.md)
and the accompanying references.

| Model            | Abbreviation |                Reference                 |                                   dcmstan                                    |
|:-----------------|:------------:|:----------------------------------------:|:----------------------------------------------------------------------------:|
| Unconstrained    |              |   Rupp et al. ([2010](#ref-rupp-dcm))    | [`unconstrained()`](https://dcmstan.r-dcm.org/reference/structural-model.md) |
| Independent      |              |      Lee ([2017](#ref-independent))      |  [`independent()`](https://dcmstan.r-dcm.org/reference/structural-model.md)  |
| Loglinear        |              | Xu & von Davier ([2008](#ref-loglinear)) |   [`loglinear()`](https://dcmstan.r-dcm.org/reference/structural-model.md)   |
| Hierarchical DCM |     HDCM     |  Templin & Bradshaw ([2014](#ref-hdcm))  |     [`hdcm()`](https://dcmstan.r-dcm.org/reference/structural-model.md)      |
| Bayesian network |      BN      |   Hu & Templin ([2020](#ref-bayesnet))   |   [`bayesnet()`](https://dcmstan.r-dcm.org/reference/structural-model.md)    |

Supported structural models

## From specification to estimation

Once we have specified a model, we can create the necessary *Stan* code
using [`stan_code()`](https://dcmstan.r-dcm.org/reference/stan_code.md).

``` r
stan_code(spec)
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
#>   matrix[I,C] Xi;                      // class attribute indicator
#> }
#> parameters {
#>   ////////////////////////////////// structural intercepts
#>   real g1_0;
#>   real g2_0;
#>   real g3_0;
#>   real g4_0;
#> 
#>   ////////////////////////////////// structural main effects
#>   real<lower=0> g2_11;
#>   real<lower=0> g3_11;
#>   real<lower=0> g4_11;
#>   real<lower=0> g3_12;
#>   real<lower=0> g4_12;
#>   real<lower=0> g4_13;
#> 
#>   ////////////////////////////////// structural interactions
#>   real<lower=-1 * min([g3_11,g3_12])> g3_212;
#>   real<lower=-1 * min([g4_11,g4_12])> g4_212;
#>   real<lower=-1 * min([g4_11,g4_13])> g4_213;
#>   real<lower=-1 * min([g4_12,g4_13])> g4_223;
#>   real<lower=-1 * min([g4_11+g4_212+g4_213,g4_12+g4_212+g4_223,g4_13+g4_213+g4_223])> g4_3123;
#> 
#>   ////////////////////////////////// item parameters
#>   array[I] real<lower=0,upper=1> slip;
#>   array[I] real<lower=0,upper=1> guess;
#> }
#> transformed parameters {
#>   simplex[C] Vc;
#>   vector[C] log_Vc;
#> 
#>   ////////////////////////////////// class membership probabilities
#>   Vc[1] = (1 - inv_logit(g1_0)) * (1 - inv_logit(g2_0)) * (1 - inv_logit(g3_0)) * (1 - inv_logit(g4_0));
#>   Vc[2] = inv_logit(g1_0) * (1 - inv_logit(g2_0 + g2_11)) * (1 - inv_logit(g3_0 + g3_11)) * (1 - inv_logit(g4_0 + g4_11));
#>   Vc[3] = (1 - inv_logit(g1_0)) * inv_logit(g2_0) * (1 - inv_logit(g3_0 + g3_12)) * (1 - inv_logit(g4_0 + g4_12));
#>   Vc[4] = (1 - inv_logit(g1_0)) * (1 - inv_logit(g2_0)) * inv_logit(g3_0) * (1 - inv_logit(g4_0 + g4_13));
#>   Vc[5] = (1 - inv_logit(g1_0)) * (1 - inv_logit(g2_0)) * (1 - inv_logit(g3_0)) * inv_logit(g4_0);
#>   Vc[6] = inv_logit(g1_0) * inv_logit(g2_0 + g2_11) * (1 - inv_logit(g3_0 + g3_11 + g3_12 + g3_212)) * (1 - inv_logit(g4_0 + g4_11 + g4_12 + g4_212));
#>   Vc[7] = inv_logit(g1_0) * (1 - inv_logit(g2_0 + g2_11)) * inv_logit(g3_0 + g3_11) * (1 - inv_logit(g4_0 + g4_11 + g4_13 + g4_213));
#>   Vc[8] = inv_logit(g1_0) * (1 - inv_logit(g2_0 + g2_11)) * (1 - inv_logit(g3_0 + g3_11)) * inv_logit(g4_0 + g4_11);
#>   Vc[9] = (1 - inv_logit(g1_0)) * inv_logit(g2_0) * inv_logit(g3_0 + g3_12) * (1 - inv_logit(g4_0 + g4_12 + g4_13 + g4_223));
#>   Vc[10] = (1 - inv_logit(g1_0)) * inv_logit(g2_0) * (1 - inv_logit(g3_0 + g3_12)) * inv_logit(g4_0 + g4_12);
#>   Vc[11] = (1 - inv_logit(g1_0)) * (1 - inv_logit(g2_0)) * inv_logit(g3_0) * inv_logit(g4_0 + g4_13);
#>   Vc[12] = inv_logit(g1_0) * inv_logit(g2_0 + g2_11) * inv_logit(g3_0 + g3_11 + g3_12 + g3_212) * (1 - inv_logit(g4_0 + g4_11 + g4_12 + g4_13 + g4_212 + g4_213 + g4_223 + g4_3123));
#>   Vc[13] = inv_logit(g1_0) * inv_logit(g2_0 + g2_11) * (1 - inv_logit(g3_0 + g3_11 + g3_12 + g3_212)) * inv_logit(g4_0 + g4_11 + g4_12 + g4_212);
#>   Vc[14] = inv_logit(g1_0) * (1 - inv_logit(g2_0 + g2_11)) * inv_logit(g3_0 + g3_11) * inv_logit(g4_0 + g4_11 + g4_13 + g4_213);
#>   Vc[15] = (1 - inv_logit(g1_0)) * inv_logit(g2_0) * inv_logit(g3_0 + g3_12) * inv_logit(g4_0 + g4_12 + g4_13 + g4_223);
#>   Vc[16] = inv_logit(g1_0) * inv_logit(g2_0 + g2_11) * inv_logit(g3_0 + g3_11 + g3_12 + g3_212) * inv_logit(g4_0 + g4_11 + g4_12 + g4_13 + g4_212 + g4_213 + g4_223 + g4_3123);
#> 
#>   log_Vc = log(Vc);
#>   matrix[I,C] pi;
#> 
#>   for (i in 1:I) {
#>     for (c in 1:C) {
#>       pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
#>     }
#>   }
#> }
#> model {
#>   ////////////////////////////////// priors
#>   g1_0 ~ normal(0, 2);
#>   g2_0 ~ normal(0, 2);
#>   g3_0 ~ normal(0, 2);
#>   g4_0 ~ normal(0, 2);
#>   g2_11 ~ lognormal(0, 1);
#>   g3_11 ~ lognormal(0, 1);
#>   g4_11 ~ lognormal(0, 1);
#>   g3_12 ~ lognormal(0, 1);
#>   g4_12 ~ lognormal(0, 1);
#>   g4_13 ~ lognormal(0, 1);
#>   g3_212 ~ normal(0, 2);
#>   g4_212 ~ normal(0, 2);
#>   g4_213 ~ normal(0, 2);
#>   g4_223 ~ normal(0, 2);
#>   g4_3123 ~ normal(0, 2);
#>   slip[1] ~ beta(5, 25);
#>   guess[1] ~ beta(5, 25);
#>   slip[2] ~ beta(5, 25);
#>   guess[2] ~ beta(5, 25);
#>   slip[3] ~ beta(5, 25);
#>   guess[3] ~ beta(5, 25);
#>   slip[4] ~ beta(5, 25);
#>   guess[4] ~ beta(5, 25);
#>   slip[5] ~ beta(5, 25);
#>   guess[5] ~ beta(5, 25);
#>   slip[6] ~ beta(5, 25);
#>   guess[6] ~ beta(5, 25);
#>   slip[7] ~ beta(5, 25);
#>   guess[7] ~ beta(5, 25);
#>   slip[8] ~ beta(5, 25);
#>   guess[8] ~ beta(5, 25);
#>   slip[9] ~ beta(5, 25);
#>   guess[9] ~ beta(5, 25);
#>   slip[10] ~ beta(5, 25);
#>   guess[10] ~ beta(5, 25);
#>   slip[11] ~ beta(5, 25);
#>   guess[11] ~ beta(5, 25);
#>   slip[12] ~ beta(5, 25);
#>   guess[12] ~ beta(5, 25);
#>   slip[13] ~ beta(5, 25);
#>   guess[13] ~ beta(5, 25);
#>   slip[14] ~ beta(5, 25);
#>   guess[14] ~ beta(5, 25);
#>   slip[15] ~ beta(5, 25);
#>   guess[15] ~ beta(5, 25);
#>   slip[16] ~ beta(5, 25);
#>   guess[16] ~ beta(5, 25);
#>   slip[17] ~ beta(5, 25);
#>   guess[17] ~ beta(5, 25);
#>   slip[18] ~ beta(5, 25);
#>   guess[18] ~ beta(5, 25);
#>   slip[19] ~ beta(5, 25);
#>   guess[19] ~ beta(5, 25);
#>   slip[20] ~ beta(5, 25);
#>   guess[20] ~ beta(5, 25);
#>   slip[21] ~ beta(5, 25);
#>   guess[21] ~ beta(5, 25);
#>   slip[22] ~ beta(5, 25);
#>   guess[22] ~ beta(5, 25);
#>   slip[23] ~ beta(5, 25);
#>   guess[23] ~ beta(5, 25);
#>   slip[24] ~ beta(5, 25);
#>   guess[24] ~ beta(5, 25);
#>   slip[25] ~ beta(5, 25);
#>   guess[25] ~ beta(5, 25);
#>   slip[26] ~ beta(5, 25);
#>   guess[26] ~ beta(5, 25);
#>   slip[27] ~ beta(5, 25);
#>   guess[27] ~ beta(5, 25);
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

This provides the code need for `rstan::stan()` to estimate the model.
You can either pass the code directly to the `model_code` argument, or
save the code to a file, customize it as needed, and then provide the
file path to the modified code to the `file` argument (see
`?rstan::stan` for additional guidance).

You will also need to create a list of data objects for *Stan*. This can
be accomplished using
[`stan_data()`](https://dcmstan.r-dcm.org/reference/stan_data.md). This
function takes our data set and the respondent identifier column name
(can be excluded if not present in `data`), and provides a list that can
be supplied to the `data` argument of `rstan::stan()`.

``` r
dtmr_data
#> # A tibble: 990 × 28
#>    id      `1`   `2`   `3`   `4`   `5`   `6`   `7`  `8a`  `8b`  `8c`  `8d`
#>    <fct> <int> <int> <int> <int> <int> <int> <int> <int> <int> <int> <int>
#>  1 0008…     1     1     0     1     0     0     1     1     0     1     1
#>  2 0009…     0     1     0     0     0     0     0     1     1     1     0
#>  3 0024…     0     1     0     0     0     0     1     1     1     1     0
#>  4 0031…     0     1     0     0     1     0     1     1     1     0     0
#>  5 0061…     0     1     1     0     0     0     0     0     0     1     0
#>  6 0087…     0     1     1     1     0     0     0     1     1     1     1
#>  7 0092…     0     1     1     1     1     0     0     1     1     1     0
#>  8 0097…     0     0     0     1     0     0     0     1     0     1     0
#>  9 0111…     0     1     1     0     0     0     0     1     0     1     1
#> 10 0121…     0     1     0     0     0     0     0     1     1     1     1
#> # ℹ 980 more rows
#> # ℹ 16 more variables: `9` <int>, `10a` <int>, `10b` <int>, `10c` <int>,
#> #   `11` <int>, `12` <int>, `13` <int>, `14` <int>, `15a` <int>,
#> #   `15b` <int>, `15c` <int>, `16` <int>, `17` <int>, `18` <int>,
#> #   `21` <int>, `22` <int>

dat <- stan_data(spec, data = dtmr_data, identifier = "id")
str(dat)
#> List of 10
#>  $ I    : int 27
#>  $ R    : int 990
#>  $ N    : int 26730
#>  $ C    : int 16
#>  $ ii   : num [1:26730] 1 2 3 4 5 6 7 8 9 10 ...
#>  $ rr   : num [1:26730] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ y    : int [1:26730] 1 1 0 1 0 0 1 1 0 1 ...
#>  $ start: int [1:990] 1 28 55 82 109 136 163 190 217 244 ...
#>  $ num  : int [1:990] 27 27 27 27 27 27 27 27 27 27 ...
#>  $ Xi   : num [1:27, 1:16] 0 0 0 0 0 0 0 0 0 0 ...
```

Note that the elements of the data list correspond to the variables that
are declared in the `data` block of the code generated with
[`stan_code()`](https://dcmstan.r-dcm.org/reference/stan_code.md). If
you customize the *Stan* code and include additional data variables, you
will need to also add the corresponding data objects to the list.

## References

de la Torre, J., & Douglas, J. A. (2004). Higher-order latent trait
models for cognitive diagnosis. *Psychometrika*, *69*(3), 333–353.
<https://doi.org/10.1007/BF02295640>

DiBello, L. V., Stout, W. F., & Roussos, L. (1995). Unified cognitive
psychometric assessment likelihood-based classification techniques. In
P. D. Nichols, S. F. Chipman, & R. L. Brennan (Eds.), *Cognitively
diagnostic assessment* (pp. 361–390). Erlbaum.

Hartz, S. M. (2002). *A Bayesian framework for the unified model for
assessing cognitive abilities: Blending theory with practicality*
(Publication No. 3044108). \[Doctoral thesis, University of Illinois at
Urbana-Champaign\]. ProQuest Dissertations and Theses Global.

Henson, R., & Templin, J. (2019). Loglinear cognitive diagnostic model
(LCDM). In M. von Davier & Y.-S. Lee (Eds.), *Handbook of Diagnostic
Classification Models* (pp. 171–185). Springer International Publishing.
<https://doi.org/10.1007/978-3-030-05584-4_8>

Henson, R., Templin, J., & Willse, J. T. (2009). Defining a family of
cognitive diagnosis models using log-linear models with latent
variables. *Psychometrika*, *74*(2), 191–210.
<https://doi.org/10.1007/s11336-008-9089-5>

Hu, B., & Templin, J. (2020). Using diagnostic classification models to
validate attribute hierarchies and evaluate model fit in Bayesian
networks. *Multivariate Behavioral Research*, *55*(2), 300–311.
<https://doi.org/10.1080/00273171.2019.1632165>

Junker, B. W., & Sijtsma, K. (2001). Cognitive assessment models with
few assumptions, and connections with nonparametric item response
theory. *Applied Psychological Measurement*, *25*(3), 258–272.
<https://doi.org/10.1177/01466210122032064>

Lee, S. Y. (2017, June 27). *Cognitive diagnosis model: DINA model with
independent attributes*. Stan.
<https://mc-stan.org/learn-stan/case-studies/dina_independent.html>

Rupp, A. A., Templin, J., & Henson, R. A. (2010). *Diagnostic
measurement: Theory, methods, and applications*. Guilford Press.

Templin, J. (2006). *CDM user’s guide* \[Unpublished manuscript\].
Department of Psychology, University of Kansas.

Templin, J., & Bradshaw, L. (2014). Hierarchical diagnostic
classification models: A family of models for estimating and testing
attribute hierarchies. *Psychometrika*, *79*(2), 317–339.
<https://doi.org/10.1007/s11336-013-9362-0>

Templin, J., & Henson, R. A. (2006). Measurement of psychological
disorders using cognitive diagnosis models. *Psychological Methods*,
*11*(3), 287–305. <https://doi.org/10.1037/1082-989X.11.3.287>

Xu, X., & von Davier, M. (2008). *Fitting the structured general
diagnostic model to NAEP data* (RR-08-27). Educational Testing Service.
<https://files.eric.ed.gov/fulltext/EJ1111272.pdf>
