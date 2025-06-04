# printing works

    Code
      spec
    Message
      A loglinear cognitive diagnostic model (LCDM) measuring 3 attributes with 10
      items.
      
      i Attributes:
      * "node1" (4 items)
      * "node2" (6 items)
      * "node3" (7 items)
      
      i Attribute structure:
        Unconstrained
      
      i Prior distributions:
        intercept ~ normal(0, 2)
        maineffect ~ lognormal(0, 1)
        `Vc` ~ dirichlet(1, 1, 1)
    Code
      spec2
    Message
      A deterministic input, noisy "and" gate (DINA) model measuring 3 attributes
      with 10 items.
      
      i Attributes:
      * "skill_1" (6 items)
      * "skill_2" (4 items)
      * "skill_3" (5 items)
      
      i Attribute structure:
        Independent attributes
      
      i Prior distributions:
        slip ~ beta(5, 25)
        guess ~ beta(5, 25)
        structural ~ beta(1, 1)
    Code
      logl1
    Message
      A loglinear cognitive diagnostic model (LCDM) measuring 3 attributes with 10
      items.
      
      i Attributes:
      * "node1" (4 items)
      * "node2" (6 items)
      * "node3" (7 items)
      
      i Attribute structure:
        Log-linear
      
      i Prior distributions:
        intercept ~ normal(0, 2)
        maineffect ~ lognormal(0, 1)
        interaction ~ normal(0, 2)
        structural ~ normal(0, 10)
    Code
      logl2
    Message
      A loglinear cognitive diagnostic model (LCDM) measuring 3 attributes with 10
      items.
      
      i Attributes:
      * "node1" (4 items)
      * "node2" (6 items)
      * "node3" (7 items)
      
      i Attribute structure:
        Log-linear, with only main effects
      
      i Prior distributions:
        intercept ~ normal(0, 2)
        maineffect ~ lognormal(0, 1)
        interaction ~ normal(0, 2)
        structural ~ normal(0, 10)
    Code
      logl3
    Message
      A loglinear cognitive diagnostic model (LCDM) measuring 3 attributes with 10
      items.
      
      i Attributes:
      * "node1" (4 items)
      * "node2" (6 items)
      * "node3" (7 items)
      
      i Attribute structure:
        Log-linear, with up to 2-way interactions
      
      i Prior distributions:
        intercept ~ normal(0, 2)
        maineffect ~ lognormal(0, 1)
        interaction ~ normal(0, 2)
        structural ~ normal(0, 10)
    Code
      hdcm1
    Message
      A loglinear cognitive diagnostic model (LCDM) measuring 3 attributes with 10
      items.
      
      i Attributes:
      * "node1" (4 items)
      * "node2" (6 items)
      * "node3" (7 items)
      
      i Attribute structure:
        Hierarchical diagnostic classification model (HDCM),
        with structure:
        node3 -> node2 -> node1
      
      i Prior distributions:
        intercept ~ normal(0, 2)
        maineffect ~ lognormal(0, 1)
        `Vc` ~ dirichlet(1, 1, 1)
    Code
      hdcm2
    Message
      A deterministic input, noisy "and" gate (DINA) model measuring 3 attributes
      with 10 items.
      
      i Attributes:
      * "skill_1" (6 items)
      * "skill_2" (4 items)
      * "skill_3" (5 items)
      
      i Attribute structure:
        Hierarchical diagnostic classification model (HDCM),
        with structure:
        skill_1 -> skill_2; skill_1 -> skill_3
      
      i Prior distributions:
        slip ~ beta(5, 25)
        guess ~ beta(5, 25)
        `Vc` ~ dirichlet(1, 1, 1)

