# printing works

    Code
      print_choices(meas_choices(), format = TRUE)
    Output
      [1] "\"lcdm\", \"dina\", \"dino\", or \"crum\""
    Code
      print_choices(strc_choices(), format = TRUE)
    Output
      [1] "\"unconstrained\", \"independent\", or \"hierarchical\""
    Code
      print_choices(meas_choices(), last = ", and ", format = TRUE)
    Output
      [1] "\"lcdm\", \"dina\", \"dino\", and \"crum\""

---

    Code
      print_choices(meas_choices())
    Output
      [1] "lcdm, dina, dino, or crum"
    Code
      print_choices(strc_choices())
    Output
      [1] "unconstrained, independent, or hierarchical"
    Code
      print_choices(meas_choices(), last = ", and ")
    Output
      [1] "lcdm, dina, dino, and crum"

---

    Code
      print_choices(names(meas_choices()), sep = "; ", last = "; ", format = FALSE)
    Output
      [1] "Loglinear cognitive diagnostic model (LCDM); Deterministic input, noisy \"and\""
      [2] "gate (DINA); Deterministic input, noisy \"or\" gate (DINO); Compensatory"       
      [3] "reparameterized unified model (C-RUM)"                                          

