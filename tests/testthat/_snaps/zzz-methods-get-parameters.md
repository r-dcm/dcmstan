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
      

# lcdm with a hierarchy works as intended

    Code
      print(spec_params, n = 50)
    Output
      # A tibble: 65 x 4
         item  type        attributes                                      coefficient
         <chr> <chr>       <chr>                                           <chr>      
       1 1     intercept   <NA>                                            l1_0       
       2 1     interaction referent_units__partitioning_iterating__approp~ l1_41234   
       3 2     intercept   <NA>                                            l2_0       
       4 2     maineffect  appropriateness                                 l2_13      
       5 3     intercept   <NA>                                            l3_0       
       6 3     interaction partitioning_iterating__appropriateness         l3_223     
       7 4     intercept   <NA>                                            l4_0       
       8 4     interaction referent_units__partitioning_iterating__approp~ l4_41234   
       9 5     intercept   <NA>                                            l5_0       
      10 5     interaction referent_units__partitioning_iterating__approp~ l5_41234   
      11 6     intercept   <NA>                                            l6_0       
      12 6     interaction partitioning_iterating__appropriateness         l6_223     
      13 7     intercept   <NA>                                            l7_0       
      14 7     interaction referent_units__partitioning_iterating__approp~ l7_41234   
      15 8a    intercept   <NA>                                            l8_0       
      16 8a    maineffect  appropriateness                                 l8_13      
      17 8b    intercept   <NA>                                            l9_0       
      18 8b    maineffect  appropriateness                                 l9_13      
      19 8c    intercept   <NA>                                            l10_0      
      20 8c    maineffect  appropriateness                                 l10_13     
      21 8d    intercept   <NA>                                            l11_0      
      22 8d    maineffect  appropriateness                                 l11_13     
      23 9     intercept   <NA>                                            l12_0      
      24 9     interaction referent_units__partitioning_iterating__approp~ l12_41234  
      25 10a   intercept   <NA>                                            l13_0      
      26 10a   interaction appropriateness__multiplicative_comparison      l13_234    
      27 10b   intercept   <NA>                                            l14_0      
      28 10b   interaction appropriateness__multiplicative_comparison      l14_234    
      29 10b   interaction referent_units__partitioning_iterating__approp~ l14_41234  
      30 10c   intercept   <NA>                                            l15_0      
      31 10c   interaction appropriateness__multiplicative_comparison      l15_234    
      32 10c   interaction referent_units__partitioning_iterating__approp~ l15_41234  
      33 11    intercept   <NA>                                            l16_0      
      34 11    interaction referent_units__partitioning_iterating__approp~ l16_41234  
      35 12    intercept   <NA>                                            l17_0      
      36 12    interaction referent_units__partitioning_iterating__approp~ l17_41234  
      37 13    intercept   <NA>                                            l18_0      
      38 13    interaction partitioning_iterating__appropriateness         l18_223    
      39 13    interaction appropriateness__multiplicative_comparison      l18_234    
      40 13    interaction partitioning_iterating__appropriateness__multi~ l18_3234   
      41 14    intercept   <NA>                                            l19_0      
      42 14    interaction partitioning_iterating__appropriateness         l19_223    
      43 14    interaction referent_units__partitioning_iterating__approp~ l19_41234  
      44 15a   intercept   <NA>                                            l20_0      
      45 15a   interaction partitioning_iterating__appropriateness         l20_223    
      46 15a   interaction appropriateness__multiplicative_comparison      l20_234    
      47 15a   interaction partitioning_iterating__appropriateness__multi~ l20_3234   
      48 15b   intercept   <NA>                                            l21_0      
      49 15b   interaction partitioning_iterating__appropriateness         l21_223    
      50 15c   intercept   <NA>                                            l22_0      
      # i 15 more rows

