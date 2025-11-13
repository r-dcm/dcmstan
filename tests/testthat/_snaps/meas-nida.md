# nida script works

    Code
      stan_code(ecpe_spec)
    Output
      data {
        int<lower=1> I;                      // number of items
        int<lower=1> R;                      // number of respondents
        int<lower=1> N;                      // number of observations
        int<lower=1> C;                      // number of classes
        array[N] int<lower=1,upper=I> ii;    // item for observation n
        array[N] int<lower=1,upper=R> rr;    // respondent for observation n
        array[N] int<lower=0,upper=1> y;     // score for observation n
        array[R] int<lower=1,upper=N> start; // starting row for respondent R
        array[R] int<lower=1,upper=I> num;   // number items for respondent R
        int<lower=1> A;                      // number of attributes
      }
      parameters {
        simplex[C] Vc;
      
        ////////////////////////////////// attribute parameters
        array[A] real<lower=0,upper=1> slip;
        array[A] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = guess[1]*guess[2];
        pi[1,2] = (1 - slip[1])*guess[2];
        pi[1,3] = guess[1]*(1 - slip[2]);
        pi[1,4] = guess[1]*guess[2];
        pi[1,5] = (1 - slip[1])*(1 - slip[2]);
        pi[1,6] = (1 - slip[1])*guess[2];
        pi[1,7] = guess[1]*(1 - slip[2]);
        pi[1,8] = (1 - slip[1])*(1 - slip[2]);
        pi[2,1] = guess[2];
        pi[2,2] = guess[2];
        pi[2,3] = (1 - slip[2]);
        pi[2,4] = guess[2];
        pi[2,5] = (1 - slip[2]);
        pi[2,6] = guess[2];
        pi[2,7] = (1 - slip[2]);
        pi[2,8] = (1 - slip[2]);
        pi[3,1] = guess[1]*guess[3];
        pi[3,2] = (1 - slip[1])*guess[3];
        pi[3,3] = guess[1]*guess[3];
        pi[3,4] = guess[1]*(1 - slip[3]);
        pi[3,5] = (1 - slip[1])*guess[3];
        pi[3,6] = (1 - slip[1])*(1 - slip[3]);
        pi[3,7] = guess[1]*(1 - slip[3]);
        pi[3,8] = (1 - slip[1])*(1 - slip[3]);
        pi[4,1] = guess[3];
        pi[4,2] = guess[3];
        pi[4,3] = guess[3];
        pi[4,4] = (1 - slip[3]);
        pi[4,5] = guess[3];
        pi[4,6] = (1 - slip[3]);
        pi[4,7] = (1 - slip[3]);
        pi[4,8] = (1 - slip[3]);
        pi[5,1] = guess[3];
        pi[5,2] = guess[3];
        pi[5,3] = guess[3];
        pi[5,4] = (1 - slip[3]);
        pi[5,5] = guess[3];
        pi[5,6] = (1 - slip[3]);
        pi[5,7] = (1 - slip[3]);
        pi[5,8] = (1 - slip[3]);
        pi[6,1] = guess[3];
        pi[6,2] = guess[3];
        pi[6,3] = guess[3];
        pi[6,4] = (1 - slip[3]);
        pi[6,5] = guess[3];
        pi[6,6] = (1 - slip[3]);
        pi[6,7] = (1 - slip[3]);
        pi[6,8] = (1 - slip[3]);
        pi[7,1] = guess[1]*guess[3];
        pi[7,2] = (1 - slip[1])*guess[3];
        pi[7,3] = guess[1]*guess[3];
        pi[7,4] = guess[1]*(1 - slip[3]);
        pi[7,5] = (1 - slip[1])*guess[3];
        pi[7,6] = (1 - slip[1])*(1 - slip[3]);
        pi[7,7] = guess[1]*(1 - slip[3]);
        pi[7,8] = (1 - slip[1])*(1 - slip[3]);
        pi[8,1] = guess[2];
        pi[8,2] = guess[2];
        pi[8,3] = (1 - slip[2]);
        pi[8,4] = guess[2];
        pi[8,5] = (1 - slip[2]);
        pi[8,6] = guess[2];
        pi[8,7] = (1 - slip[2]);
        pi[8,8] = (1 - slip[2]);
        pi[9,1] = guess[3];
        pi[9,2] = guess[3];
        pi[9,3] = guess[3];
        pi[9,4] = (1 - slip[3]);
        pi[9,5] = guess[3];
        pi[9,6] = (1 - slip[3]);
        pi[9,7] = (1 - slip[3]);
        pi[9,8] = (1 - slip[3]);
        pi[10,1] = guess[1];
        pi[10,2] = (1 - slip[1]);
        pi[10,3] = guess[1];
        pi[10,4] = guess[1];
        pi[10,5] = (1 - slip[1]);
        pi[10,6] = (1 - slip[1]);
        pi[10,7] = guess[1];
        pi[10,8] = (1 - slip[1]);
        pi[11,1] = guess[1]*guess[3];
        pi[11,2] = (1 - slip[1])*guess[3];
        pi[11,3] = guess[1]*guess[3];
        pi[11,4] = guess[1]*(1 - slip[3]);
        pi[11,5] = (1 - slip[1])*guess[3];
        pi[11,6] = (1 - slip[1])*(1 - slip[3]);
        pi[11,7] = guess[1]*(1 - slip[3]);
        pi[11,8] = (1 - slip[1])*(1 - slip[3]);
        pi[12,1] = guess[1]*guess[3];
        pi[12,2] = (1 - slip[1])*guess[3];
        pi[12,3] = guess[1]*guess[3];
        pi[12,4] = guess[1]*(1 - slip[3]);
        pi[12,5] = (1 - slip[1])*guess[3];
        pi[12,6] = (1 - slip[1])*(1 - slip[3]);
        pi[12,7] = guess[1]*(1 - slip[3]);
        pi[12,8] = (1 - slip[1])*(1 - slip[3]);
        pi[13,1] = guess[1];
        pi[13,2] = (1 - slip[1]);
        pi[13,3] = guess[1];
        pi[13,4] = guess[1];
        pi[13,5] = (1 - slip[1]);
        pi[13,6] = (1 - slip[1]);
        pi[13,7] = guess[1];
        pi[13,8] = (1 - slip[1]);
        pi[14,1] = guess[1];
        pi[14,2] = (1 - slip[1]);
        pi[14,3] = guess[1];
        pi[14,4] = guess[1];
        pi[14,5] = (1 - slip[1]);
        pi[14,6] = (1 - slip[1]);
        pi[14,7] = guess[1];
        pi[14,8] = (1 - slip[1]);
        pi[15,1] = guess[3];
        pi[15,2] = guess[3];
        pi[15,3] = guess[3];
        pi[15,4] = (1 - slip[3]);
        pi[15,5] = guess[3];
        pi[15,6] = (1 - slip[3]);
        pi[15,7] = (1 - slip[3]);
        pi[15,8] = (1 - slip[3]);
        pi[16,1] = guess[1]*guess[3];
        pi[16,2] = (1 - slip[1])*guess[3];
        pi[16,3] = guess[1]*guess[3];
        pi[16,4] = guess[1]*(1 - slip[3]);
        pi[16,5] = (1 - slip[1])*guess[3];
        pi[16,6] = (1 - slip[1])*(1 - slip[3]);
        pi[16,7] = guess[1]*(1 - slip[3]);
        pi[16,8] = (1 - slip[1])*(1 - slip[3]);
        pi[17,1] = guess[2]*guess[3];
        pi[17,2] = guess[2]*guess[3];
        pi[17,3] = (1 - slip[2])*guess[3];
        pi[17,4] = guess[2]*(1 - slip[3]);
        pi[17,5] = (1 - slip[2])*guess[3];
        pi[17,6] = guess[2]*(1 - slip[3]);
        pi[17,7] = (1 - slip[2])*(1 - slip[3]);
        pi[17,8] = (1 - slip[2])*(1 - slip[3]);
        pi[18,1] = guess[3];
        pi[18,2] = guess[3];
        pi[18,3] = guess[3];
        pi[18,4] = (1 - slip[3]);
        pi[18,5] = guess[3];
        pi[18,6] = (1 - slip[3]);
        pi[18,7] = (1 - slip[3]);
        pi[18,8] = (1 - slip[3]);
        pi[19,1] = guess[3];
        pi[19,2] = guess[3];
        pi[19,3] = guess[3];
        pi[19,4] = (1 - slip[3]);
        pi[19,5] = guess[3];
        pi[19,6] = (1 - slip[3]);
        pi[19,7] = (1 - slip[3]);
        pi[19,8] = (1 - slip[3]);
        pi[20,1] = guess[1]*guess[3];
        pi[20,2] = (1 - slip[1])*guess[3];
        pi[20,3] = guess[1]*guess[3];
        pi[20,4] = guess[1]*(1 - slip[3]);
        pi[20,5] = (1 - slip[1])*guess[3];
        pi[20,6] = (1 - slip[1])*(1 - slip[3]);
        pi[20,7] = guess[1]*(1 - slip[3]);
        pi[20,8] = (1 - slip[1])*(1 - slip[3]);
        pi[21,1] = guess[1]*guess[3];
        pi[21,2] = (1 - slip[1])*guess[3];
        pi[21,3] = guess[1]*guess[3];
        pi[21,4] = guess[1]*(1 - slip[3]);
        pi[21,5] = (1 - slip[1])*guess[3];
        pi[21,6] = (1 - slip[1])*(1 - slip[3]);
        pi[21,7] = guess[1]*(1 - slip[3]);
        pi[21,8] = (1 - slip[1])*(1 - slip[3]);
        pi[22,1] = guess[3];
        pi[22,2] = guess[3];
        pi[22,3] = guess[3];
        pi[22,4] = (1 - slip[3]);
        pi[22,5] = guess[3];
        pi[22,6] = (1 - slip[3]);
        pi[22,7] = (1 - slip[3]);
        pi[22,8] = (1 - slip[3]);
        pi[23,1] = guess[2];
        pi[23,2] = guess[2];
        pi[23,3] = (1 - slip[2]);
        pi[23,4] = guess[2];
        pi[23,5] = (1 - slip[2]);
        pi[23,6] = guess[2];
        pi[23,7] = (1 - slip[2]);
        pi[23,8] = (1 - slip[2]);
        pi[24,1] = guess[2];
        pi[24,2] = guess[2];
        pi[24,3] = (1 - slip[2]);
        pi[24,4] = guess[2];
        pi[24,5] = (1 - slip[2]);
        pi[24,6] = guess[2];
        pi[24,7] = (1 - slip[2]);
        pi[24,8] = (1 - slip[2]);
        pi[25,1] = guess[1];
        pi[25,2] = (1 - slip[1]);
        pi[25,3] = guess[1];
        pi[25,4] = guess[1];
        pi[25,5] = (1 - slip[1]);
        pi[25,6] = (1 - slip[1]);
        pi[25,7] = guess[1];
        pi[25,8] = (1 - slip[1]);
        pi[26,1] = guess[3];
        pi[26,2] = guess[3];
        pi[26,3] = guess[3];
        pi[26,4] = (1 - slip[3]);
        pi[26,5] = guess[3];
        pi[26,6] = (1 - slip[3]);
        pi[26,7] = (1 - slip[3]);
        pi[26,8] = (1 - slip[3]);
        pi[27,1] = guess[1];
        pi[27,2] = (1 - slip[1]);
        pi[27,3] = guess[1];
        pi[27,4] = guess[1];
        pi[27,5] = (1 - slip[1]);
        pi[27,6] = (1 - slip[1]);
        pi[27,7] = guess[1];
        pi[27,8] = (1 - slip[1]);
        pi[28,1] = guess[3];
        pi[28,2] = guess[3];
        pi[28,3] = guess[3];
        pi[28,4] = (1 - slip[3]);
        pi[28,5] = guess[3];
        pi[28,6] = (1 - slip[3]);
        pi[28,7] = (1 - slip[3]);
        pi[28,8] = (1 - slip[3]);
      }
      model {
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        slip[1] ~ beta(5, 25);
        guess[1] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
      
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
      stan_code(mdm_spec)
    Output
      data {
        int<lower=1> I;                      // number of items
        int<lower=1> R;                      // number of respondents
        int<lower=1> N;                      // number of observations
        int<lower=1> C;                      // number of classes
        array[N] int<lower=1,upper=I> ii;    // item for observation n
        array[N] int<lower=1,upper=R> rr;    // respondent for observation n
        array[N] int<lower=0,upper=1> y;     // score for observation n
        array[R] int<lower=1,upper=N> start; // starting row for respondent R
        array[R] int<lower=1,upper=I> num;   // number items for respondent R
        int<lower=1> A;                      // number of attributes
      }
      parameters {
        simplex[C] Vc;
      
        ////////////////////////////////// attribute parameters
        array[A] real<lower=0,upper=1> slip;
        array[A] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = guess[1];
        pi[1,2] = (1 - slip[1]);
        pi[2,1] = guess[1];
        pi[2,2] = (1 - slip[1]);
        pi[3,1] = guess[1];
        pi[3,2] = (1 - slip[1]);
        pi[4,1] = guess[1];
        pi[4,2] = (1 - slip[1]);
      }
      model {
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        slip[1] ~ beta(5, 25);
        guess[1] ~ beta(5, 25);
      
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
      stan_code(dtmr_spec)
    Output
      data {
        int<lower=1> I;                      // number of items
        int<lower=1> R;                      // number of respondents
        int<lower=1> N;                      // number of observations
        int<lower=1> C;                      // number of classes
        array[N] int<lower=1,upper=I> ii;    // item for observation n
        array[N] int<lower=1,upper=R> rr;    // respondent for observation n
        array[N] int<lower=0,upper=1> y;     // score for observation n
        array[R] int<lower=1,upper=N> start; // starting row for respondent R
        array[R] int<lower=1,upper=I> num;   // number items for respondent R
        int<lower=1> A;                      // number of attributes
      }
      parameters {
        simplex[C] Vc;
      
        ////////////////////////////////// attribute parameters
        array[A] real<lower=0,upper=1> slip;
        array[A] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = guess[1];
        pi[1,2] = (1 - slip[1]);
        pi[1,3] = guess[1];
        pi[1,4] = guess[1];
        pi[1,5] = guess[1];
        pi[1,6] = (1 - slip[1]);
        pi[1,7] = (1 - slip[1]);
        pi[1,8] = (1 - slip[1]);
        pi[1,9] = guess[1];
        pi[1,10] = guess[1];
        pi[1,11] = guess[1];
        pi[1,12] = (1 - slip[1]);
        pi[1,13] = (1 - slip[1]);
        pi[1,14] = (1 - slip[1]);
        pi[1,15] = guess[1];
        pi[1,16] = (1 - slip[1]);
        pi[2,1] = guess[3];
        pi[2,2] = guess[3];
        pi[2,3] = guess[3];
        pi[2,4] = (1 - slip[3]);
        pi[2,5] = guess[3];
        pi[2,6] = guess[3];
        pi[2,7] = (1 - slip[3]);
        pi[2,8] = guess[3];
        pi[2,9] = (1 - slip[3]);
        pi[2,10] = guess[3];
        pi[2,11] = (1 - slip[3]);
        pi[2,12] = (1 - slip[3]);
        pi[2,13] = guess[3];
        pi[2,14] = (1 - slip[3]);
        pi[2,15] = (1 - slip[3]);
        pi[2,16] = (1 - slip[3]);
        pi[3,1] = guess[2];
        pi[3,2] = guess[2];
        pi[3,3] = (1 - slip[2]);
        pi[3,4] = guess[2];
        pi[3,5] = guess[2];
        pi[3,6] = (1 - slip[2]);
        pi[3,7] = guess[2];
        pi[3,8] = guess[2];
        pi[3,9] = (1 - slip[2]);
        pi[3,10] = (1 - slip[2]);
        pi[3,11] = guess[2];
        pi[3,12] = (1 - slip[2]);
        pi[3,13] = (1 - slip[2]);
        pi[3,14] = guess[2];
        pi[3,15] = (1 - slip[2]);
        pi[3,16] = (1 - slip[2]);
        pi[4,1] = guess[1];
        pi[4,2] = (1 - slip[1]);
        pi[4,3] = guess[1];
        pi[4,4] = guess[1];
        pi[4,5] = guess[1];
        pi[4,6] = (1 - slip[1]);
        pi[4,7] = (1 - slip[1]);
        pi[4,8] = (1 - slip[1]);
        pi[4,9] = guess[1];
        pi[4,10] = guess[1];
        pi[4,11] = guess[1];
        pi[4,12] = (1 - slip[1]);
        pi[4,13] = (1 - slip[1]);
        pi[4,14] = (1 - slip[1]);
        pi[4,15] = guess[1];
        pi[4,16] = (1 - slip[1]);
        pi[5,1] = guess[1];
        pi[5,2] = (1 - slip[1]);
        pi[5,3] = guess[1];
        pi[5,4] = guess[1];
        pi[5,5] = guess[1];
        pi[5,6] = (1 - slip[1]);
        pi[5,7] = (1 - slip[1]);
        pi[5,8] = (1 - slip[1]);
        pi[5,9] = guess[1];
        pi[5,10] = guess[1];
        pi[5,11] = guess[1];
        pi[5,12] = (1 - slip[1]);
        pi[5,13] = (1 - slip[1]);
        pi[5,14] = (1 - slip[1]);
        pi[5,15] = guess[1];
        pi[5,16] = (1 - slip[1]);
        pi[6,1] = guess[2];
        pi[6,2] = guess[2];
        pi[6,3] = (1 - slip[2]);
        pi[6,4] = guess[2];
        pi[6,5] = guess[2];
        pi[6,6] = (1 - slip[2]);
        pi[6,7] = guess[2];
        pi[6,8] = guess[2];
        pi[6,9] = (1 - slip[2]);
        pi[6,10] = (1 - slip[2]);
        pi[6,11] = guess[2];
        pi[6,12] = (1 - slip[2]);
        pi[6,13] = (1 - slip[2]);
        pi[6,14] = guess[2];
        pi[6,15] = (1 - slip[2]);
        pi[6,16] = (1 - slip[2]);
        pi[7,1] = guess[1];
        pi[7,2] = (1 - slip[1]);
        pi[7,3] = guess[1];
        pi[7,4] = guess[1];
        pi[7,5] = guess[1];
        pi[7,6] = (1 - slip[1]);
        pi[7,7] = (1 - slip[1]);
        pi[7,8] = (1 - slip[1]);
        pi[7,9] = guess[1];
        pi[7,10] = guess[1];
        pi[7,11] = guess[1];
        pi[7,12] = (1 - slip[1]);
        pi[7,13] = (1 - slip[1]);
        pi[7,14] = (1 - slip[1]);
        pi[7,15] = guess[1];
        pi[7,16] = (1 - slip[1]);
        pi[8,1] = guess[3];
        pi[8,2] = guess[3];
        pi[8,3] = guess[3];
        pi[8,4] = (1 - slip[3]);
        pi[8,5] = guess[3];
        pi[8,6] = guess[3];
        pi[8,7] = (1 - slip[3]);
        pi[8,8] = guess[3];
        pi[8,9] = (1 - slip[3]);
        pi[8,10] = guess[3];
        pi[8,11] = (1 - slip[3]);
        pi[8,12] = (1 - slip[3]);
        pi[8,13] = guess[3];
        pi[8,14] = (1 - slip[3]);
        pi[8,15] = (1 - slip[3]);
        pi[8,16] = (1 - slip[3]);
        pi[9,1] = guess[3];
        pi[9,2] = guess[3];
        pi[9,3] = guess[3];
        pi[9,4] = (1 - slip[3]);
        pi[9,5] = guess[3];
        pi[9,6] = guess[3];
        pi[9,7] = (1 - slip[3]);
        pi[9,8] = guess[3];
        pi[9,9] = (1 - slip[3]);
        pi[9,10] = guess[3];
        pi[9,11] = (1 - slip[3]);
        pi[9,12] = (1 - slip[3]);
        pi[9,13] = guess[3];
        pi[9,14] = (1 - slip[3]);
        pi[9,15] = (1 - slip[3]);
        pi[9,16] = (1 - slip[3]);
        pi[10,1] = guess[3];
        pi[10,2] = guess[3];
        pi[10,3] = guess[3];
        pi[10,4] = (1 - slip[3]);
        pi[10,5] = guess[3];
        pi[10,6] = guess[3];
        pi[10,7] = (1 - slip[3]);
        pi[10,8] = guess[3];
        pi[10,9] = (1 - slip[3]);
        pi[10,10] = guess[3];
        pi[10,11] = (1 - slip[3]);
        pi[10,12] = (1 - slip[3]);
        pi[10,13] = guess[3];
        pi[10,14] = (1 - slip[3]);
        pi[10,15] = (1 - slip[3]);
        pi[10,16] = (1 - slip[3]);
        pi[11,1] = guess[3];
        pi[11,2] = guess[3];
        pi[11,3] = guess[3];
        pi[11,4] = (1 - slip[3]);
        pi[11,5] = guess[3];
        pi[11,6] = guess[3];
        pi[11,7] = (1 - slip[3]);
        pi[11,8] = guess[3];
        pi[11,9] = (1 - slip[3]);
        pi[11,10] = guess[3];
        pi[11,11] = (1 - slip[3]);
        pi[11,12] = (1 - slip[3]);
        pi[11,13] = guess[3];
        pi[11,14] = (1 - slip[3]);
        pi[11,15] = (1 - slip[3]);
        pi[11,16] = (1 - slip[3]);
        pi[12,1] = guess[1];
        pi[12,2] = (1 - slip[1]);
        pi[12,3] = guess[1];
        pi[12,4] = guess[1];
        pi[12,5] = guess[1];
        pi[12,6] = (1 - slip[1]);
        pi[12,7] = (1 - slip[1]);
        pi[12,8] = (1 - slip[1]);
        pi[12,9] = guess[1];
        pi[12,10] = guess[1];
        pi[12,11] = guess[1];
        pi[12,12] = (1 - slip[1]);
        pi[12,13] = (1 - slip[1]);
        pi[12,14] = (1 - slip[1]);
        pi[12,15] = guess[1];
        pi[12,16] = (1 - slip[1]);
        pi[13,1] = guess[4];
        pi[13,2] = guess[4];
        pi[13,3] = guess[4];
        pi[13,4] = guess[4];
        pi[13,5] = (1 - slip[4]);
        pi[13,6] = guess[4];
        pi[13,7] = guess[4];
        pi[13,8] = (1 - slip[4]);
        pi[13,9] = guess[4];
        pi[13,10] = (1 - slip[4]);
        pi[13,11] = (1 - slip[4]);
        pi[13,12] = guess[4];
        pi[13,13] = (1 - slip[4]);
        pi[13,14] = (1 - slip[4]);
        pi[13,15] = (1 - slip[4]);
        pi[13,16] = (1 - slip[4]);
        pi[14,1] = guess[1]*guess[4];
        pi[14,2] = (1 - slip[1])*guess[4];
        pi[14,3] = guess[1]*guess[4];
        pi[14,4] = guess[1]*guess[4];
        pi[14,5] = guess[1]*(1 - slip[4]);
        pi[14,6] = (1 - slip[1])*guess[4];
        pi[14,7] = (1 - slip[1])*guess[4];
        pi[14,8] = (1 - slip[1])*(1 - slip[4]);
        pi[14,9] = guess[1]*guess[4];
        pi[14,10] = guess[1]*(1 - slip[4]);
        pi[14,11] = guess[1]*(1 - slip[4]);
        pi[14,12] = (1 - slip[1])*guess[4];
        pi[14,13] = (1 - slip[1])*(1 - slip[4]);
        pi[14,14] = (1 - slip[1])*(1 - slip[4]);
        pi[14,15] = guess[1]*(1 - slip[4]);
        pi[14,16] = (1 - slip[1])*(1 - slip[4]);
        pi[15,1] = guess[1]*guess[4];
        pi[15,2] = (1 - slip[1])*guess[4];
        pi[15,3] = guess[1]*guess[4];
        pi[15,4] = guess[1]*guess[4];
        pi[15,5] = guess[1]*(1 - slip[4]);
        pi[15,6] = (1 - slip[1])*guess[4];
        pi[15,7] = (1 - slip[1])*guess[4];
        pi[15,8] = (1 - slip[1])*(1 - slip[4]);
        pi[15,9] = guess[1]*guess[4];
        pi[15,10] = guess[1]*(1 - slip[4]);
        pi[15,11] = guess[1]*(1 - slip[4]);
        pi[15,12] = (1 - slip[1])*guess[4];
        pi[15,13] = (1 - slip[1])*(1 - slip[4]);
        pi[15,14] = (1 - slip[1])*(1 - slip[4]);
        pi[15,15] = guess[1]*(1 - slip[4]);
        pi[15,16] = (1 - slip[1])*(1 - slip[4]);
        pi[16,1] = guess[1];
        pi[16,2] = (1 - slip[1]);
        pi[16,3] = guess[1];
        pi[16,4] = guess[1];
        pi[16,5] = guess[1];
        pi[16,6] = (1 - slip[1]);
        pi[16,7] = (1 - slip[1]);
        pi[16,8] = (1 - slip[1]);
        pi[16,9] = guess[1];
        pi[16,10] = guess[1];
        pi[16,11] = guess[1];
        pi[16,12] = (1 - slip[1]);
        pi[16,13] = (1 - slip[1]);
        pi[16,14] = (1 - slip[1]);
        pi[16,15] = guess[1];
        pi[16,16] = (1 - slip[1]);
        pi[17,1] = guess[1];
        pi[17,2] = (1 - slip[1]);
        pi[17,3] = guess[1];
        pi[17,4] = guess[1];
        pi[17,5] = guess[1];
        pi[17,6] = (1 - slip[1]);
        pi[17,7] = (1 - slip[1]);
        pi[17,8] = (1 - slip[1]);
        pi[17,9] = guess[1];
        pi[17,10] = guess[1];
        pi[17,11] = guess[1];
        pi[17,12] = (1 - slip[1]);
        pi[17,13] = (1 - slip[1]);
        pi[17,14] = (1 - slip[1]);
        pi[17,15] = guess[1];
        pi[17,16] = (1 - slip[1]);
        pi[18,1] = guess[2]*guess[4];
        pi[18,2] = guess[2]*guess[4];
        pi[18,3] = (1 - slip[2])*guess[4];
        pi[18,4] = guess[2]*guess[4];
        pi[18,5] = guess[2]*(1 - slip[4]);
        pi[18,6] = (1 - slip[2])*guess[4];
        pi[18,7] = guess[2]*guess[4];
        pi[18,8] = guess[2]*(1 - slip[4]);
        pi[18,9] = (1 - slip[2])*guess[4];
        pi[18,10] = (1 - slip[2])*(1 - slip[4]);
        pi[18,11] = guess[2]*(1 - slip[4]);
        pi[18,12] = (1 - slip[2])*guess[4];
        pi[18,13] = (1 - slip[2])*(1 - slip[4]);
        pi[18,14] = guess[2]*(1 - slip[4]);
        pi[18,15] = (1 - slip[2])*(1 - slip[4]);
        pi[18,16] = (1 - slip[2])*(1 - slip[4]);
        pi[19,1] = guess[1]*guess[2];
        pi[19,2] = (1 - slip[1])*guess[2];
        pi[19,3] = guess[1]*(1 - slip[2]);
        pi[19,4] = guess[1]*guess[2];
        pi[19,5] = guess[1]*guess[2];
        pi[19,6] = (1 - slip[1])*(1 - slip[2]);
        pi[19,7] = (1 - slip[1])*guess[2];
        pi[19,8] = (1 - slip[1])*guess[2];
        pi[19,9] = guess[1]*(1 - slip[2]);
        pi[19,10] = guess[1]*(1 - slip[2]);
        pi[19,11] = guess[1]*guess[2];
        pi[19,12] = (1 - slip[1])*(1 - slip[2]);
        pi[19,13] = (1 - slip[1])*(1 - slip[2]);
        pi[19,14] = (1 - slip[1])*guess[2];
        pi[19,15] = guess[1]*(1 - slip[2]);
        pi[19,16] = (1 - slip[1])*(1 - slip[2]);
        pi[20,1] = guess[2]*guess[4];
        pi[20,2] = guess[2]*guess[4];
        pi[20,3] = (1 - slip[2])*guess[4];
        pi[20,4] = guess[2]*guess[4];
        pi[20,5] = guess[2]*(1 - slip[4]);
        pi[20,6] = (1 - slip[2])*guess[4];
        pi[20,7] = guess[2]*guess[4];
        pi[20,8] = guess[2]*(1 - slip[4]);
        pi[20,9] = (1 - slip[2])*guess[4];
        pi[20,10] = (1 - slip[2])*(1 - slip[4]);
        pi[20,11] = guess[2]*(1 - slip[4]);
        pi[20,12] = (1 - slip[2])*guess[4];
        pi[20,13] = (1 - slip[2])*(1 - slip[4]);
        pi[20,14] = guess[2]*(1 - slip[4]);
        pi[20,15] = (1 - slip[2])*(1 - slip[4]);
        pi[20,16] = (1 - slip[2])*(1 - slip[4]);
        pi[21,1] = guess[2];
        pi[21,2] = guess[2];
        pi[21,3] = (1 - slip[2]);
        pi[21,4] = guess[2];
        pi[21,5] = guess[2];
        pi[21,6] = (1 - slip[2]);
        pi[21,7] = guess[2];
        pi[21,8] = guess[2];
        pi[21,9] = (1 - slip[2]);
        pi[21,10] = (1 - slip[2]);
        pi[21,11] = guess[2];
        pi[21,12] = (1 - slip[2]);
        pi[21,13] = (1 - slip[2]);
        pi[21,14] = guess[2];
        pi[21,15] = (1 - slip[2]);
        pi[21,16] = (1 - slip[2]);
        pi[22,1] = guess[2];
        pi[22,2] = guess[2];
        pi[22,3] = (1 - slip[2]);
        pi[22,4] = guess[2];
        pi[22,5] = guess[2];
        pi[22,6] = (1 - slip[2]);
        pi[22,7] = guess[2];
        pi[22,8] = guess[2];
        pi[22,9] = (1 - slip[2]);
        pi[22,10] = (1 - slip[2]);
        pi[22,11] = guess[2];
        pi[22,12] = (1 - slip[2]);
        pi[22,13] = (1 - slip[2]);
        pi[22,14] = guess[2];
        pi[22,15] = (1 - slip[2]);
        pi[22,16] = (1 - slip[2]);
        pi[23,1] = guess[1];
        pi[23,2] = (1 - slip[1]);
        pi[23,3] = guess[1];
        pi[23,4] = guess[1];
        pi[23,5] = guess[1];
        pi[23,6] = (1 - slip[1]);
        pi[23,7] = (1 - slip[1]);
        pi[23,8] = (1 - slip[1]);
        pi[23,9] = guess[1];
        pi[23,10] = guess[1];
        pi[23,11] = guess[1];
        pi[23,12] = (1 - slip[1]);
        pi[23,13] = (1 - slip[1]);
        pi[23,14] = (1 - slip[1]);
        pi[23,15] = guess[1];
        pi[23,16] = (1 - slip[1]);
        pi[24,1] = guess[1]*guess[2];
        pi[24,2] = (1 - slip[1])*guess[2];
        pi[24,3] = guess[1]*(1 - slip[2]);
        pi[24,4] = guess[1]*guess[2];
        pi[24,5] = guess[1]*guess[2];
        pi[24,6] = (1 - slip[1])*(1 - slip[2]);
        pi[24,7] = (1 - slip[1])*guess[2];
        pi[24,8] = (1 - slip[1])*guess[2];
        pi[24,9] = guess[1]*(1 - slip[2]);
        pi[24,10] = guess[1]*(1 - slip[2]);
        pi[24,11] = guess[1]*guess[2];
        pi[24,12] = (1 - slip[1])*(1 - slip[2]);
        pi[24,13] = (1 - slip[1])*(1 - slip[2]);
        pi[24,14] = (1 - slip[1])*guess[2];
        pi[24,15] = guess[1]*(1 - slip[2]);
        pi[24,16] = (1 - slip[1])*(1 - slip[2]);
        pi[25,1] = guess[1]*guess[2];
        pi[25,2] = (1 - slip[1])*guess[2];
        pi[25,3] = guess[1]*(1 - slip[2]);
        pi[25,4] = guess[1]*guess[2];
        pi[25,5] = guess[1]*guess[2];
        pi[25,6] = (1 - slip[1])*(1 - slip[2]);
        pi[25,7] = (1 - slip[1])*guess[2];
        pi[25,8] = (1 - slip[1])*guess[2];
        pi[25,9] = guess[1]*(1 - slip[2]);
        pi[25,10] = guess[1]*(1 - slip[2]);
        pi[25,11] = guess[1]*guess[2];
        pi[25,12] = (1 - slip[1])*(1 - slip[2]);
        pi[25,13] = (1 - slip[1])*(1 - slip[2]);
        pi[25,14] = (1 - slip[1])*guess[2];
        pi[25,15] = guess[1]*(1 - slip[2]);
        pi[25,16] = (1 - slip[1])*(1 - slip[2]);
        pi[26,1] = guess[1];
        pi[26,2] = (1 - slip[1]);
        pi[26,3] = guess[1];
        pi[26,4] = guess[1];
        pi[26,5] = guess[1];
        pi[26,6] = (1 - slip[1]);
        pi[26,7] = (1 - slip[1]);
        pi[26,8] = (1 - slip[1]);
        pi[26,9] = guess[1];
        pi[26,10] = guess[1];
        pi[26,11] = guess[1];
        pi[26,12] = (1 - slip[1]);
        pi[26,13] = (1 - slip[1]);
        pi[26,14] = (1 - slip[1]);
        pi[26,15] = guess[1];
        pi[26,16] = (1 - slip[1]);
        pi[27,1] = guess[1]*guess[2];
        pi[27,2] = (1 - slip[1])*guess[2];
        pi[27,3] = guess[1]*(1 - slip[2]);
        pi[27,4] = guess[1]*guess[2];
        pi[27,5] = guess[1]*guess[2];
        pi[27,6] = (1 - slip[1])*(1 - slip[2]);
        pi[27,7] = (1 - slip[1])*guess[2];
        pi[27,8] = (1 - slip[1])*guess[2];
        pi[27,9] = guess[1]*(1 - slip[2]);
        pi[27,10] = guess[1]*(1 - slip[2]);
        pi[27,11] = guess[1]*guess[2];
        pi[27,12] = (1 - slip[1])*(1 - slip[2]);
        pi[27,13] = (1 - slip[1])*(1 - slip[2]);
        pi[27,14] = (1 - slip[1])*guess[2];
        pi[27,15] = guess[1]*(1 - slip[2]);
        pi[27,16] = (1 - slip[1])*(1 - slip[2]);
      }
      model {
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        slip[1] ~ beta(5, 25);
        guess[1] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
      
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
      stan_code(ecpe_spec2)
    Output
      data {
        int<lower=1> I;                      // number of items
        int<lower=1> R;                      // number of respondents
        int<lower=1> N;                      // number of observations
        int<lower=1> C;                      // number of classes
        array[N] int<lower=1,upper=I> ii;    // item for observation n
        array[N] int<lower=1,upper=R> rr;    // respondent for observation n
        array[N] int<lower=0,upper=1> y;     // score for observation n
        array[R] int<lower=1,upper=N> start; // starting row for respondent R
        array[R] int<lower=1,upper=I> num;   // number items for respondent R
        int<lower=1> A;                      // number of attributes
        matrix[C,A] Alpha;                   // attribute pattern for class
      }
      parameters {
        array[A] real<lower=0,upper=1> eta;
      
        ////////////////////////////////// attribute parameters
        array[A] real<lower=0,upper=1> slip;
        array[A] real<lower=0,upper=1> guess;
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
        pi[1,1] = guess[1]*guess[2];
        pi[1,2] = (1 - slip[1])*guess[2];
        pi[1,3] = guess[1]*(1 - slip[2]);
        pi[1,4] = guess[1]*guess[2];
        pi[1,5] = (1 - slip[1])*(1 - slip[2]);
        pi[1,6] = (1 - slip[1])*guess[2];
        pi[1,7] = guess[1]*(1 - slip[2]);
        pi[1,8] = (1 - slip[1])*(1 - slip[2]);
        pi[2,1] = guess[2];
        pi[2,2] = guess[2];
        pi[2,3] = (1 - slip[2]);
        pi[2,4] = guess[2];
        pi[2,5] = (1 - slip[2]);
        pi[2,6] = guess[2];
        pi[2,7] = (1 - slip[2]);
        pi[2,8] = (1 - slip[2]);
        pi[3,1] = guess[1]*guess[3];
        pi[3,2] = (1 - slip[1])*guess[3];
        pi[3,3] = guess[1]*guess[3];
        pi[3,4] = guess[1]*(1 - slip[3]);
        pi[3,5] = (1 - slip[1])*guess[3];
        pi[3,6] = (1 - slip[1])*(1 - slip[3]);
        pi[3,7] = guess[1]*(1 - slip[3]);
        pi[3,8] = (1 - slip[1])*(1 - slip[3]);
        pi[4,1] = guess[3];
        pi[4,2] = guess[3];
        pi[4,3] = guess[3];
        pi[4,4] = (1 - slip[3]);
        pi[4,5] = guess[3];
        pi[4,6] = (1 - slip[3]);
        pi[4,7] = (1 - slip[3]);
        pi[4,8] = (1 - slip[3]);
        pi[5,1] = guess[3];
        pi[5,2] = guess[3];
        pi[5,3] = guess[3];
        pi[5,4] = (1 - slip[3]);
        pi[5,5] = guess[3];
        pi[5,6] = (1 - slip[3]);
        pi[5,7] = (1 - slip[3]);
        pi[5,8] = (1 - slip[3]);
        pi[6,1] = guess[3];
        pi[6,2] = guess[3];
        pi[6,3] = guess[3];
        pi[6,4] = (1 - slip[3]);
        pi[6,5] = guess[3];
        pi[6,6] = (1 - slip[3]);
        pi[6,7] = (1 - slip[3]);
        pi[6,8] = (1 - slip[3]);
        pi[7,1] = guess[1]*guess[3];
        pi[7,2] = (1 - slip[1])*guess[3];
        pi[7,3] = guess[1]*guess[3];
        pi[7,4] = guess[1]*(1 - slip[3]);
        pi[7,5] = (1 - slip[1])*guess[3];
        pi[7,6] = (1 - slip[1])*(1 - slip[3]);
        pi[7,7] = guess[1]*(1 - slip[3]);
        pi[7,8] = (1 - slip[1])*(1 - slip[3]);
        pi[8,1] = guess[2];
        pi[8,2] = guess[2];
        pi[8,3] = (1 - slip[2]);
        pi[8,4] = guess[2];
        pi[8,5] = (1 - slip[2]);
        pi[8,6] = guess[2];
        pi[8,7] = (1 - slip[2]);
        pi[8,8] = (1 - slip[2]);
        pi[9,1] = guess[3];
        pi[9,2] = guess[3];
        pi[9,3] = guess[3];
        pi[9,4] = (1 - slip[3]);
        pi[9,5] = guess[3];
        pi[9,6] = (1 - slip[3]);
        pi[9,7] = (1 - slip[3]);
        pi[9,8] = (1 - slip[3]);
        pi[10,1] = guess[1];
        pi[10,2] = (1 - slip[1]);
        pi[10,3] = guess[1];
        pi[10,4] = guess[1];
        pi[10,5] = (1 - slip[1]);
        pi[10,6] = (1 - slip[1]);
        pi[10,7] = guess[1];
        pi[10,8] = (1 - slip[1]);
        pi[11,1] = guess[1]*guess[3];
        pi[11,2] = (1 - slip[1])*guess[3];
        pi[11,3] = guess[1]*guess[3];
        pi[11,4] = guess[1]*(1 - slip[3]);
        pi[11,5] = (1 - slip[1])*guess[3];
        pi[11,6] = (1 - slip[1])*(1 - slip[3]);
        pi[11,7] = guess[1]*(1 - slip[3]);
        pi[11,8] = (1 - slip[1])*(1 - slip[3]);
        pi[12,1] = guess[1]*guess[3];
        pi[12,2] = (1 - slip[1])*guess[3];
        pi[12,3] = guess[1]*guess[3];
        pi[12,4] = guess[1]*(1 - slip[3]);
        pi[12,5] = (1 - slip[1])*guess[3];
        pi[12,6] = (1 - slip[1])*(1 - slip[3]);
        pi[12,7] = guess[1]*(1 - slip[3]);
        pi[12,8] = (1 - slip[1])*(1 - slip[3]);
        pi[13,1] = guess[1];
        pi[13,2] = (1 - slip[1]);
        pi[13,3] = guess[1];
        pi[13,4] = guess[1];
        pi[13,5] = (1 - slip[1]);
        pi[13,6] = (1 - slip[1]);
        pi[13,7] = guess[1];
        pi[13,8] = (1 - slip[1]);
        pi[14,1] = guess[1];
        pi[14,2] = (1 - slip[1]);
        pi[14,3] = guess[1];
        pi[14,4] = guess[1];
        pi[14,5] = (1 - slip[1]);
        pi[14,6] = (1 - slip[1]);
        pi[14,7] = guess[1];
        pi[14,8] = (1 - slip[1]);
        pi[15,1] = guess[3];
        pi[15,2] = guess[3];
        pi[15,3] = guess[3];
        pi[15,4] = (1 - slip[3]);
        pi[15,5] = guess[3];
        pi[15,6] = (1 - slip[3]);
        pi[15,7] = (1 - slip[3]);
        pi[15,8] = (1 - slip[3]);
        pi[16,1] = guess[1]*guess[3];
        pi[16,2] = (1 - slip[1])*guess[3];
        pi[16,3] = guess[1]*guess[3];
        pi[16,4] = guess[1]*(1 - slip[3]);
        pi[16,5] = (1 - slip[1])*guess[3];
        pi[16,6] = (1 - slip[1])*(1 - slip[3]);
        pi[16,7] = guess[1]*(1 - slip[3]);
        pi[16,8] = (1 - slip[1])*(1 - slip[3]);
        pi[17,1] = guess[2]*guess[3];
        pi[17,2] = guess[2]*guess[3];
        pi[17,3] = (1 - slip[2])*guess[3];
        pi[17,4] = guess[2]*(1 - slip[3]);
        pi[17,5] = (1 - slip[2])*guess[3];
        pi[17,6] = guess[2]*(1 - slip[3]);
        pi[17,7] = (1 - slip[2])*(1 - slip[3]);
        pi[17,8] = (1 - slip[2])*(1 - slip[3]);
        pi[18,1] = guess[3];
        pi[18,2] = guess[3];
        pi[18,3] = guess[3];
        pi[18,4] = (1 - slip[3]);
        pi[18,5] = guess[3];
        pi[18,6] = (1 - slip[3]);
        pi[18,7] = (1 - slip[3]);
        pi[18,8] = (1 - slip[3]);
        pi[19,1] = guess[3];
        pi[19,2] = guess[3];
        pi[19,3] = guess[3];
        pi[19,4] = (1 - slip[3]);
        pi[19,5] = guess[3];
        pi[19,6] = (1 - slip[3]);
        pi[19,7] = (1 - slip[3]);
        pi[19,8] = (1 - slip[3]);
        pi[20,1] = guess[1]*guess[3];
        pi[20,2] = (1 - slip[1])*guess[3];
        pi[20,3] = guess[1]*guess[3];
        pi[20,4] = guess[1]*(1 - slip[3]);
        pi[20,5] = (1 - slip[1])*guess[3];
        pi[20,6] = (1 - slip[1])*(1 - slip[3]);
        pi[20,7] = guess[1]*(1 - slip[3]);
        pi[20,8] = (1 - slip[1])*(1 - slip[3]);
        pi[21,1] = guess[1]*guess[3];
        pi[21,2] = (1 - slip[1])*guess[3];
        pi[21,3] = guess[1]*guess[3];
        pi[21,4] = guess[1]*(1 - slip[3]);
        pi[21,5] = (1 - slip[1])*guess[3];
        pi[21,6] = (1 - slip[1])*(1 - slip[3]);
        pi[21,7] = guess[1]*(1 - slip[3]);
        pi[21,8] = (1 - slip[1])*(1 - slip[3]);
        pi[22,1] = guess[3];
        pi[22,2] = guess[3];
        pi[22,3] = guess[3];
        pi[22,4] = (1 - slip[3]);
        pi[22,5] = guess[3];
        pi[22,6] = (1 - slip[3]);
        pi[22,7] = (1 - slip[3]);
        pi[22,8] = (1 - slip[3]);
        pi[23,1] = guess[2];
        pi[23,2] = guess[2];
        pi[23,3] = (1 - slip[2]);
        pi[23,4] = guess[2];
        pi[23,5] = (1 - slip[2]);
        pi[23,6] = guess[2];
        pi[23,7] = (1 - slip[2]);
        pi[23,8] = (1 - slip[2]);
        pi[24,1] = guess[2];
        pi[24,2] = guess[2];
        pi[24,3] = (1 - slip[2]);
        pi[24,4] = guess[2];
        pi[24,5] = (1 - slip[2]);
        pi[24,6] = guess[2];
        pi[24,7] = (1 - slip[2]);
        pi[24,8] = (1 - slip[2]);
        pi[25,1] = guess[1];
        pi[25,2] = (1 - slip[1]);
        pi[25,3] = guess[1];
        pi[25,4] = guess[1];
        pi[25,5] = (1 - slip[1]);
        pi[25,6] = (1 - slip[1]);
        pi[25,7] = guess[1];
        pi[25,8] = (1 - slip[1]);
        pi[26,1] = guess[3];
        pi[26,2] = guess[3];
        pi[26,3] = guess[3];
        pi[26,4] = (1 - slip[3]);
        pi[26,5] = guess[3];
        pi[26,6] = (1 - slip[3]);
        pi[26,7] = (1 - slip[3]);
        pi[26,8] = (1 - slip[3]);
        pi[27,1] = guess[1];
        pi[27,2] = (1 - slip[1]);
        pi[27,3] = guess[1];
        pi[27,4] = guess[1];
        pi[27,5] = (1 - slip[1]);
        pi[27,6] = (1 - slip[1]);
        pi[27,7] = guess[1];
        pi[27,8] = (1 - slip[1]);
        pi[28,1] = guess[3];
        pi[28,2] = guess[3];
        pi[28,3] = guess[3];
        pi[28,4] = (1 - slip[3]);
        pi[28,5] = guess[3];
        pi[28,6] = (1 - slip[3]);
        pi[28,7] = (1 - slip[3]);
        pi[28,8] = (1 - slip[3]);
      }
      model {
        ////////////////////////////////// priors
        eta[1] ~ beta(1, 1);
        eta[2] ~ beta(1, 1);
        eta[3] ~ beta(1, 1);
        slip[1] ~ beta(5, 25);
        guess[1] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
      
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
      stan_code(dtmr_spec2)
    Output
      data {
        int<lower=1> I;                      // number of items
        int<lower=1> R;                      // number of respondents
        int<lower=1> N;                      // number of observations
        int<lower=1> C;                      // number of classes
        array[N] int<lower=1,upper=I> ii;    // item for observation n
        array[N] int<lower=1,upper=R> rr;    // respondent for observation n
        array[N] int<lower=0,upper=1> y;     // score for observation n
        array[R] int<lower=1,upper=N> start; // starting row for respondent R
        array[R] int<lower=1,upper=I> num;   // number items for respondent R
        int<lower=1> A;                      // number of attributes
      }
      parameters {
        simplex[C] Vc;
      
        ////////////////////////////////// attribute parameters
        array[A] real<lower=0,upper=1> slip;
        array[A] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = guess[1];
        pi[1,2] = (1 - slip[1]);
        pi[1,3] = guess[1];
        pi[1,4] = guess[1];
        pi[1,5] = guess[1];
        pi[1,6] = (1 - slip[1]);
        pi[1,7] = (1 - slip[1]);
        pi[1,8] = (1 - slip[1]);
        pi[1,9] = guess[1];
        pi[1,10] = guess[1];
        pi[1,11] = guess[1];
        pi[1,12] = (1 - slip[1]);
        pi[1,13] = (1 - slip[1]);
        pi[1,14] = (1 - slip[1]);
        pi[1,15] = guess[1];
        pi[1,16] = (1 - slip[1]);
        pi[2,1] = guess[3];
        pi[2,2] = guess[3];
        pi[2,3] = guess[3];
        pi[2,4] = (1 - slip[3]);
        pi[2,5] = guess[3];
        pi[2,6] = guess[3];
        pi[2,7] = (1 - slip[3]);
        pi[2,8] = guess[3];
        pi[2,9] = (1 - slip[3]);
        pi[2,10] = guess[3];
        pi[2,11] = (1 - slip[3]);
        pi[2,12] = (1 - slip[3]);
        pi[2,13] = guess[3];
        pi[2,14] = (1 - slip[3]);
        pi[2,15] = (1 - slip[3]);
        pi[2,16] = (1 - slip[3]);
        pi[3,1] = guess[2];
        pi[3,2] = guess[2];
        pi[3,3] = (1 - slip[2]);
        pi[3,4] = guess[2];
        pi[3,5] = guess[2];
        pi[3,6] = (1 - slip[2]);
        pi[3,7] = guess[2];
        pi[3,8] = guess[2];
        pi[3,9] = (1 - slip[2]);
        pi[3,10] = (1 - slip[2]);
        pi[3,11] = guess[2];
        pi[3,12] = (1 - slip[2]);
        pi[3,13] = (1 - slip[2]);
        pi[3,14] = guess[2];
        pi[3,15] = (1 - slip[2]);
        pi[3,16] = (1 - slip[2]);
        pi[4,1] = guess[1];
        pi[4,2] = (1 - slip[1]);
        pi[4,3] = guess[1];
        pi[4,4] = guess[1];
        pi[4,5] = guess[1];
        pi[4,6] = (1 - slip[1]);
        pi[4,7] = (1 - slip[1]);
        pi[4,8] = (1 - slip[1]);
        pi[4,9] = guess[1];
        pi[4,10] = guess[1];
        pi[4,11] = guess[1];
        pi[4,12] = (1 - slip[1]);
        pi[4,13] = (1 - slip[1]);
        pi[4,14] = (1 - slip[1]);
        pi[4,15] = guess[1];
        pi[4,16] = (1 - slip[1]);
        pi[5,1] = guess[1];
        pi[5,2] = (1 - slip[1]);
        pi[5,3] = guess[1];
        pi[5,4] = guess[1];
        pi[5,5] = guess[1];
        pi[5,6] = (1 - slip[1]);
        pi[5,7] = (1 - slip[1]);
        pi[5,8] = (1 - slip[1]);
        pi[5,9] = guess[1];
        pi[5,10] = guess[1];
        pi[5,11] = guess[1];
        pi[5,12] = (1 - slip[1]);
        pi[5,13] = (1 - slip[1]);
        pi[5,14] = (1 - slip[1]);
        pi[5,15] = guess[1];
        pi[5,16] = (1 - slip[1]);
        pi[6,1] = guess[2];
        pi[6,2] = guess[2];
        pi[6,3] = (1 - slip[2]);
        pi[6,4] = guess[2];
        pi[6,5] = guess[2];
        pi[6,6] = (1 - slip[2]);
        pi[6,7] = guess[2];
        pi[6,8] = guess[2];
        pi[6,9] = (1 - slip[2]);
        pi[6,10] = (1 - slip[2]);
        pi[6,11] = guess[2];
        pi[6,12] = (1 - slip[2]);
        pi[6,13] = (1 - slip[2]);
        pi[6,14] = guess[2];
        pi[6,15] = (1 - slip[2]);
        pi[6,16] = (1 - slip[2]);
        pi[7,1] = guess[1];
        pi[7,2] = (1 - slip[1]);
        pi[7,3] = guess[1];
        pi[7,4] = guess[1];
        pi[7,5] = guess[1];
        pi[7,6] = (1 - slip[1]);
        pi[7,7] = (1 - slip[1]);
        pi[7,8] = (1 - slip[1]);
        pi[7,9] = guess[1];
        pi[7,10] = guess[1];
        pi[7,11] = guess[1];
        pi[7,12] = (1 - slip[1]);
        pi[7,13] = (1 - slip[1]);
        pi[7,14] = (1 - slip[1]);
        pi[7,15] = guess[1];
        pi[7,16] = (1 - slip[1]);
        pi[8,1] = guess[3];
        pi[8,2] = guess[3];
        pi[8,3] = guess[3];
        pi[8,4] = (1 - slip[3]);
        pi[8,5] = guess[3];
        pi[8,6] = guess[3];
        pi[8,7] = (1 - slip[3]);
        pi[8,8] = guess[3];
        pi[8,9] = (1 - slip[3]);
        pi[8,10] = guess[3];
        pi[8,11] = (1 - slip[3]);
        pi[8,12] = (1 - slip[3]);
        pi[8,13] = guess[3];
        pi[8,14] = (1 - slip[3]);
        pi[8,15] = (1 - slip[3]);
        pi[8,16] = (1 - slip[3]);
        pi[9,1] = guess[3];
        pi[9,2] = guess[3];
        pi[9,3] = guess[3];
        pi[9,4] = (1 - slip[3]);
        pi[9,5] = guess[3];
        pi[9,6] = guess[3];
        pi[9,7] = (1 - slip[3]);
        pi[9,8] = guess[3];
        pi[9,9] = (1 - slip[3]);
        pi[9,10] = guess[3];
        pi[9,11] = (1 - slip[3]);
        pi[9,12] = (1 - slip[3]);
        pi[9,13] = guess[3];
        pi[9,14] = (1 - slip[3]);
        pi[9,15] = (1 - slip[3]);
        pi[9,16] = (1 - slip[3]);
        pi[10,1] = guess[3];
        pi[10,2] = guess[3];
        pi[10,3] = guess[3];
        pi[10,4] = (1 - slip[3]);
        pi[10,5] = guess[3];
        pi[10,6] = guess[3];
        pi[10,7] = (1 - slip[3]);
        pi[10,8] = guess[3];
        pi[10,9] = (1 - slip[3]);
        pi[10,10] = guess[3];
        pi[10,11] = (1 - slip[3]);
        pi[10,12] = (1 - slip[3]);
        pi[10,13] = guess[3];
        pi[10,14] = (1 - slip[3]);
        pi[10,15] = (1 - slip[3]);
        pi[10,16] = (1 - slip[3]);
        pi[11,1] = guess[3];
        pi[11,2] = guess[3];
        pi[11,3] = guess[3];
        pi[11,4] = (1 - slip[3]);
        pi[11,5] = guess[3];
        pi[11,6] = guess[3];
        pi[11,7] = (1 - slip[3]);
        pi[11,8] = guess[3];
        pi[11,9] = (1 - slip[3]);
        pi[11,10] = guess[3];
        pi[11,11] = (1 - slip[3]);
        pi[11,12] = (1 - slip[3]);
        pi[11,13] = guess[3];
        pi[11,14] = (1 - slip[3]);
        pi[11,15] = (1 - slip[3]);
        pi[11,16] = (1 - slip[3]);
        pi[12,1] = guess[1];
        pi[12,2] = (1 - slip[1]);
        pi[12,3] = guess[1];
        pi[12,4] = guess[1];
        pi[12,5] = guess[1];
        pi[12,6] = (1 - slip[1]);
        pi[12,7] = (1 - slip[1]);
        pi[12,8] = (1 - slip[1]);
        pi[12,9] = guess[1];
        pi[12,10] = guess[1];
        pi[12,11] = guess[1];
        pi[12,12] = (1 - slip[1]);
        pi[12,13] = (1 - slip[1]);
        pi[12,14] = (1 - slip[1]);
        pi[12,15] = guess[1];
        pi[12,16] = (1 - slip[1]);
        pi[13,1] = guess[4];
        pi[13,2] = guess[4];
        pi[13,3] = guess[4];
        pi[13,4] = guess[4];
        pi[13,5] = (1 - slip[4]);
        pi[13,6] = guess[4];
        pi[13,7] = guess[4];
        pi[13,8] = (1 - slip[4]);
        pi[13,9] = guess[4];
        pi[13,10] = (1 - slip[4]);
        pi[13,11] = (1 - slip[4]);
        pi[13,12] = guess[4];
        pi[13,13] = (1 - slip[4]);
        pi[13,14] = (1 - slip[4]);
        pi[13,15] = (1 - slip[4]);
        pi[13,16] = (1 - slip[4]);
        pi[14,1] = guess[1];
        pi[14,2] = (1 - slip[1]);
        pi[14,3] = guess[1];
        pi[14,4] = guess[1];
        pi[14,5] = guess[1];
        pi[14,6] = (1 - slip[1]);
        pi[14,7] = (1 - slip[1]);
        pi[14,8] = (1 - slip[1]);
        pi[14,9] = guess[1];
        pi[14,10] = guess[1];
        pi[14,11] = guess[1];
        pi[14,12] = (1 - slip[1]);
        pi[14,13] = (1 - slip[1]);
        pi[14,14] = (1 - slip[1]);
        pi[14,15] = guess[1];
        pi[14,16] = (1 - slip[1]);
        pi[15,1] = guess[1];
        pi[15,2] = (1 - slip[1]);
        pi[15,3] = guess[1];
        pi[15,4] = guess[1];
        pi[15,5] = guess[1];
        pi[15,6] = (1 - slip[1]);
        pi[15,7] = (1 - slip[1]);
        pi[15,8] = (1 - slip[1]);
        pi[15,9] = guess[1];
        pi[15,10] = guess[1];
        pi[15,11] = guess[1];
        pi[15,12] = (1 - slip[1]);
        pi[15,13] = (1 - slip[1]);
        pi[15,14] = (1 - slip[1]);
        pi[15,15] = guess[1];
        pi[15,16] = (1 - slip[1]);
        pi[16,1] = guess[2];
        pi[16,2] = guess[2];
        pi[16,3] = (1 - slip[2]);
        pi[16,4] = guess[2];
        pi[16,5] = guess[2];
        pi[16,6] = (1 - slip[2]);
        pi[16,7] = guess[2];
        pi[16,8] = guess[2];
        pi[16,9] = (1 - slip[2]);
        pi[16,10] = (1 - slip[2]);
        pi[16,11] = guess[2];
        pi[16,12] = (1 - slip[2]);
        pi[16,13] = (1 - slip[2]);
        pi[16,14] = guess[2];
        pi[16,15] = (1 - slip[2]);
        pi[16,16] = (1 - slip[2]);
        pi[17,1] = guess[2];
        pi[17,2] = guess[2];
        pi[17,3] = (1 - slip[2]);
        pi[17,4] = guess[2];
        pi[17,5] = guess[2];
        pi[17,6] = (1 - slip[2]);
        pi[17,7] = guess[2];
        pi[17,8] = guess[2];
        pi[17,9] = (1 - slip[2]);
        pi[17,10] = (1 - slip[2]);
        pi[17,11] = guess[2];
        pi[17,12] = (1 - slip[2]);
        pi[17,13] = (1 - slip[2]);
        pi[17,14] = guess[2];
        pi[17,15] = (1 - slip[2]);
        pi[17,16] = (1 - slip[2]);
        pi[18,1] = guess[1];
        pi[18,2] = (1 - slip[1]);
        pi[18,3] = guess[1];
        pi[18,4] = guess[1];
        pi[18,5] = guess[1];
        pi[18,6] = (1 - slip[1]);
        pi[18,7] = (1 - slip[1]);
        pi[18,8] = (1 - slip[1]);
        pi[18,9] = guess[1];
        pi[18,10] = guess[1];
        pi[18,11] = guess[1];
        pi[18,12] = (1 - slip[1]);
        pi[18,13] = (1 - slip[1]);
        pi[18,14] = (1 - slip[1]);
        pi[18,15] = guess[1];
        pi[18,16] = (1 - slip[1]);
        pi[19,1] = guess[1];
        pi[19,2] = (1 - slip[1]);
        pi[19,3] = guess[1];
        pi[19,4] = guess[1];
        pi[19,5] = guess[1];
        pi[19,6] = (1 - slip[1]);
        pi[19,7] = (1 - slip[1]);
        pi[19,8] = (1 - slip[1]);
        pi[19,9] = guess[1];
        pi[19,10] = guess[1];
        pi[19,11] = guess[1];
        pi[19,12] = (1 - slip[1]);
        pi[19,13] = (1 - slip[1]);
        pi[19,14] = (1 - slip[1]);
        pi[19,15] = guess[1];
        pi[19,16] = (1 - slip[1]);
      }
      model {
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        slip[1] ~ beta(5, 25);
        guess[1] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
      
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

# nida with hierarchy works

    Code
      stan_code(ecpe_nida_hdcm)
    Output
      data {
        int<lower=1> I;                      // number of items
        int<lower=1> R;                      // number of respondents
        int<lower=1> N;                      // number of observations
        int<lower=1> C;                      // number of classes
        array[N] int<lower=1,upper=I> ii;    // item for observation n
        array[N] int<lower=1,upper=R> rr;    // respondent for observation n
        array[N] int<lower=0,upper=1> y;     // score for observation n
        array[R] int<lower=1,upper=N> start; // starting row for respondent R
        array[R] int<lower=1,upper=I> num;   // number items for respondent R
        int<lower=1> A;                      // number of attributes
      }
      parameters {
        simplex[C] Vc;
      
        ////////////////////////////////// attribute parameters
        array[A] real<lower=0,upper=1> slip;
        array[A] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = guess[1]*guess[2];
        pi[1,2] = guess[1]*guess[2];
        pi[1,3] = guess[1]*(1 - slip[2]);
        pi[1,4] = (1 - slip[1])*(1 - slip[2]);
        pi[2,1] = guess[2];
        pi[2,2] = guess[2];
        pi[2,3] = (1 - slip[2]);
        pi[2,4] = (1 - slip[2]);
        pi[3,1] = guess[1]*guess[3];
        pi[3,2] = guess[1]*(1 - slip[3]);
        pi[3,3] = guess[1]*(1 - slip[3]);
        pi[3,4] = (1 - slip[1])*(1 - slip[3]);
        pi[4,1] = guess[3];
        pi[4,2] = (1 - slip[3]);
        pi[4,3] = (1 - slip[3]);
        pi[4,4] = (1 - slip[3]);
        pi[5,1] = guess[3];
        pi[5,2] = (1 - slip[3]);
        pi[5,3] = (1 - slip[3]);
        pi[5,4] = (1 - slip[3]);
        pi[6,1] = guess[3];
        pi[6,2] = (1 - slip[3]);
        pi[6,3] = (1 - slip[3]);
        pi[6,4] = (1 - slip[3]);
        pi[7,1] = guess[1]*guess[3];
        pi[7,2] = guess[1]*(1 - slip[3]);
        pi[7,3] = guess[1]*(1 - slip[3]);
        pi[7,4] = (1 - slip[1])*(1 - slip[3]);
        pi[8,1] = guess[2];
        pi[8,2] = guess[2];
        pi[8,3] = (1 - slip[2]);
        pi[8,4] = (1 - slip[2]);
        pi[9,1] = guess[3];
        pi[9,2] = (1 - slip[3]);
        pi[9,3] = (1 - slip[3]);
        pi[9,4] = (1 - slip[3]);
        pi[10,1] = guess[1];
        pi[10,2] = guess[1];
        pi[10,3] = guess[1];
        pi[10,4] = (1 - slip[1]);
        pi[11,1] = guess[1]*guess[3];
        pi[11,2] = guess[1]*(1 - slip[3]);
        pi[11,3] = guess[1]*(1 - slip[3]);
        pi[11,4] = (1 - slip[1])*(1 - slip[3]);
        pi[12,1] = guess[1]*guess[3];
        pi[12,2] = guess[1]*(1 - slip[3]);
        pi[12,3] = guess[1]*(1 - slip[3]);
        pi[12,4] = (1 - slip[1])*(1 - slip[3]);
        pi[13,1] = guess[1];
        pi[13,2] = guess[1];
        pi[13,3] = guess[1];
        pi[13,4] = (1 - slip[1]);
        pi[14,1] = guess[1];
        pi[14,2] = guess[1];
        pi[14,3] = guess[1];
        pi[14,4] = (1 - slip[1]);
        pi[15,1] = guess[3];
        pi[15,2] = (1 - slip[3]);
        pi[15,3] = (1 - slip[3]);
        pi[15,4] = (1 - slip[3]);
        pi[16,1] = guess[1]*guess[3];
        pi[16,2] = guess[1]*(1 - slip[3]);
        pi[16,3] = guess[1]*(1 - slip[3]);
        pi[16,4] = (1 - slip[1])*(1 - slip[3]);
        pi[17,1] = guess[2]*guess[3];
        pi[17,2] = guess[2]*(1 - slip[3]);
        pi[17,3] = (1 - slip[2])*(1 - slip[3]);
        pi[17,4] = (1 - slip[2])*(1 - slip[3]);
        pi[18,1] = guess[3];
        pi[18,2] = (1 - slip[3]);
        pi[18,3] = (1 - slip[3]);
        pi[18,4] = (1 - slip[3]);
        pi[19,1] = guess[3];
        pi[19,2] = (1 - slip[3]);
        pi[19,3] = (1 - slip[3]);
        pi[19,4] = (1 - slip[3]);
        pi[20,1] = guess[1]*guess[3];
        pi[20,2] = guess[1]*(1 - slip[3]);
        pi[20,3] = guess[1]*(1 - slip[3]);
        pi[20,4] = (1 - slip[1])*(1 - slip[3]);
        pi[21,1] = guess[1]*guess[3];
        pi[21,2] = guess[1]*(1 - slip[3]);
        pi[21,3] = guess[1]*(1 - slip[3]);
        pi[21,4] = (1 - slip[1])*(1 - slip[3]);
        pi[22,1] = guess[3];
        pi[22,2] = (1 - slip[3]);
        pi[22,3] = (1 - slip[3]);
        pi[22,4] = (1 - slip[3]);
        pi[23,1] = guess[2];
        pi[23,2] = guess[2];
        pi[23,3] = (1 - slip[2]);
        pi[23,4] = (1 - slip[2]);
        pi[24,1] = guess[2];
        pi[24,2] = guess[2];
        pi[24,3] = (1 - slip[2]);
        pi[24,4] = (1 - slip[2]);
        pi[25,1] = guess[1];
        pi[25,2] = guess[1];
        pi[25,3] = guess[1];
        pi[25,4] = (1 - slip[1]);
        pi[26,1] = guess[3];
        pi[26,2] = (1 - slip[3]);
        pi[26,3] = (1 - slip[3]);
        pi[26,4] = (1 - slip[3]);
        pi[27,1] = guess[1];
        pi[27,2] = guess[1];
        pi[27,3] = guess[1];
        pi[27,4] = (1 - slip[1]);
        pi[28,1] = guess[3];
        pi[28,2] = (1 - slip[3]);
        pi[28,3] = (1 - slip[3]);
        pi[28,4] = (1 - slip[3]);
      }
      model {
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        slip[1] ~ beta(5, 25);
        guess[1] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
      
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

