# Package index

## Model specifications

- [`dcm_specify()`](https://dcmstan.r-dcm.org/reference/dcm_specify.md)
  : Specify a diagnostic classification model
- [`create_profiles()`](https://dcmstan.r-dcm.org/reference/create_profiles.md)
  : Generate mastery profiles

### Model components

- [`lcdm()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)
  [`dina()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)
  [`dino()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)
  [`crum()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)
  [`nida()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)
  [`nido()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)
  [`ncrum()`](https://dcmstan.r-dcm.org/reference/measurement-model.md)
  : Measurement models for diagnostic classification
- [`unconstrained()`](https://dcmstan.r-dcm.org/reference/structural-model.md)
  [`independent()`](https://dcmstan.r-dcm.org/reference/structural-model.md)
  [`loglinear()`](https://dcmstan.r-dcm.org/reference/structural-model.md)
  [`hdcm()`](https://dcmstan.r-dcm.org/reference/structural-model.md)
  [`bayesnet()`](https://dcmstan.r-dcm.org/reference/structural-model.md)
  : Structural models for diagnostic classification
- [`generated_quantities()`](https://dcmstan.r-dcm.org/reference/generated-quantities.md)
  : Generated quantities for diagnostic classification

### Priors

- [`default_dcm_priors()`](https://dcmstan.r-dcm.org/reference/default_dcm_priors.md)
  : Default priors for diagnostic classification models
- [`prior()`](https://dcmstan.r-dcm.org/reference/prior.md)
  [`prior_string()`](https://dcmstan.r-dcm.org/reference/prior.md) :
  Prior definitions for diagnostic classification models
- [`get_parameters()`](https://dcmstan.r-dcm.org/reference/get_parameters.md)
  : Identify parameters included in a diagnostic classification model

## Interface with ‘Stan’

- [`stan_code()`](https://dcmstan.r-dcm.org/reference/stan_code.md) :
  Generate 'Stan' code for a diagnostic classification models
- [`stan_data()`](https://dcmstan.r-dcm.org/reference/stan_data.md) :
  Create a list of data objects for 'Stan'
