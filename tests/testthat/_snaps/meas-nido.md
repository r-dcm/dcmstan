# nido script works

    Code
      generate_stan(ecpe_spec)
    Output
      data {
        int<lower=1> I;                      // number of items
        int<lower=1> R;                      // number of respondents
        int<lower=1> N;                      // number of observations
        int<lower=1> C;                      // number of classes
        int<lower=1> A;                      // number of attributes
        array[N] int<lower=1,upper=I> ii;    // item for observation n
        array[N] int<lower=1,upper=R> rr;    // respondent for observation n
        array[N] int<lower=0,upper=1> y;     // score for observation n
        array[R] int<lower=1,upper=N> start; // starting row for respondent R
        array[R] int<lower=1,upper=I> num;   // number of items for respondent R
        matrix[C,A] Alpha;                   // attribute pattern for each class
        matrix[I,C] Xi;                      // class attribute mastery indicator
      }
      parameters {
        simplex[C] Vc;                  // base rates of class membership
      
        ////////////////////////////////// attribute intercepts
        real beta1;
        real beta2;
        real beta3;
      
        ////////////////////////////////// attribute main effects
        real<lower=0> gamma1;
        real<lower=0> gamma2;
        real<lower=0> gamma3;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = inv_logit(beta1+beta2);
        pi[1,2] = inv_logit(beta1+gamma1+beta2);
        pi[1,3] = inv_logit(beta1+beta2+gamma2);
        pi[1,4] = inv_logit(beta1+beta2);
        pi[1,5] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[1,6] = inv_logit(beta1+gamma1+beta2);
        pi[1,7] = inv_logit(beta1+beta2+gamma2);
        pi[1,8] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[2,1] = inv_logit(beta2);
        pi[2,2] = inv_logit(beta2);
        pi[2,3] = inv_logit(beta2+gamma2);
        pi[2,4] = inv_logit(beta2);
        pi[2,5] = inv_logit(beta2+gamma2);
        pi[2,6] = inv_logit(beta2);
        pi[2,7] = inv_logit(beta2+gamma2);
        pi[2,8] = inv_logit(beta2+gamma2);
        pi[3,1] = inv_logit(beta1+beta3);
        pi[3,2] = inv_logit(beta1+gamma1+beta3);
        pi[3,3] = inv_logit(beta1+beta3);
        pi[3,4] = inv_logit(beta1+beta3+gamma3);
        pi[3,5] = inv_logit(beta1+gamma1+beta3);
        pi[3,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[3,7] = inv_logit(beta1+beta3+gamma3);
        pi[3,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[4,1] = inv_logit(beta3);
        pi[4,2] = inv_logit(beta3);
        pi[4,3] = inv_logit(beta3);
        pi[4,4] = inv_logit(beta3+gamma3);
        pi[4,5] = inv_logit(beta3);
        pi[4,6] = inv_logit(beta3+gamma3);
        pi[4,7] = inv_logit(beta3+gamma3);
        pi[4,8] = inv_logit(beta3+gamma3);
        pi[5,1] = inv_logit(beta3);
        pi[5,2] = inv_logit(beta3);
        pi[5,3] = inv_logit(beta3);
        pi[5,4] = inv_logit(beta3+gamma3);
        pi[5,5] = inv_logit(beta3);
        pi[5,6] = inv_logit(beta3+gamma3);
        pi[5,7] = inv_logit(beta3+gamma3);
        pi[5,8] = inv_logit(beta3+gamma3);
        pi[6,1] = inv_logit(beta3);
        pi[6,2] = inv_logit(beta3);
        pi[6,3] = inv_logit(beta3);
        pi[6,4] = inv_logit(beta3+gamma3);
        pi[6,5] = inv_logit(beta3);
        pi[6,6] = inv_logit(beta3+gamma3);
        pi[6,7] = inv_logit(beta3+gamma3);
        pi[6,8] = inv_logit(beta3+gamma3);
        pi[7,1] = inv_logit(beta1+beta3);
        pi[7,2] = inv_logit(beta1+gamma1+beta3);
        pi[7,3] = inv_logit(beta1+beta3);
        pi[7,4] = inv_logit(beta1+beta3+gamma3);
        pi[7,5] = inv_logit(beta1+gamma1+beta3);
        pi[7,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[7,7] = inv_logit(beta1+beta3+gamma3);
        pi[7,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[8,1] = inv_logit(beta2);
        pi[8,2] = inv_logit(beta2);
        pi[8,3] = inv_logit(beta2+gamma2);
        pi[8,4] = inv_logit(beta2);
        pi[8,5] = inv_logit(beta2+gamma2);
        pi[8,6] = inv_logit(beta2);
        pi[8,7] = inv_logit(beta2+gamma2);
        pi[8,8] = inv_logit(beta2+gamma2);
        pi[9,1] = inv_logit(beta3);
        pi[9,2] = inv_logit(beta3);
        pi[9,3] = inv_logit(beta3);
        pi[9,4] = inv_logit(beta3+gamma3);
        pi[9,5] = inv_logit(beta3);
        pi[9,6] = inv_logit(beta3+gamma3);
        pi[9,7] = inv_logit(beta3+gamma3);
        pi[9,8] = inv_logit(beta3+gamma3);
        pi[10,1] = inv_logit(beta1);
        pi[10,2] = inv_logit(beta1+gamma1);
        pi[10,3] = inv_logit(beta1);
        pi[10,4] = inv_logit(beta1);
        pi[10,5] = inv_logit(beta1+gamma1);
        pi[10,6] = inv_logit(beta1+gamma1);
        pi[10,7] = inv_logit(beta1);
        pi[10,8] = inv_logit(beta1+gamma1);
        pi[11,1] = inv_logit(beta1+beta3);
        pi[11,2] = inv_logit(beta1+gamma1+beta3);
        pi[11,3] = inv_logit(beta1+beta3);
        pi[11,4] = inv_logit(beta1+beta3+gamma3);
        pi[11,5] = inv_logit(beta1+gamma1+beta3);
        pi[11,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[11,7] = inv_logit(beta1+beta3+gamma3);
        pi[11,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[12,1] = inv_logit(beta1+beta3);
        pi[12,2] = inv_logit(beta1+gamma1+beta3);
        pi[12,3] = inv_logit(beta1+beta3);
        pi[12,4] = inv_logit(beta1+beta3+gamma3);
        pi[12,5] = inv_logit(beta1+gamma1+beta3);
        pi[12,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[12,7] = inv_logit(beta1+beta3+gamma3);
        pi[12,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[13,1] = inv_logit(beta1);
        pi[13,2] = inv_logit(beta1+gamma1);
        pi[13,3] = inv_logit(beta1);
        pi[13,4] = inv_logit(beta1);
        pi[13,5] = inv_logit(beta1+gamma1);
        pi[13,6] = inv_logit(beta1+gamma1);
        pi[13,7] = inv_logit(beta1);
        pi[13,8] = inv_logit(beta1+gamma1);
        pi[14,1] = inv_logit(beta1);
        pi[14,2] = inv_logit(beta1+gamma1);
        pi[14,3] = inv_logit(beta1);
        pi[14,4] = inv_logit(beta1);
        pi[14,5] = inv_logit(beta1+gamma1);
        pi[14,6] = inv_logit(beta1+gamma1);
        pi[14,7] = inv_logit(beta1);
        pi[14,8] = inv_logit(beta1+gamma1);
        pi[15,1] = inv_logit(beta3);
        pi[15,2] = inv_logit(beta3);
        pi[15,3] = inv_logit(beta3);
        pi[15,4] = inv_logit(beta3+gamma3);
        pi[15,5] = inv_logit(beta3);
        pi[15,6] = inv_logit(beta3+gamma3);
        pi[15,7] = inv_logit(beta3+gamma3);
        pi[15,8] = inv_logit(beta3+gamma3);
        pi[16,1] = inv_logit(beta1+beta3);
        pi[16,2] = inv_logit(beta1+gamma1+beta3);
        pi[16,3] = inv_logit(beta1+beta3);
        pi[16,4] = inv_logit(beta1+beta3+gamma3);
        pi[16,5] = inv_logit(beta1+gamma1+beta3);
        pi[16,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[16,7] = inv_logit(beta1+beta3+gamma3);
        pi[16,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[17,1] = inv_logit(beta2+beta3);
        pi[17,2] = inv_logit(beta2+beta3);
        pi[17,3] = inv_logit(beta2+gamma2+beta3);
        pi[17,4] = inv_logit(beta2+beta3+gamma3);
        pi[17,5] = inv_logit(beta2+gamma2+beta3);
        pi[17,6] = inv_logit(beta2+beta3+gamma3);
        pi[17,7] = inv_logit(beta2+gamma2+beta3+gamma3);
        pi[17,8] = inv_logit(beta2+gamma2+beta3+gamma3);
        pi[18,1] = inv_logit(beta3);
        pi[18,2] = inv_logit(beta3);
        pi[18,3] = inv_logit(beta3);
        pi[18,4] = inv_logit(beta3+gamma3);
        pi[18,5] = inv_logit(beta3);
        pi[18,6] = inv_logit(beta3+gamma3);
        pi[18,7] = inv_logit(beta3+gamma3);
        pi[18,8] = inv_logit(beta3+gamma3);
        pi[19,1] = inv_logit(beta3);
        pi[19,2] = inv_logit(beta3);
        pi[19,3] = inv_logit(beta3);
        pi[19,4] = inv_logit(beta3+gamma3);
        pi[19,5] = inv_logit(beta3);
        pi[19,6] = inv_logit(beta3+gamma3);
        pi[19,7] = inv_logit(beta3+gamma3);
        pi[19,8] = inv_logit(beta3+gamma3);
        pi[20,1] = inv_logit(beta1+beta3);
        pi[20,2] = inv_logit(beta1+gamma1+beta3);
        pi[20,3] = inv_logit(beta1+beta3);
        pi[20,4] = inv_logit(beta1+beta3+gamma3);
        pi[20,5] = inv_logit(beta1+gamma1+beta3);
        pi[20,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[20,7] = inv_logit(beta1+beta3+gamma3);
        pi[20,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[21,1] = inv_logit(beta1+beta3);
        pi[21,2] = inv_logit(beta1+gamma1+beta3);
        pi[21,3] = inv_logit(beta1+beta3);
        pi[21,4] = inv_logit(beta1+beta3+gamma3);
        pi[21,5] = inv_logit(beta1+gamma1+beta3);
        pi[21,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[21,7] = inv_logit(beta1+beta3+gamma3);
        pi[21,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[22,1] = inv_logit(beta3);
        pi[22,2] = inv_logit(beta3);
        pi[22,3] = inv_logit(beta3);
        pi[22,4] = inv_logit(beta3+gamma3);
        pi[22,5] = inv_logit(beta3);
        pi[22,6] = inv_logit(beta3+gamma3);
        pi[22,7] = inv_logit(beta3+gamma3);
        pi[22,8] = inv_logit(beta3+gamma3);
        pi[23,1] = inv_logit(beta2);
        pi[23,2] = inv_logit(beta2);
        pi[23,3] = inv_logit(beta2+gamma2);
        pi[23,4] = inv_logit(beta2);
        pi[23,5] = inv_logit(beta2+gamma2);
        pi[23,6] = inv_logit(beta2);
        pi[23,7] = inv_logit(beta2+gamma2);
        pi[23,8] = inv_logit(beta2+gamma2);
        pi[24,1] = inv_logit(beta2);
        pi[24,2] = inv_logit(beta2);
        pi[24,3] = inv_logit(beta2+gamma2);
        pi[24,4] = inv_logit(beta2);
        pi[24,5] = inv_logit(beta2+gamma2);
        pi[24,6] = inv_logit(beta2);
        pi[24,7] = inv_logit(beta2+gamma2);
        pi[24,8] = inv_logit(beta2+gamma2);
        pi[25,1] = inv_logit(beta1);
        pi[25,2] = inv_logit(beta1+gamma1);
        pi[25,3] = inv_logit(beta1);
        pi[25,4] = inv_logit(beta1);
        pi[25,5] = inv_logit(beta1+gamma1);
        pi[25,6] = inv_logit(beta1+gamma1);
        pi[25,7] = inv_logit(beta1);
        pi[25,8] = inv_logit(beta1+gamma1);
        pi[26,1] = inv_logit(beta3);
        pi[26,2] = inv_logit(beta3);
        pi[26,3] = inv_logit(beta3);
        pi[26,4] = inv_logit(beta3+gamma3);
        pi[26,5] = inv_logit(beta3);
        pi[26,6] = inv_logit(beta3+gamma3);
        pi[26,7] = inv_logit(beta3+gamma3);
        pi[26,8] = inv_logit(beta3+gamma3);
        pi[27,1] = inv_logit(beta1);
        pi[27,2] = inv_logit(beta1+gamma1);
        pi[27,3] = inv_logit(beta1);
        pi[27,4] = inv_logit(beta1);
        pi[27,5] = inv_logit(beta1+gamma1);
        pi[27,6] = inv_logit(beta1+gamma1);
        pi[27,7] = inv_logit(beta1);
        pi[27,8] = inv_logit(beta1+gamma1);
        pi[28,1] = inv_logit(beta3);
        pi[28,2] = inv_logit(beta3);
        pi[28,3] = inv_logit(beta3);
        pi[28,4] = inv_logit(beta3+gamma3);
        pi[28,5] = inv_logit(beta3);
        pi[28,6] = inv_logit(beta3+gamma3);
        pi[28,7] = inv_logit(beta3+gamma3);
        pi[28,8] = inv_logit(beta3+gamma3);
      }
      model {
      
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        beta1 ~ normal(0, 2);
        gamma1 ~ lognormal(0, 1);
        beta2 ~ normal(0, 2);
        gamma2 ~ lognormal(0, 1);
        beta3 ~ normal(0, 2);
        gamma3 ~ lognormal(0, 1);
      
        ////////////////////////////////// likelihood
        for (r in 1:R) {
          row_vector[C] ps;
          for (c in 1:C) {
            array[num[r]] real log_items;
            for (m in 1:num[r]) {
              int i = ii[start[r] + m - 1];
              log_items[m] = y[start[r] + m - 1] * log(pi[i,c]) +
                             (1 - y[start[r] + m - 1]) * log(1 - pi[i,c]);
            }
            ps[c] = log_Vc[c] + sum(log_items);
          }
          target += log_sum_exp(ps);
        }
      }

---

    Code
      generate_stan(mdm_spec)
    Output
      data {
        int<lower=1> I;                      // number of items
        int<lower=1> R;                      // number of respondents
        int<lower=1> N;                      // number of observations
        int<lower=1> C;                      // number of classes
        int<lower=1> A;                      // number of attributes
        array[N] int<lower=1,upper=I> ii;    // item for observation n
        array[N] int<lower=1,upper=R> rr;    // respondent for observation n
        array[N] int<lower=0,upper=1> y;     // score for observation n
        array[R] int<lower=1,upper=N> start; // starting row for respondent R
        array[R] int<lower=1,upper=I> num;   // number of items for respondent R
        matrix[C,A] Alpha;                   // attribute pattern for each class
        matrix[I,C] Xi;                      // class attribute mastery indicator
      }
      parameters {
        simplex[C] Vc;                  // base rates of class membership
      
        ////////////////////////////////// attribute intercepts
        real beta1;
      
        ////////////////////////////////// attribute main effects
        real<lower=0> gamma1;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = inv_logit(beta1);
        pi[1,2] = inv_logit(beta1+gamma1);
        pi[2,1] = inv_logit(beta1);
        pi[2,2] = inv_logit(beta1+gamma1);
        pi[3,1] = inv_logit(beta1);
        pi[3,2] = inv_logit(beta1+gamma1);
        pi[4,1] = inv_logit(beta1);
        pi[4,2] = inv_logit(beta1+gamma1);
      }
      model {
      
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        beta1 ~ normal(0, 2);
        gamma1 ~ lognormal(0, 1);
      
        ////////////////////////////////// likelihood
        for (r in 1:R) {
          row_vector[C] ps;
          for (c in 1:C) {
            array[num[r]] real log_items;
            for (m in 1:num[r]) {
              int i = ii[start[r] + m - 1];
              log_items[m] = y[start[r] + m - 1] * log(pi[i,c]) +
                             (1 - y[start[r] + m - 1]) * log(1 - pi[i,c]);
            }
            ps[c] = log_Vc[c] + sum(log_items);
          }
          target += log_sum_exp(ps);
        }
      }

---

    Code
      generate_stan(dtmr_spec)
    Output
      data {
        int<lower=1> I;                      // number of items
        int<lower=1> R;                      // number of respondents
        int<lower=1> N;                      // number of observations
        int<lower=1> C;                      // number of classes
        int<lower=1> A;                      // number of attributes
        array[N] int<lower=1,upper=I> ii;    // item for observation n
        array[N] int<lower=1,upper=R> rr;    // respondent for observation n
        array[N] int<lower=0,upper=1> y;     // score for observation n
        array[R] int<lower=1,upper=N> start; // starting row for respondent R
        array[R] int<lower=1,upper=I> num;   // number of items for respondent R
        matrix[C,A] Alpha;                   // attribute pattern for each class
        matrix[I,C] Xi;                      // class attribute mastery indicator
      }
      parameters {
        simplex[C] Vc;                  // base rates of class membership
      
        ////////////////////////////////// attribute intercepts
        real beta1;
        real beta2;
        real beta3;
        real beta4;
      
        ////////////////////////////////// attribute main effects
        real<lower=0> gamma1;
        real<lower=0> gamma2;
        real<lower=0> gamma3;
        real<lower=0> gamma4;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = inv_logit(beta1);
        pi[1,2] = inv_logit(beta1+gamma1);
        pi[1,3] = inv_logit(beta1);
        pi[1,4] = inv_logit(beta1);
        pi[1,5] = inv_logit(beta1);
        pi[1,6] = inv_logit(beta1+gamma1);
        pi[1,7] = inv_logit(beta1+gamma1);
        pi[1,8] = inv_logit(beta1+gamma1);
        pi[1,9] = inv_logit(beta1);
        pi[1,10] = inv_logit(beta1);
        pi[1,11] = inv_logit(beta1);
        pi[1,12] = inv_logit(beta1+gamma1);
        pi[1,13] = inv_logit(beta1+gamma1);
        pi[1,14] = inv_logit(beta1+gamma1);
        pi[1,15] = inv_logit(beta1);
        pi[1,16] = inv_logit(beta1+gamma1);
        pi[2,1] = inv_logit(beta3);
        pi[2,2] = inv_logit(beta3);
        pi[2,3] = inv_logit(beta3);
        pi[2,4] = inv_logit(beta3+gamma3);
        pi[2,5] = inv_logit(beta3);
        pi[2,6] = inv_logit(beta3);
        pi[2,7] = inv_logit(beta3+gamma3);
        pi[2,8] = inv_logit(beta3);
        pi[2,9] = inv_logit(beta3+gamma3);
        pi[2,10] = inv_logit(beta3);
        pi[2,11] = inv_logit(beta3+gamma3);
        pi[2,12] = inv_logit(beta3+gamma3);
        pi[2,13] = inv_logit(beta3);
        pi[2,14] = inv_logit(beta3+gamma3);
        pi[2,15] = inv_logit(beta3+gamma3);
        pi[2,16] = inv_logit(beta3+gamma3);
        pi[3,1] = inv_logit(beta2);
        pi[3,2] = inv_logit(beta2);
        pi[3,3] = inv_logit(beta2+gamma2);
        pi[3,4] = inv_logit(beta2);
        pi[3,5] = inv_logit(beta2);
        pi[3,6] = inv_logit(beta2+gamma2);
        pi[3,7] = inv_logit(beta2);
        pi[3,8] = inv_logit(beta2);
        pi[3,9] = inv_logit(beta2+gamma2);
        pi[3,10] = inv_logit(beta2+gamma2);
        pi[3,11] = inv_logit(beta2);
        pi[3,12] = inv_logit(beta2+gamma2);
        pi[3,13] = inv_logit(beta2+gamma2);
        pi[3,14] = inv_logit(beta2);
        pi[3,15] = inv_logit(beta2+gamma2);
        pi[3,16] = inv_logit(beta2+gamma2);
        pi[4,1] = inv_logit(beta1);
        pi[4,2] = inv_logit(beta1+gamma1);
        pi[4,3] = inv_logit(beta1);
        pi[4,4] = inv_logit(beta1);
        pi[4,5] = inv_logit(beta1);
        pi[4,6] = inv_logit(beta1+gamma1);
        pi[4,7] = inv_logit(beta1+gamma1);
        pi[4,8] = inv_logit(beta1+gamma1);
        pi[4,9] = inv_logit(beta1);
        pi[4,10] = inv_logit(beta1);
        pi[4,11] = inv_logit(beta1);
        pi[4,12] = inv_logit(beta1+gamma1);
        pi[4,13] = inv_logit(beta1+gamma1);
        pi[4,14] = inv_logit(beta1+gamma1);
        pi[4,15] = inv_logit(beta1);
        pi[4,16] = inv_logit(beta1+gamma1);
        pi[5,1] = inv_logit(beta1);
        pi[5,2] = inv_logit(beta1+gamma1);
        pi[5,3] = inv_logit(beta1);
        pi[5,4] = inv_logit(beta1);
        pi[5,5] = inv_logit(beta1);
        pi[5,6] = inv_logit(beta1+gamma1);
        pi[5,7] = inv_logit(beta1+gamma1);
        pi[5,8] = inv_logit(beta1+gamma1);
        pi[5,9] = inv_logit(beta1);
        pi[5,10] = inv_logit(beta1);
        pi[5,11] = inv_logit(beta1);
        pi[5,12] = inv_logit(beta1+gamma1);
        pi[5,13] = inv_logit(beta1+gamma1);
        pi[5,14] = inv_logit(beta1+gamma1);
        pi[5,15] = inv_logit(beta1);
        pi[5,16] = inv_logit(beta1+gamma1);
        pi[6,1] = inv_logit(beta2);
        pi[6,2] = inv_logit(beta2);
        pi[6,3] = inv_logit(beta2+gamma2);
        pi[6,4] = inv_logit(beta2);
        pi[6,5] = inv_logit(beta2);
        pi[6,6] = inv_logit(beta2+gamma2);
        pi[6,7] = inv_logit(beta2);
        pi[6,8] = inv_logit(beta2);
        pi[6,9] = inv_logit(beta2+gamma2);
        pi[6,10] = inv_logit(beta2+gamma2);
        pi[6,11] = inv_logit(beta2);
        pi[6,12] = inv_logit(beta2+gamma2);
        pi[6,13] = inv_logit(beta2+gamma2);
        pi[6,14] = inv_logit(beta2);
        pi[6,15] = inv_logit(beta2+gamma2);
        pi[6,16] = inv_logit(beta2+gamma2);
        pi[7,1] = inv_logit(beta1);
        pi[7,2] = inv_logit(beta1+gamma1);
        pi[7,3] = inv_logit(beta1);
        pi[7,4] = inv_logit(beta1);
        pi[7,5] = inv_logit(beta1);
        pi[7,6] = inv_logit(beta1+gamma1);
        pi[7,7] = inv_logit(beta1+gamma1);
        pi[7,8] = inv_logit(beta1+gamma1);
        pi[7,9] = inv_logit(beta1);
        pi[7,10] = inv_logit(beta1);
        pi[7,11] = inv_logit(beta1);
        pi[7,12] = inv_logit(beta1+gamma1);
        pi[7,13] = inv_logit(beta1+gamma1);
        pi[7,14] = inv_logit(beta1+gamma1);
        pi[7,15] = inv_logit(beta1);
        pi[7,16] = inv_logit(beta1+gamma1);
        pi[8,1] = inv_logit(beta3);
        pi[8,2] = inv_logit(beta3);
        pi[8,3] = inv_logit(beta3);
        pi[8,4] = inv_logit(beta3+gamma3);
        pi[8,5] = inv_logit(beta3);
        pi[8,6] = inv_logit(beta3);
        pi[8,7] = inv_logit(beta3+gamma3);
        pi[8,8] = inv_logit(beta3);
        pi[8,9] = inv_logit(beta3+gamma3);
        pi[8,10] = inv_logit(beta3);
        pi[8,11] = inv_logit(beta3+gamma3);
        pi[8,12] = inv_logit(beta3+gamma3);
        pi[8,13] = inv_logit(beta3);
        pi[8,14] = inv_logit(beta3+gamma3);
        pi[8,15] = inv_logit(beta3+gamma3);
        pi[8,16] = inv_logit(beta3+gamma3);
        pi[9,1] = inv_logit(beta3);
        pi[9,2] = inv_logit(beta3);
        pi[9,3] = inv_logit(beta3);
        pi[9,4] = inv_logit(beta3+gamma3);
        pi[9,5] = inv_logit(beta3);
        pi[9,6] = inv_logit(beta3);
        pi[9,7] = inv_logit(beta3+gamma3);
        pi[9,8] = inv_logit(beta3);
        pi[9,9] = inv_logit(beta3+gamma3);
        pi[9,10] = inv_logit(beta3);
        pi[9,11] = inv_logit(beta3+gamma3);
        pi[9,12] = inv_logit(beta3+gamma3);
        pi[9,13] = inv_logit(beta3);
        pi[9,14] = inv_logit(beta3+gamma3);
        pi[9,15] = inv_logit(beta3+gamma3);
        pi[9,16] = inv_logit(beta3+gamma3);
        pi[10,1] = inv_logit(beta3);
        pi[10,2] = inv_logit(beta3);
        pi[10,3] = inv_logit(beta3);
        pi[10,4] = inv_logit(beta3+gamma3);
        pi[10,5] = inv_logit(beta3);
        pi[10,6] = inv_logit(beta3);
        pi[10,7] = inv_logit(beta3+gamma3);
        pi[10,8] = inv_logit(beta3);
        pi[10,9] = inv_logit(beta3+gamma3);
        pi[10,10] = inv_logit(beta3);
        pi[10,11] = inv_logit(beta3+gamma3);
        pi[10,12] = inv_logit(beta3+gamma3);
        pi[10,13] = inv_logit(beta3);
        pi[10,14] = inv_logit(beta3+gamma3);
        pi[10,15] = inv_logit(beta3+gamma3);
        pi[10,16] = inv_logit(beta3+gamma3);
        pi[11,1] = inv_logit(beta3);
        pi[11,2] = inv_logit(beta3);
        pi[11,3] = inv_logit(beta3);
        pi[11,4] = inv_logit(beta3+gamma3);
        pi[11,5] = inv_logit(beta3);
        pi[11,6] = inv_logit(beta3);
        pi[11,7] = inv_logit(beta3+gamma3);
        pi[11,8] = inv_logit(beta3);
        pi[11,9] = inv_logit(beta3+gamma3);
        pi[11,10] = inv_logit(beta3);
        pi[11,11] = inv_logit(beta3+gamma3);
        pi[11,12] = inv_logit(beta3+gamma3);
        pi[11,13] = inv_logit(beta3);
        pi[11,14] = inv_logit(beta3+gamma3);
        pi[11,15] = inv_logit(beta3+gamma3);
        pi[11,16] = inv_logit(beta3+gamma3);
        pi[12,1] = inv_logit(beta1);
        pi[12,2] = inv_logit(beta1+gamma1);
        pi[12,3] = inv_logit(beta1);
        pi[12,4] = inv_logit(beta1);
        pi[12,5] = inv_logit(beta1);
        pi[12,6] = inv_logit(beta1+gamma1);
        pi[12,7] = inv_logit(beta1+gamma1);
        pi[12,8] = inv_logit(beta1+gamma1);
        pi[12,9] = inv_logit(beta1);
        pi[12,10] = inv_logit(beta1);
        pi[12,11] = inv_logit(beta1);
        pi[12,12] = inv_logit(beta1+gamma1);
        pi[12,13] = inv_logit(beta1+gamma1);
        pi[12,14] = inv_logit(beta1+gamma1);
        pi[12,15] = inv_logit(beta1);
        pi[12,16] = inv_logit(beta1+gamma1);
        pi[13,1] = inv_logit(beta4);
        pi[13,2] = inv_logit(beta4);
        pi[13,3] = inv_logit(beta4);
        pi[13,4] = inv_logit(beta4);
        pi[13,5] = inv_logit(beta4+gamma4);
        pi[13,6] = inv_logit(beta4);
        pi[13,7] = inv_logit(beta4);
        pi[13,8] = inv_logit(beta4+gamma4);
        pi[13,9] = inv_logit(beta4);
        pi[13,10] = inv_logit(beta4+gamma4);
        pi[13,11] = inv_logit(beta4+gamma4);
        pi[13,12] = inv_logit(beta4);
        pi[13,13] = inv_logit(beta4+gamma4);
        pi[13,14] = inv_logit(beta4+gamma4);
        pi[13,15] = inv_logit(beta4+gamma4);
        pi[13,16] = inv_logit(beta4+gamma4);
        pi[14,1] = inv_logit(beta1+beta4);
        pi[14,2] = inv_logit(beta1+gamma1+beta4);
        pi[14,3] = inv_logit(beta1+beta4);
        pi[14,4] = inv_logit(beta1+beta4);
        pi[14,5] = inv_logit(beta1+beta4+gamma4);
        pi[14,6] = inv_logit(beta1+gamma1+beta4);
        pi[14,7] = inv_logit(beta1+gamma1+beta4);
        pi[14,8] = inv_logit(beta1+gamma1+beta4+gamma4);
        pi[14,9] = inv_logit(beta1+beta4);
        pi[14,10] = inv_logit(beta1+beta4+gamma4);
        pi[14,11] = inv_logit(beta1+beta4+gamma4);
        pi[14,12] = inv_logit(beta1+gamma1+beta4);
        pi[14,13] = inv_logit(beta1+gamma1+beta4+gamma4);
        pi[14,14] = inv_logit(beta1+gamma1+beta4+gamma4);
        pi[14,15] = inv_logit(beta1+beta4+gamma4);
        pi[14,16] = inv_logit(beta1+gamma1+beta4+gamma4);
        pi[15,1] = inv_logit(beta1+beta4);
        pi[15,2] = inv_logit(beta1+gamma1+beta4);
        pi[15,3] = inv_logit(beta1+beta4);
        pi[15,4] = inv_logit(beta1+beta4);
        pi[15,5] = inv_logit(beta1+beta4+gamma4);
        pi[15,6] = inv_logit(beta1+gamma1+beta4);
        pi[15,7] = inv_logit(beta1+gamma1+beta4);
        pi[15,8] = inv_logit(beta1+gamma1+beta4+gamma4);
        pi[15,9] = inv_logit(beta1+beta4);
        pi[15,10] = inv_logit(beta1+beta4+gamma4);
        pi[15,11] = inv_logit(beta1+beta4+gamma4);
        pi[15,12] = inv_logit(beta1+gamma1+beta4);
        pi[15,13] = inv_logit(beta1+gamma1+beta4+gamma4);
        pi[15,14] = inv_logit(beta1+gamma1+beta4+gamma4);
        pi[15,15] = inv_logit(beta1+beta4+gamma4);
        pi[15,16] = inv_logit(beta1+gamma1+beta4+gamma4);
        pi[16,1] = inv_logit(beta1);
        pi[16,2] = inv_logit(beta1+gamma1);
        pi[16,3] = inv_logit(beta1);
        pi[16,4] = inv_logit(beta1);
        pi[16,5] = inv_logit(beta1);
        pi[16,6] = inv_logit(beta1+gamma1);
        pi[16,7] = inv_logit(beta1+gamma1);
        pi[16,8] = inv_logit(beta1+gamma1);
        pi[16,9] = inv_logit(beta1);
        pi[16,10] = inv_logit(beta1);
        pi[16,11] = inv_logit(beta1);
        pi[16,12] = inv_logit(beta1+gamma1);
        pi[16,13] = inv_logit(beta1+gamma1);
        pi[16,14] = inv_logit(beta1+gamma1);
        pi[16,15] = inv_logit(beta1);
        pi[16,16] = inv_logit(beta1+gamma1);
        pi[17,1] = inv_logit(beta1);
        pi[17,2] = inv_logit(beta1+gamma1);
        pi[17,3] = inv_logit(beta1);
        pi[17,4] = inv_logit(beta1);
        pi[17,5] = inv_logit(beta1);
        pi[17,6] = inv_logit(beta1+gamma1);
        pi[17,7] = inv_logit(beta1+gamma1);
        pi[17,8] = inv_logit(beta1+gamma1);
        pi[17,9] = inv_logit(beta1);
        pi[17,10] = inv_logit(beta1);
        pi[17,11] = inv_logit(beta1);
        pi[17,12] = inv_logit(beta1+gamma1);
        pi[17,13] = inv_logit(beta1+gamma1);
        pi[17,14] = inv_logit(beta1+gamma1);
        pi[17,15] = inv_logit(beta1);
        pi[17,16] = inv_logit(beta1+gamma1);
        pi[18,1] = inv_logit(beta2+beta4);
        pi[18,2] = inv_logit(beta2+beta4);
        pi[18,3] = inv_logit(beta2+gamma2+beta4);
        pi[18,4] = inv_logit(beta2+beta4);
        pi[18,5] = inv_logit(beta2+beta4+gamma4);
        pi[18,6] = inv_logit(beta2+gamma2+beta4);
        pi[18,7] = inv_logit(beta2+beta4);
        pi[18,8] = inv_logit(beta2+beta4+gamma4);
        pi[18,9] = inv_logit(beta2+gamma2+beta4);
        pi[18,10] = inv_logit(beta2+gamma2+beta4+gamma4);
        pi[18,11] = inv_logit(beta2+beta4+gamma4);
        pi[18,12] = inv_logit(beta2+gamma2+beta4);
        pi[18,13] = inv_logit(beta2+gamma2+beta4+gamma4);
        pi[18,14] = inv_logit(beta2+beta4+gamma4);
        pi[18,15] = inv_logit(beta2+gamma2+beta4+gamma4);
        pi[18,16] = inv_logit(beta2+gamma2+beta4+gamma4);
        pi[19,1] = inv_logit(beta1+beta2);
        pi[19,2] = inv_logit(beta1+gamma1+beta2);
        pi[19,3] = inv_logit(beta1+beta2+gamma2);
        pi[19,4] = inv_logit(beta1+beta2);
        pi[19,5] = inv_logit(beta1+beta2);
        pi[19,6] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[19,7] = inv_logit(beta1+gamma1+beta2);
        pi[19,8] = inv_logit(beta1+gamma1+beta2);
        pi[19,9] = inv_logit(beta1+beta2+gamma2);
        pi[19,10] = inv_logit(beta1+beta2+gamma2);
        pi[19,11] = inv_logit(beta1+beta2);
        pi[19,12] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[19,13] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[19,14] = inv_logit(beta1+gamma1+beta2);
        pi[19,15] = inv_logit(beta1+beta2+gamma2);
        pi[19,16] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[20,1] = inv_logit(beta2+beta4);
        pi[20,2] = inv_logit(beta2+beta4);
        pi[20,3] = inv_logit(beta2+gamma2+beta4);
        pi[20,4] = inv_logit(beta2+beta4);
        pi[20,5] = inv_logit(beta2+beta4+gamma4);
        pi[20,6] = inv_logit(beta2+gamma2+beta4);
        pi[20,7] = inv_logit(beta2+beta4);
        pi[20,8] = inv_logit(beta2+beta4+gamma4);
        pi[20,9] = inv_logit(beta2+gamma2+beta4);
        pi[20,10] = inv_logit(beta2+gamma2+beta4+gamma4);
        pi[20,11] = inv_logit(beta2+beta4+gamma4);
        pi[20,12] = inv_logit(beta2+gamma2+beta4);
        pi[20,13] = inv_logit(beta2+gamma2+beta4+gamma4);
        pi[20,14] = inv_logit(beta2+beta4+gamma4);
        pi[20,15] = inv_logit(beta2+gamma2+beta4+gamma4);
        pi[20,16] = inv_logit(beta2+gamma2+beta4+gamma4);
        pi[21,1] = inv_logit(beta2);
        pi[21,2] = inv_logit(beta2);
        pi[21,3] = inv_logit(beta2+gamma2);
        pi[21,4] = inv_logit(beta2);
        pi[21,5] = inv_logit(beta2);
        pi[21,6] = inv_logit(beta2+gamma2);
        pi[21,7] = inv_logit(beta2);
        pi[21,8] = inv_logit(beta2);
        pi[21,9] = inv_logit(beta2+gamma2);
        pi[21,10] = inv_logit(beta2+gamma2);
        pi[21,11] = inv_logit(beta2);
        pi[21,12] = inv_logit(beta2+gamma2);
        pi[21,13] = inv_logit(beta2+gamma2);
        pi[21,14] = inv_logit(beta2);
        pi[21,15] = inv_logit(beta2+gamma2);
        pi[21,16] = inv_logit(beta2+gamma2);
        pi[22,1] = inv_logit(beta2);
        pi[22,2] = inv_logit(beta2);
        pi[22,3] = inv_logit(beta2+gamma2);
        pi[22,4] = inv_logit(beta2);
        pi[22,5] = inv_logit(beta2);
        pi[22,6] = inv_logit(beta2+gamma2);
        pi[22,7] = inv_logit(beta2);
        pi[22,8] = inv_logit(beta2);
        pi[22,9] = inv_logit(beta2+gamma2);
        pi[22,10] = inv_logit(beta2+gamma2);
        pi[22,11] = inv_logit(beta2);
        pi[22,12] = inv_logit(beta2+gamma2);
        pi[22,13] = inv_logit(beta2+gamma2);
        pi[22,14] = inv_logit(beta2);
        pi[22,15] = inv_logit(beta2+gamma2);
        pi[22,16] = inv_logit(beta2+gamma2);
        pi[23,1] = inv_logit(beta1);
        pi[23,2] = inv_logit(beta1+gamma1);
        pi[23,3] = inv_logit(beta1);
        pi[23,4] = inv_logit(beta1);
        pi[23,5] = inv_logit(beta1);
        pi[23,6] = inv_logit(beta1+gamma1);
        pi[23,7] = inv_logit(beta1+gamma1);
        pi[23,8] = inv_logit(beta1+gamma1);
        pi[23,9] = inv_logit(beta1);
        pi[23,10] = inv_logit(beta1);
        pi[23,11] = inv_logit(beta1);
        pi[23,12] = inv_logit(beta1+gamma1);
        pi[23,13] = inv_logit(beta1+gamma1);
        pi[23,14] = inv_logit(beta1+gamma1);
        pi[23,15] = inv_logit(beta1);
        pi[23,16] = inv_logit(beta1+gamma1);
        pi[24,1] = inv_logit(beta1+beta2);
        pi[24,2] = inv_logit(beta1+gamma1+beta2);
        pi[24,3] = inv_logit(beta1+beta2+gamma2);
        pi[24,4] = inv_logit(beta1+beta2);
        pi[24,5] = inv_logit(beta1+beta2);
        pi[24,6] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[24,7] = inv_logit(beta1+gamma1+beta2);
        pi[24,8] = inv_logit(beta1+gamma1+beta2);
        pi[24,9] = inv_logit(beta1+beta2+gamma2);
        pi[24,10] = inv_logit(beta1+beta2+gamma2);
        pi[24,11] = inv_logit(beta1+beta2);
        pi[24,12] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[24,13] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[24,14] = inv_logit(beta1+gamma1+beta2);
        pi[24,15] = inv_logit(beta1+beta2+gamma2);
        pi[24,16] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[25,1] = inv_logit(beta1+beta2);
        pi[25,2] = inv_logit(beta1+gamma1+beta2);
        pi[25,3] = inv_logit(beta1+beta2+gamma2);
        pi[25,4] = inv_logit(beta1+beta2);
        pi[25,5] = inv_logit(beta1+beta2);
        pi[25,6] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[25,7] = inv_logit(beta1+gamma1+beta2);
        pi[25,8] = inv_logit(beta1+gamma1+beta2);
        pi[25,9] = inv_logit(beta1+beta2+gamma2);
        pi[25,10] = inv_logit(beta1+beta2+gamma2);
        pi[25,11] = inv_logit(beta1+beta2);
        pi[25,12] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[25,13] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[25,14] = inv_logit(beta1+gamma1+beta2);
        pi[25,15] = inv_logit(beta1+beta2+gamma2);
        pi[25,16] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[26,1] = inv_logit(beta1);
        pi[26,2] = inv_logit(beta1+gamma1);
        pi[26,3] = inv_logit(beta1);
        pi[26,4] = inv_logit(beta1);
        pi[26,5] = inv_logit(beta1);
        pi[26,6] = inv_logit(beta1+gamma1);
        pi[26,7] = inv_logit(beta1+gamma1);
        pi[26,8] = inv_logit(beta1+gamma1);
        pi[26,9] = inv_logit(beta1);
        pi[26,10] = inv_logit(beta1);
        pi[26,11] = inv_logit(beta1);
        pi[26,12] = inv_logit(beta1+gamma1);
        pi[26,13] = inv_logit(beta1+gamma1);
        pi[26,14] = inv_logit(beta1+gamma1);
        pi[26,15] = inv_logit(beta1);
        pi[26,16] = inv_logit(beta1+gamma1);
        pi[27,1] = inv_logit(beta1+beta2);
        pi[27,2] = inv_logit(beta1+gamma1+beta2);
        pi[27,3] = inv_logit(beta1+beta2+gamma2);
        pi[27,4] = inv_logit(beta1+beta2);
        pi[27,5] = inv_logit(beta1+beta2);
        pi[27,6] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[27,7] = inv_logit(beta1+gamma1+beta2);
        pi[27,8] = inv_logit(beta1+gamma1+beta2);
        pi[27,9] = inv_logit(beta1+beta2+gamma2);
        pi[27,10] = inv_logit(beta1+beta2+gamma2);
        pi[27,11] = inv_logit(beta1+beta2);
        pi[27,12] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[27,13] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[27,14] = inv_logit(beta1+gamma1+beta2);
        pi[27,15] = inv_logit(beta1+beta2+gamma2);
        pi[27,16] = inv_logit(beta1+gamma1+beta2+gamma2);
      }
      model {
      
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        beta1 ~ normal(0, 2);
        gamma1 ~ lognormal(0, 1);
        beta2 ~ normal(0, 2);
        gamma2 ~ lognormal(0, 1);
        beta3 ~ normal(0, 2);
        gamma3 ~ lognormal(0, 1);
        beta4 ~ normal(0, 2);
        gamma4 ~ lognormal(0, 1);
      
        ////////////////////////////////// likelihood
        for (r in 1:R) {
          row_vector[C] ps;
          for (c in 1:C) {
            array[num[r]] real log_items;
            for (m in 1:num[r]) {
              int i = ii[start[r] + m - 1];
              log_items[m] = y[start[r] + m - 1] * log(pi[i,c]) +
                             (1 - y[start[r] + m - 1]) * log(1 - pi[i,c]);
            }
            ps[c] = log_Vc[c] + sum(log_items);
          }
          target += log_sum_exp(ps);
        }
      }

---

    Code
      generate_stan(ecpe_spec2)
    Output
      data {
        int<lower=1> I;                      // number of items
        int<lower=1> R;                      // number of respondents
        int<lower=1> N;                      // number of observations
        int<lower=1> C;                      // number of classes
        int<lower=1> A;                      // number of attributes
        array[N] int<lower=1,upper=I> ii;    // item for observation n
        array[N] int<lower=1,upper=R> rr;    // respondent for observation n
        array[N] int<lower=0,upper=1> y;     // score for observation n
        array[R] int<lower=1,upper=N> start; // starting row for respondent R
        array[R] int<lower=1,upper=I> num;   // number of items for respondent R
        matrix[C,A] Alpha;                   // attribute pattern for each class
        matrix[I,C] Xi;                      // class attribute mastery indicator
      }
      parameters {
        array[A] real<lower=0,upper=1> eta;
      
        ////////////////////////////////// attribute intercepts
        real beta1;
        real beta2;
        real beta3;
      
        ////////////////////////////////// attribute main effects
        real<lower=0> gamma1;
        real<lower=0> gamma2;
        real<lower=0> gamma3;
      }
      transformed parameters {
        simplex[C] Vc;
        vector[C] log_Vc;
        for (c in 1:C) {
          Vc[c] = 1;
          for (a in 1:A) {
            Vc[c] = Vc[c] * eta[a]^Alpha[c,a] * 
                    (1 - eta[a]) ^ (1 - Alpha[c,a]);
          }
        }
        log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = inv_logit(beta1+beta2);
        pi[1,2] = inv_logit(beta1+gamma1+beta2);
        pi[1,3] = inv_logit(beta1+beta2+gamma2);
        pi[1,4] = inv_logit(beta1+beta2);
        pi[1,5] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[1,6] = inv_logit(beta1+gamma1+beta2);
        pi[1,7] = inv_logit(beta1+beta2+gamma2);
        pi[1,8] = inv_logit(beta1+gamma1+beta2+gamma2);
        pi[2,1] = inv_logit(beta2);
        pi[2,2] = inv_logit(beta2);
        pi[2,3] = inv_logit(beta2+gamma2);
        pi[2,4] = inv_logit(beta2);
        pi[2,5] = inv_logit(beta2+gamma2);
        pi[2,6] = inv_logit(beta2);
        pi[2,7] = inv_logit(beta2+gamma2);
        pi[2,8] = inv_logit(beta2+gamma2);
        pi[3,1] = inv_logit(beta1+beta3);
        pi[3,2] = inv_logit(beta1+gamma1+beta3);
        pi[3,3] = inv_logit(beta1+beta3);
        pi[3,4] = inv_logit(beta1+beta3+gamma3);
        pi[3,5] = inv_logit(beta1+gamma1+beta3);
        pi[3,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[3,7] = inv_logit(beta1+beta3+gamma3);
        pi[3,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[4,1] = inv_logit(beta3);
        pi[4,2] = inv_logit(beta3);
        pi[4,3] = inv_logit(beta3);
        pi[4,4] = inv_logit(beta3+gamma3);
        pi[4,5] = inv_logit(beta3);
        pi[4,6] = inv_logit(beta3+gamma3);
        pi[4,7] = inv_logit(beta3+gamma3);
        pi[4,8] = inv_logit(beta3+gamma3);
        pi[5,1] = inv_logit(beta3);
        pi[5,2] = inv_logit(beta3);
        pi[5,3] = inv_logit(beta3);
        pi[5,4] = inv_logit(beta3+gamma3);
        pi[5,5] = inv_logit(beta3);
        pi[5,6] = inv_logit(beta3+gamma3);
        pi[5,7] = inv_logit(beta3+gamma3);
        pi[5,8] = inv_logit(beta3+gamma3);
        pi[6,1] = inv_logit(beta3);
        pi[6,2] = inv_logit(beta3);
        pi[6,3] = inv_logit(beta3);
        pi[6,4] = inv_logit(beta3+gamma3);
        pi[6,5] = inv_logit(beta3);
        pi[6,6] = inv_logit(beta3+gamma3);
        pi[6,7] = inv_logit(beta3+gamma3);
        pi[6,8] = inv_logit(beta3+gamma3);
        pi[7,1] = inv_logit(beta1+beta3);
        pi[7,2] = inv_logit(beta1+gamma1+beta3);
        pi[7,3] = inv_logit(beta1+beta3);
        pi[7,4] = inv_logit(beta1+beta3+gamma3);
        pi[7,5] = inv_logit(beta1+gamma1+beta3);
        pi[7,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[7,7] = inv_logit(beta1+beta3+gamma3);
        pi[7,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[8,1] = inv_logit(beta2);
        pi[8,2] = inv_logit(beta2);
        pi[8,3] = inv_logit(beta2+gamma2);
        pi[8,4] = inv_logit(beta2);
        pi[8,5] = inv_logit(beta2+gamma2);
        pi[8,6] = inv_logit(beta2);
        pi[8,7] = inv_logit(beta2+gamma2);
        pi[8,8] = inv_logit(beta2+gamma2);
        pi[9,1] = inv_logit(beta3);
        pi[9,2] = inv_logit(beta3);
        pi[9,3] = inv_logit(beta3);
        pi[9,4] = inv_logit(beta3+gamma3);
        pi[9,5] = inv_logit(beta3);
        pi[9,6] = inv_logit(beta3+gamma3);
        pi[9,7] = inv_logit(beta3+gamma3);
        pi[9,8] = inv_logit(beta3+gamma3);
        pi[10,1] = inv_logit(beta1);
        pi[10,2] = inv_logit(beta1+gamma1);
        pi[10,3] = inv_logit(beta1);
        pi[10,4] = inv_logit(beta1);
        pi[10,5] = inv_logit(beta1+gamma1);
        pi[10,6] = inv_logit(beta1+gamma1);
        pi[10,7] = inv_logit(beta1);
        pi[10,8] = inv_logit(beta1+gamma1);
        pi[11,1] = inv_logit(beta1+beta3);
        pi[11,2] = inv_logit(beta1+gamma1+beta3);
        pi[11,3] = inv_logit(beta1+beta3);
        pi[11,4] = inv_logit(beta1+beta3+gamma3);
        pi[11,5] = inv_logit(beta1+gamma1+beta3);
        pi[11,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[11,7] = inv_logit(beta1+beta3+gamma3);
        pi[11,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[12,1] = inv_logit(beta1+beta3);
        pi[12,2] = inv_logit(beta1+gamma1+beta3);
        pi[12,3] = inv_logit(beta1+beta3);
        pi[12,4] = inv_logit(beta1+beta3+gamma3);
        pi[12,5] = inv_logit(beta1+gamma1+beta3);
        pi[12,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[12,7] = inv_logit(beta1+beta3+gamma3);
        pi[12,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[13,1] = inv_logit(beta1);
        pi[13,2] = inv_logit(beta1+gamma1);
        pi[13,3] = inv_logit(beta1);
        pi[13,4] = inv_logit(beta1);
        pi[13,5] = inv_logit(beta1+gamma1);
        pi[13,6] = inv_logit(beta1+gamma1);
        pi[13,7] = inv_logit(beta1);
        pi[13,8] = inv_logit(beta1+gamma1);
        pi[14,1] = inv_logit(beta1);
        pi[14,2] = inv_logit(beta1+gamma1);
        pi[14,3] = inv_logit(beta1);
        pi[14,4] = inv_logit(beta1);
        pi[14,5] = inv_logit(beta1+gamma1);
        pi[14,6] = inv_logit(beta1+gamma1);
        pi[14,7] = inv_logit(beta1);
        pi[14,8] = inv_logit(beta1+gamma1);
        pi[15,1] = inv_logit(beta3);
        pi[15,2] = inv_logit(beta3);
        pi[15,3] = inv_logit(beta3);
        pi[15,4] = inv_logit(beta3+gamma3);
        pi[15,5] = inv_logit(beta3);
        pi[15,6] = inv_logit(beta3+gamma3);
        pi[15,7] = inv_logit(beta3+gamma3);
        pi[15,8] = inv_logit(beta3+gamma3);
        pi[16,1] = inv_logit(beta1+beta3);
        pi[16,2] = inv_logit(beta1+gamma1+beta3);
        pi[16,3] = inv_logit(beta1+beta3);
        pi[16,4] = inv_logit(beta1+beta3+gamma3);
        pi[16,5] = inv_logit(beta1+gamma1+beta3);
        pi[16,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[16,7] = inv_logit(beta1+beta3+gamma3);
        pi[16,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[17,1] = inv_logit(beta2+beta3);
        pi[17,2] = inv_logit(beta2+beta3);
        pi[17,3] = inv_logit(beta2+gamma2+beta3);
        pi[17,4] = inv_logit(beta2+beta3+gamma3);
        pi[17,5] = inv_logit(beta2+gamma2+beta3);
        pi[17,6] = inv_logit(beta2+beta3+gamma3);
        pi[17,7] = inv_logit(beta2+gamma2+beta3+gamma3);
        pi[17,8] = inv_logit(beta2+gamma2+beta3+gamma3);
        pi[18,1] = inv_logit(beta3);
        pi[18,2] = inv_logit(beta3);
        pi[18,3] = inv_logit(beta3);
        pi[18,4] = inv_logit(beta3+gamma3);
        pi[18,5] = inv_logit(beta3);
        pi[18,6] = inv_logit(beta3+gamma3);
        pi[18,7] = inv_logit(beta3+gamma3);
        pi[18,8] = inv_logit(beta3+gamma3);
        pi[19,1] = inv_logit(beta3);
        pi[19,2] = inv_logit(beta3);
        pi[19,3] = inv_logit(beta3);
        pi[19,4] = inv_logit(beta3+gamma3);
        pi[19,5] = inv_logit(beta3);
        pi[19,6] = inv_logit(beta3+gamma3);
        pi[19,7] = inv_logit(beta3+gamma3);
        pi[19,8] = inv_logit(beta3+gamma3);
        pi[20,1] = inv_logit(beta1+beta3);
        pi[20,2] = inv_logit(beta1+gamma1+beta3);
        pi[20,3] = inv_logit(beta1+beta3);
        pi[20,4] = inv_logit(beta1+beta3+gamma3);
        pi[20,5] = inv_logit(beta1+gamma1+beta3);
        pi[20,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[20,7] = inv_logit(beta1+beta3+gamma3);
        pi[20,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[21,1] = inv_logit(beta1+beta3);
        pi[21,2] = inv_logit(beta1+gamma1+beta3);
        pi[21,3] = inv_logit(beta1+beta3);
        pi[21,4] = inv_logit(beta1+beta3+gamma3);
        pi[21,5] = inv_logit(beta1+gamma1+beta3);
        pi[21,6] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[21,7] = inv_logit(beta1+beta3+gamma3);
        pi[21,8] = inv_logit(beta1+gamma1+beta3+gamma3);
        pi[22,1] = inv_logit(beta3);
        pi[22,2] = inv_logit(beta3);
        pi[22,3] = inv_logit(beta3);
        pi[22,4] = inv_logit(beta3+gamma3);
        pi[22,5] = inv_logit(beta3);
        pi[22,6] = inv_logit(beta3+gamma3);
        pi[22,7] = inv_logit(beta3+gamma3);
        pi[22,8] = inv_logit(beta3+gamma3);
        pi[23,1] = inv_logit(beta2);
        pi[23,2] = inv_logit(beta2);
        pi[23,3] = inv_logit(beta2+gamma2);
        pi[23,4] = inv_logit(beta2);
        pi[23,5] = inv_logit(beta2+gamma2);
        pi[23,6] = inv_logit(beta2);
        pi[23,7] = inv_logit(beta2+gamma2);
        pi[23,8] = inv_logit(beta2+gamma2);
        pi[24,1] = inv_logit(beta2);
        pi[24,2] = inv_logit(beta2);
        pi[24,3] = inv_logit(beta2+gamma2);
        pi[24,4] = inv_logit(beta2);
        pi[24,5] = inv_logit(beta2+gamma2);
        pi[24,6] = inv_logit(beta2);
        pi[24,7] = inv_logit(beta2+gamma2);
        pi[24,8] = inv_logit(beta2+gamma2);
        pi[25,1] = inv_logit(beta1);
        pi[25,2] = inv_logit(beta1+gamma1);
        pi[25,3] = inv_logit(beta1);
        pi[25,4] = inv_logit(beta1);
        pi[25,5] = inv_logit(beta1+gamma1);
        pi[25,6] = inv_logit(beta1+gamma1);
        pi[25,7] = inv_logit(beta1);
        pi[25,8] = inv_logit(beta1+gamma1);
        pi[26,1] = inv_logit(beta3);
        pi[26,2] = inv_logit(beta3);
        pi[26,3] = inv_logit(beta3);
        pi[26,4] = inv_logit(beta3+gamma3);
        pi[26,5] = inv_logit(beta3);
        pi[26,6] = inv_logit(beta3+gamma3);
        pi[26,7] = inv_logit(beta3+gamma3);
        pi[26,8] = inv_logit(beta3+gamma3);
        pi[27,1] = inv_logit(beta1);
        pi[27,2] = inv_logit(beta1+gamma1);
        pi[27,3] = inv_logit(beta1);
        pi[27,4] = inv_logit(beta1);
        pi[27,5] = inv_logit(beta1+gamma1);
        pi[27,6] = inv_logit(beta1+gamma1);
        pi[27,7] = inv_logit(beta1);
        pi[27,8] = inv_logit(beta1+gamma1);
        pi[28,1] = inv_logit(beta3);
        pi[28,2] = inv_logit(beta3);
        pi[28,3] = inv_logit(beta3);
        pi[28,4] = inv_logit(beta3+gamma3);
        pi[28,5] = inv_logit(beta3);
        pi[28,6] = inv_logit(beta3+gamma3);
        pi[28,7] = inv_logit(beta3+gamma3);
        pi[28,8] = inv_logit(beta3+gamma3);
      }
      model {
      
        ////////////////////////////////// priors
        eta[1] ~ beta(1, 1);
        eta[2] ~ beta(1, 1);
        eta[3] ~ beta(1, 1);
        beta1 ~ normal(0, 2);
        gamma1 ~ lognormal(0, 1);
        beta2 ~ normal(0, 2);
        gamma2 ~ lognormal(0, 1);
        beta3 ~ normal(0, 2);
        gamma3 ~ lognormal(0, 1);
      
        ////////////////////////////////// likelihood
        for (r in 1:R) {
          row_vector[C] ps;
          for (c in 1:C) {
            array[num[r]] real log_items;
            for (m in 1:num[r]) {
              int i = ii[start[r] + m - 1];
              log_items[m] = y[start[r] + m - 1] * log(pi[i,c]) +
                             (1 - y[start[r] + m - 1]) * log(1 - pi[i,c]);
            }
            ps[c] = log_Vc[c] + sum(log_items);
          }
          target += log_sum_exp(ps);
        }
      }

