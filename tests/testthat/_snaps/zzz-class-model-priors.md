# printing works

    Code
      my_prior <- prior("normal(0, 1)", type = "intercept")
      my_prior
    Output
      # A tibble: 1 x 3
        type      coefficient prior       
        <chr>     <chr>       <chr>       
      1 intercept <NA>        normal(0, 1)
    Code
      print(my_prior)
    Output
      # A tibble: 1 x 3
        type      coefficient prior       
        <chr>     <chr>       <chr>       
      1 intercept <NA>        normal(0, 1)
    Code
      bigger_prior <- c(prior("normal(0, 5)", type = "intercept"), prior(
        "lognormal(0, 1)", type = "maineffect"))
      bigger_prior
    Output
      # A tibble: 2 x 3
        type       coefficient prior          
        <chr>      <chr>       <chr>          
      1 intercept  <NA>        normal(0, 5)   
      2 maineffect <NA>        lognormal(0, 1)
    Code
      print(bigger_prior)
    Output
      # A tibble: 2 x 3
        type       coefficient prior          
        <chr>      <chr>       <chr>          
      1 intercept  <NA>        normal(0, 5)   
      2 maineffect <NA>        lognormal(0, 1)

