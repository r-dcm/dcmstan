# dina parameters (table 6.5)

    Code
      dina_code
    Output
      $parameters
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
      
      $transformed_parameters
        matrix[I,C] pi;
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
      

# dino parameters (table 6.13)

    Code
      dino_code
    Output
      $parameters
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
      
      $transformed_parameters
        matrix[I,C] pi;
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
      

