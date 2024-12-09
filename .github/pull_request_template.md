<!--
If you are proposing a new model to be included, please keep the below portion in your PR and complete the checklist. Your issue will not be reviewed until all boxes are checked (i.e., replace `[ ]` by `[x]`). If you are not proposing a new model, you may remove the checklist.
-->

---

By requesting a review of this pull request, I have ensured that

- [ ] I have fully read the [CONTRIBUTING](https://github.com/r-dcm/dcmstan/blob/main/.github/CONTRIBUTING.md) guide, and my changes conform to the best practices, style, and directions described therein.
- [ ] Stan code generation has been added to `R/meas-*.R` or `R/strc-*.R` for a measurement or structural model, respectively.
  - [ ] Functions should return a list with 3 elements: `parameters`, `transformed_parameters`, and `priors`.
  - [ ] Functions should take `qmatrix` and `priors` as an argument (even if not strictly needed).
    The `qmatrix` is a cleaned Q-matrix (i.e., the output of `rdcmchecks::clean_qmatrix()`.
    The `priors` come from the model specification (i.e., `@priors`).
    Additional arguments have been added as needed for the specific specific model.
- [ ] The new model has been added as an option to `R/model-options.R`.
- [ ] A new S7 class for the model has been added to the bottom of `R/zzz-class-model-components.R`.
- [ ] Wrapper functions for new class have been added to the top of `R/zzz-class-model-components.R`.
    The arugments are the same as the additional arugments included in the Stan generation function (i.e., excluding `qmatrix` and `priors`).
- [ ] A short paragraph describing the model has been added to the relevant documentation block of `R/zzz-class-model-components.R`.
- [ ] A function that provides default priors has been added to `R/zzz-class-model-priors.R`.
- [ ] The `switch()` functions in `default_dcm_priors()` have been updated to include the new prior function.
- [ ] A new S7 method for `get_parameters()` for the new model has been added to `R/zzz-methods-get-parameters.R`.
    If needed, larger functions for determining the parameters included in the model have been added to `R/utils-get-parameters.R`.
- [ ] All new functions have been documents, even if not exported (i.e., using the `@noRd` tag).
