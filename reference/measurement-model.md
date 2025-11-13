# Measurement models for diagnostic classification

The measurement model defines how the items relate to the attributes.
The currently supported options for measurement models are: loglinear
cognitive diagnostic model (LCDM); deterministic input, noisy "and" gate
(DINA); deterministic input, noisy "or" gate (DINO); noisy-input,
deterministic "and" gate (NIDA); noisy-input, deterministic "or" gate
(NIDO); noncompensatory reparameterized unified model (NC-RUM); and
compensatory reparameterized unified model (C-RUM). See details for
additional information on each model.

## Usage

``` r
lcdm(max_interaction = Inf)

dina()

dino()

crum()

nida()

nido()

ncrum()
```

## Arguments

- max_interaction:

  For the LCDM, the highest item-level interaction to include in the
  model.

## Value

A measurement model object.

## Details

The LCDM (Henson et al., 2009; Henson & Templin, 2019) is a general
diagnostic classification model that subsumes the other more restrictive
models. The probability of a respondent providing a correct response is
parameterized like a regression model. For each item, the LCDM includes
an intercept, which represents the log-odds of providing a correct
response when none of the attributes required by the item are present.
Main effect parameters represent the increase in the log-odds for each
required attribute that is present. Finally, interaction terms define
the change in log-odds (after the main effects) when more than one of
the required attributes are present.

### Non-compensatory models

The DINA model (de la Torre & Douglas, 2004; Junker & Sijtsma, 2001) is
a restrictive non-compensatory model. For each item two parameters are
estimated. A guessing parameter defines the probability of a respondent
providing a correct response when not all of the required attributes are
present. Conversely, a slipping parameter defines the probability of
providing an incorrect response when all of the required attributes are
present. Thus, the DINA model takes an "all-or-nothing" approach. Either
a respondent has all of the attributes required for an item, or they do
not. There is no increase in the probability of providing a correct
response if only a subset of the required attributes is present.

The NIDA model (Junker & Sijtsma, 2001) is a non-compensatory model that
is less restrictive than the DINA model. Where the DINA model takes an
"all-or-nothing" approach, the NIDA model defines the probability of
responding correctly based on each attribute that has been mastered. In
doing this, the NIDA model estimates parameters for each attribute and
holds these parameters constant across items. Thus, respondents have
increased probability of responding correctly based on the specific
attributes that have been mastered. However, the parameters are held
constant across items. That is, the effect of non-proficiency on an
attribute is the same for all items measuring that attribute.

The reduced NC-RUM (DiBello et al., 1995; Hartz, 2002) is a
non-compensatory model that is less restrictive than both the DINA and
NIDA model, as the NC-RUM does not constrain parameters across items or
attributes. Thus, the NC-RUM is most similar to the LCDM; however, the
equivalent LCDM parameterization of the NC-RUM constrains interaction
parameters to be positive, which differs from the full LCDM
specification.

### Compensatory models

The DINO model (Templin & Henson, 2006) is the inverse of the DINA
model. Whereas the DINA model is "all-or-nothing", the DINO model can be
thought of as "anything-or-nothing". In the DINO model, the guessing
parameter defines the probability of a correct response when none of the
required attributes are present. The slipping parameter is the
probability of an incorrect response when any of the required attributes
is present. Therefore, when using the DINO model, the presence of any of
the required attributes results in an increased probability of a correct
response, and there is no additional increase in probability for the
presence of more than one of the required attributes.

The NIDO model (Templin, 2006) is a compensatory model that defines the
probability of responding correctly based on each attribute that has
been mastered. Like the NIDA model, the NIDO model holds these
parameters constant across items. In the NIDO model, the probability of
responding correctly increases with each mastered attribute without
assuming a cumulative effect of mastering multiple attributes.

The C-RUM (Hartz, 2002) is similar to the LCDM, but is constrained to
only include the intercept and main effect parameters. That is, no
interaction terms are included for the C-RUM.

## References

de la Torre, J., & Douglas, J. A. (2004). Higher-order latent trait
models for cognitive diagnosis. *Psychometrika, 69*(3), 333-353.
[doi:10.1007/BF02295640](https://doi.org/10.1007/BF02295640)

DiBello, L. V., Stout, W. F., & Roussos, L. (1995). Unified cognitive
psychometric assessment likelihood-based classification techniques. In
P. D. Nichols, S. F. Chipman, & R. L. Brennan (Eds.), *Cognitively
diagnostic assessment* (pp. 361-390). Erlbaum.

Hartz, S. M. (2002). *A Bayesian framework for the unified model for
assessing cognitive abilities: Blending theory with practicality*
(Publication No. 3044108) \[Doctoral dissertation, University of
Illinois at Urbana-Champaign\]. ProQuest Dissertations Publishing.

Henson, R. A., Templin, J. L., & Willse, J. T. (2009). Defining a family
of cognitive diagnosis models using log-linear models with latent
variables. *Psychometrika, 74*(2), 191-210.
[doi:10.1007/s11336-008-9089-5](https://doi.org/10.1007/s11336-008-9089-5)

Henson, R., & Templin, J. L. (2019). Loglinear cognitive diagnostic
model (LCDM). In M. von Davier & Y.-S. Lee (Eds.), *Handbook of
Diagnostic Classification Models* (pp. 171-185). Springer International
Publishing.
[doi:10.1007/978-3-030-05584-4_8](https://doi.org/10.1007/978-3-030-05584-4_8)

Junker, B. W., & Sijtsma, K. (2001). Cognitive assessment models with
few assumptions, and connections with nonparametric item response
theory. *Applied Psychological Measurement, 25*(3), 258-272.
[doi:10.1177/01466210122032064](https://doi.org/10.1177/01466210122032064)

Templin, J. L. (2006). *CDM user's guide*. Unpublished manuscript.

Templin, J. L., & Henson, R. A. (2006). Measurement of psychological
disorders using cognitive diagnosis models. *Psychological Methods,
11*(3), 287-305.
[doi:10.1037/1082-989X.11.3.287](https://doi.org/10.1037/1082-989X.11.3.287)

## See also

[Structural
models](https://dcmstan.r-dcm.org/reference/structural-model.md)

## Examples

``` r
lcdm()
#> <dcmstan::LCDM>
#>  @ model     : chr "lcdm"
#>  @ model_args:List of 1
#>  .. $ max_interaction: num Inf

lcdm(max_interaction = 3)
#> <dcmstan::LCDM>
#>  @ model     : chr "lcdm"
#>  @ model_args:List of 1
#>  .. $ max_interaction: num 3

dina()
#> <dcmstan::DINA>
#>  @ model     : chr "dina"
#>  @ model_args: list()

dino()
#> <dcmstan::DINO>
#>  @ model     : chr "dino"
#>  @ model_args: list()

nida()
#> <dcmstan::NIDA>
#>  @ model     : chr "nida"
#>  @ model_args: list()

nido()
#> <dcmstan::NIDO>
#>  @ model     : chr "nido"
#>  @ model_args: list()

ncrum()
#> <dcmstan::NCRUM>
#>  @ model     : chr "ncrum"
#>  @ model_args: list()

crum()
#> <dcmstan::CRUM>
#>  @ model     : chr "crum"
#>  @ model_args: list()
```
