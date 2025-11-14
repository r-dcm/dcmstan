# printing works

    Code
      print_choices(meas_choices(), format = TRUE)
    Output
      [1] "\"lcdm\", \"dina\", \"dino\", \"nida\", \"nido\", \"ncrum\", or \"crum\""
    Code
      print_choices(strc_choices(), format = TRUE)
    Output
      [1] "\"unconstrained\", \"independent\", \"loglinear\", \"hdcm\", or \"bayesnet\""
    Code
      print_choices(meas_choices(), last = ", and ", format = TRUE)
    Output
      [1] "\"lcdm\", \"dina\", \"dino\", \"nida\", \"nido\", \"ncrum\", and \"crum\""

---

    Code
      print_choices(meas_choices())
    Output
      [1] "lcdm, dina, dino, nida, nido, ncrum, or crum"
    Code
      print_choices(strc_choices())
    Output
      [1] "unconstrained, independent, loglinear, hdcm, or bayesnet"
    Code
      print_choices(meas_choices(), last = ", and ")
    Output
      [1] "lcdm, dina, dino, nida, nido, ncrum, and crum"

---

    Code
      print_choices(names(meas_choices()), sep = "; ", last = "; ", format = FALSE)
    Output
      [1] "loglinear cognitive diagnostic model (LCDM); deterministic input, noisy \"and\" gate (DINA); deterministic input, noisy \"or\" gate (DINO); noisy-input, deterministic \"and\" gate (NIDA); noisy-input, deterministic \"or\" gate (NIDO); noncompensatory reparameterized unified model (NC-RUM); compensatory reparameterized unified model (C-RUM)"

