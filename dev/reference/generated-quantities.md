# Generated quantities for diagnostic classification

Generated quantities are values that are calculated from model
parameters, but are not directly involved in the model estimation. For
example, generated quantities can be used to simulate data for posterior
predictive model checks (PPMCs; e.g., Gelman et al., 2013). See details
for additional information on each quantity that is available.

## Usage

``` r
generated_quantities(loglik = FALSE, probabilities = FALSE, ppmc = FALSE)
```

## Arguments

- loglik:

  Logical indicating whether log-likelihood should be generated.

- probabilities:

  Logical indicating whether class and attribute proficiency
  probabilities should be generated.

- ppmc:

  Logical indicating whether replicated data sets for PPMCs should be
  generated.

## Value

A generated quantities object.

## Details

The log-likelihood contains respondent-level log-likelihood values. This
may be useful when calculating relative fit indices such as the CV-LOO
(Vehtari et al., 2017) or WAIC (Watanabe, 2010).

The probabilities are primary outputs of interest for respondent-level
results. These quantities include the probability that each respondent
belongs to each class, as well as attribute-level proficiency
probabilities for each respondent.

The PPMCs generate a vector of new item responses based on the parameter
values. That is, the generated quantities are replicated data sets that
could be used to calculate PPMCs.

## References

Gelman, A., Carlin, J. B., Stern, H. S., Dunson, D. B., Vehtari, A., &
Rubin, D. B. (2013). *Bayesian Data Analysis* (3rd ed.). Chapman &
Hall/CRC. <https://sites.stat.columbia.edu/gelman/book/>

Vehtari, A., Gelman, A., & Gabry, J. (2017). Practical Bayesian model
evaluation using leave-one-out cross-validation and WAIC. *Statistics
and Computing, 27*(5), 1413–1432.
[doi:10.1007/s11222-016-9696-4](https://doi.org/10.1007/s11222-016-9696-4)

Watanabe, S. (2010). Asymptotic equivalence of Bayes cross validation
and widely applicable information criterion in singular learning theory.
*Journal of Machine Learning Research, 11*(116), 3571–3594.
[http://jmlr.org/papers/v11/watanabe10a.html](http://jmlr.org/papers/v11/watanabe10a.md)

## Examples

``` r
generated_quantities(loglik = TRUE)
#> <dcmstan::GQS>
#>  @ model_args:List of 3
#>  .. $ loglik       : logi TRUE
#>  .. $ probabilities: logi FALSE
#>  .. $ ppmc         : logi FALSE
```
