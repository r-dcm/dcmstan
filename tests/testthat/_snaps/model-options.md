# printing works

    Code
      print_choices(meas_choices(), format = TRUE)
    Output
      [1] "\"lcdm\", \"dina\", \"dino\", \"crum\", \"nida\", \"nido\", or \"ncrum\""
    Code
      print_choices(strc_choices(), format = TRUE)
    Output
      [1] "\"unconstrained\" and \"independent\""
    Code
      print_choices(meas_choices(), last = ", and ", format = TRUE)
    Output
      [1] "\"lcdm\", \"dina\", \"dino\", \"crum\", \"nida\", \"nido\", and \"ncrum\""

---

    Code
      print_choices(meas_choices())
    Output
      [1] "lcdm, dina, dino, crum, nida, nido, or ncrum"
    Code
      print_choices(strc_choices())
    Output
      [1] "unconstrained and independent"
    Code
      print_choices(meas_choices(), last = ", and ")
    Output
      [1] "lcdm, dina, dino, crum, nida, nido, and ncrum"

---

    Code
      print_choices(names(meas_choices()), sep = "; ", last = "; ", format = FALSE)
    Output
      [1] "loglinear cognitive diagnostic model (LCDM); deterministic input, noisy \"and\""
      [2] "gate (DINA); deterministic input, noisy \"or\" gate (DINO); compensatory"       
      [3] "reparameterized unified model (C-RUM); noisy-input, deterministic \"and\" gate" 
      [4] "(NIDA); noisy-input, deterministic \"or\" gate (NIDO); noncompensatory"         
      [5] "reparameterized unified model (NC-RUM)"                                         

