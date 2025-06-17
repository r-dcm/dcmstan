# printing works

    Code
      print_choices(meas_choices(), format = TRUE)
    Output
      [1] "\"lcdm\", \"dina\", \"dino\", or \"crum\""
    Code
      print_choices(strc_choices(), format = TRUE)
    Output
<<<<<<< HEAD
      [1] "\"unconstrained\", \"independent\", or \"bayesnet\""
=======
      [1] "\"unconstrained\", \"independent\", \"loglinear\", or \"hdcm\""
>>>>>>> dc6f2a2bfa6f0d0cd09a3c5076b97c649da2aa68
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
<<<<<<< HEAD
      [1] "unconstrained, independent, or bayesnet"
=======
      [1] "unconstrained, independent, loglinear, or hdcm"
>>>>>>> dc6f2a2bfa6f0d0cd09a3c5076b97c649da2aa68
    Code
      print_choices(meas_choices(), last = ", and ")
    Output
      [1] "lcdm, dina, dino, and crum"

---

    Code
      print_choices(names(meas_choices()), sep = "; ", last = "; ", format = FALSE)
    Output
      [1] "loglinear cognitive diagnostic model (LCDM); deterministic input, noisy \"and\""
      [2] "gate (DINA); deterministic input, noisy \"or\" gate (DINO); compensatory"       
      [3] "reparameterized unified model (C-RUM)"                                          

