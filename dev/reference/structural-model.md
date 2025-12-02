# Structural models for diagnostic classification

Structural models define how the attributes are related to one another.
The currently supported options for structural models are:
unconstrained, independent attributes, log-linear, hierarchical
diagnostic classification model (HDCM), and Bayesian network. See
details for additional information on each model.

## Usage

``` r
unconstrained()

independent()

loglinear(max_interaction = Inf)

hdcm(hierarchy = NULL)

bayesnet(hierarchy = NULL)
```

## Arguments

- max_interaction:

  For the log-linear structural model, the highest structural-level
  interaction to include in the model.

- hierarchy:

  Optional. If present, the quoted attribute hierarchy. See
  [`vignette("dagitty4semusers", package = "dagitty")`](https://cran.rstudio.com/web/packages/dagitty/vignettes/dagitty4semusers.html)
  for a tutorial on how to draw the attribute hierarchy.

## Value

A structural model object.

## Details

The unconstrained structural model places no constraints on how the
attributes relate to each other. This is equivalent to a saturated model
described by Hu & Templin (2020) and in Chapter 8 of Rupp et al. (2010).

The independent attributes model assumes that the presence of the
attributes are unrelated to each other. That is, there is no
relationship between the presence of one attribute and the presence of
any other. For an example of independent attributes model, see Lee
(2016).

The loglinear structural model assumes that class membership proportions
can be estimated using a loglinear model that includes main and
interaction effects (see Xu & von Davier, 2008). A saturated loglinear
structural model includes interaction effects for all attributes
measured in the model, and is equivalent to the unconstrained structural
model and the saturated model described by Hu & Templin (2020) and in
Chapter 8 of Rupp et al. (2010). A reduced form of the loglinear
structural model containing only main effects is equivalent to an
independent attributes model (e.g. Lee, 2016).

The hierarchical attributes model assumes some attributes must be
mastered before other attributes can be mastered. For an example of the
hierarchical attributes model, see Leighton et al. (2004) and Templin &
Bradshaw (2014).

The Bayesian network model defines the statistical relationships between
the attributes using a directed acyclic graph and a joint probability
distribution. Attribute hierarchies are explicitly defined by
decomposing the joint distribution for the latent attribute space into a
series of marginal and conditional probability distributions. The
unconstrained structural model described in Chapter 8 of Rupp et al.
(2010) can be parameterized as a saturated Bayesian network (Hu &
Templin, 2020). Further, structural models implying an attribute
hierarchy are viewed as nested models within a saturated Bayesian
network (Martinez & Templin, 2023).

## References

Hu, B., & Templin, J. (2020). Using diagnostic classification models to
validate attribute hierarchies and evaluate model fit in Bayesian
Networks. *Multivariate Behavioral Research, 55*(2), 300-311.
[doi:10.1080/00273171.2019.1632165](https://doi.org/10.1080/00273171.2019.1632165)

Lee, S. Y. (2016). *Cognitive diagnosis model: DINA model with
independent attributes*.
https://mc-stan.org/learn-stan/case-studies/dina_independent.html

Leighton, J. P., Gierl, M. J., & Hunka, S. M. (2004). The attribute
hierarchy method for cognitive assessment: A variation on Tatsuoka's
rule-space approach. *Journal of Educational Measurement, 41*(3),
205-237.
[doi:10.1111/j.1745-3984.2004.tb01163.x](https://doi.org/10.1111/j.1745-3984.2004.tb01163.x)

Martinez, A. J., & Templin, J. (2023). Approximate Invariance Testing in
Diagnostic Classification Models in the Presence of Attribute
Hierarchies: A Bayesian Network Approach. *Psych, 5*(3), 688-714.
[doi:10.3390/psych5030045](https://doi.org/10.3390/psych5030045)

Rupp, A. A., Templin, J., & Henson, R. A. (2010). *Diagnostic
measurement: Theory, methods, and applications*. Guilford Press.

Templin, J. L., & Bradshaw, L. (2014). Hierarchical diagnostic
classification models: A family of models for estimating and testing
attribute hierarchies. *Psychometrika, 79*(2), 317-339
[doi:10.1007/s11336-013-9362-0](https://doi.org/10.1007/s11336-013-9362-0)

Xu, X., & von Davier, M. (2008). *Fitting the structured general
diagnostic model to NAEP data* (RR-08-27). Princeton, NJ: Educational
Testing Service.

## See also

[Measurement
models](https://dcmstan.r-dcm.org/dev/reference/measurement-model.md).

## Examples

``` r
unconstrained()
#> <dcmstan::UNCONSTRAINED>
#>  @ model     : chr "unconstrained"
#>  @ model_args: list()

independent()
#> <dcmstan::INDEPENDENT>
#>  @ model     : chr "independent"
#>  @ model_args: list()

loglinear()
#> <dcmstan::LOGLINEAR>
#>  @ model     : chr "loglinear"
#>  @ model_args:List of 1
#>  .. $ max_interaction: num Inf

loglinear(max_interaction = 1)
#> <dcmstan::LOGLINEAR>
#>  @ model     : chr "loglinear"
#>  @ model_args:List of 1
#>  .. $ max_interaction: num 1

hdcm(hierarchy = "att1 -> att2 -> att3")
#> <dcmstan::HDCM>
#>  @ model     : chr "hdcm"
#>  @ model_args:List of 1
#>  .. $ hierarchy: chr "att1 -> att2 -> att3"

bayesnet(hierarchy = "att1 -> att2 -> att3")
#> <dcmstan::BAYESNET>
#>  @ model     : chr "bayesnet"
#>  @ model_args:List of 1
#>  .. $ hierarchy: chr "att1 -> att2 -> att3"
```
