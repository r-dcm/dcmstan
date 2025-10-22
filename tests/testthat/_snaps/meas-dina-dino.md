# dina script works

    Code
      stan_code(ecpe_dina_unst)
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
        matrix[I,C] Xi;                      // class attribute indicator
      }
      parameters {
        simplex[C] Vc;                  // base rates of class membership
      
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
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
        slip[5] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[28] ~ beta(5, 25);
        guess[28] ~ beta(5, 25);
      
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
      stan_code(mdm_dina_unst)
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
        matrix[I,C] Xi;                      // class attribute indicator
      }
      parameters {
        simplex[C] Vc;                  // base rates of class membership
      
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
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
      stan_code(dtmr_dina_unst)
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
        matrix[I,C] Xi;                      // class attribute indicator
      }
      parameters {
        simplex[C] Vc;                  // base rates of class membership
      
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
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
        slip[5] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
      
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
      stan_code(ecpe_dina_indp)
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
        matrix[I,C] Xi;                      // class attribute indicator
        int<lower=1> A;                      // number of attributes
        matrix[C,A] Alpha;                   // attribute pattern for class
      }
      parameters {
        array[A] real<lower=0,upper=1> eta;
      
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
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
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
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
        slip[4] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[28] ~ beta(5, 25);
        guess[28] ~ beta(5, 25);
      
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
      stan_code(dtmr_dina_logl)
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
        matrix[I,C] Xi;                      // class attribute indicator
      }
      parameters {
        ////////////////////////////////// structural parameters
        real g_11;
        real g_12;
        real g_13;
        real g_14;
        real g_212;
        real g_213;
        real g_214;
        real g_223;
        real g_224;
        real g_234;
        real g_3123;
        real g_3124;
        real g_3134;
        real g_3234;
        real g_41234;
      
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        simplex[C] Vc;
        vector[C] log_Vc;
        vector[C] mu;
      
        ////////////////////////////////// probability of class membership
        mu[1] = 0;
        mu[2] = g_11;
        mu[3] = g_12;
        mu[4] = g_13;
        mu[5] = g_14;
        mu[6] = g_11+g_12+g_212;
        mu[7] = g_11+g_13+g_213;
        mu[8] = g_11+g_14+g_214;
        mu[9] = g_12+g_13+g_223;
        mu[10] = g_12+g_14+g_224;
        mu[11] = g_13+g_14+g_234;
        mu[12] = g_11+g_12+g_13+g_212+g_213+g_223+g_3123;
        mu[13] = g_11+g_12+g_14+g_212+g_214+g_224+g_3124;
        mu[14] = g_11+g_13+g_14+g_213+g_214+g_234+g_3134;
        mu[15] = g_12+g_13+g_14+g_223+g_224+g_234+g_3234;
        mu[16] = g_11+g_12+g_13+g_14+g_212+g_213+g_214+g_223+g_224+g_234+g_3123+g_3124+g_3134+g_3234+g_41234;
      
        log_Vc = mu - log_sum_exp(mu);
        Vc = exp(log_Vc);
        matrix[I,C] pi;
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
      }
      model {
      
        ////////////////////////////////// priors
        g_11 ~ normal(0, 10);
        g_12 ~ normal(0, 10);
        g_13 ~ normal(0, 10);
        g_14 ~ normal(0, 10);
        g_212 ~ normal(0, 10);
        g_213 ~ normal(0, 10);
        g_214 ~ normal(0, 10);
        g_223 ~ normal(0, 10);
        g_224 ~ normal(0, 10);
        g_234 ~ normal(0, 10);
        g_3123 ~ normal(0, 10);
        g_3124 ~ normal(0, 10);
        g_3134 ~ normal(0, 10);
        g_3234 ~ normal(0, 10);
        g_41234 ~ normal(0, 10);
        slip[1] ~ beta(5, 25);
        guess[1] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
      
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
      stan_code(ecpe_dina_bn)
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
        matrix[I,C] Xi;                      // class attribute indicator
      }
      parameters {
        ////////////////////////////////// structural intercepts
        real g1_0;
        real g2_0;
        real g3_0;
      
        ////////////////////////////////// structural main effects
        real<lower=0> g2_11;
        real<lower=0> g3_11;
        real<lower=0> g3_12;
      
        ////////////////////////////////// structural interactions
        real<lower=-1 * min([g3_11,g3_12])> g3_212;
      
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        simplex[C] Vc;
        vector[C] log_Vc;
      
        ////////////////////////////////// class membership probabilities
        Vc[1] = (1 - inv_logit(g1_0)) * (1 - inv_logit(g2_0)) * (1 - inv_logit(g3_0));
        Vc[2] = inv_logit(g1_0) * (1 - inv_logit(g2_0 + g2_11)) * (1 - inv_logit(g3_0 + g3_11));
        Vc[3] = (1 - inv_logit(g1_0)) * inv_logit(g2_0) * (1 - inv_logit(g3_0 + g3_12));
        Vc[4] = (1 - inv_logit(g1_0)) * (1 - inv_logit(g2_0)) * inv_logit(g3_0);
        Vc[5] = inv_logit(g1_0) * inv_logit(g2_0 + g2_11) * (1 - inv_logit(g3_0 + g3_11 + g3_12 + g3_212));
        Vc[6] = inv_logit(g1_0) * (1 - inv_logit(g2_0 + g2_11)) * inv_logit(g3_0 + g3_11);
        Vc[7] = (1 - inv_logit(g1_0)) * inv_logit(g2_0) * inv_logit(g3_0 + g3_12);
        Vc[8] = inv_logit(g1_0) * inv_logit(g2_0 + g2_11) * inv_logit(g3_0 + g3_11 + g3_12 + g3_212);
      
        log_Vc = log(Vc);
        matrix[I,C] pi;
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
      }
      model {
      
        ////////////////////////////////// priors
        g1_0 ~ normal(0, 2);
        g2_0 ~ normal(0, 2);
        g3_0 ~ normal(0, 2);
        g2_11 ~ lognormal(0, 1);
        g3_11 ~ lognormal(0, 1);
        g3_12 ~ lognormal(0, 1);
        g3_212 ~ normal(0, 2);
        slip[1] ~ beta(5, 25);
        guess[1] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[28] ~ beta(5, 25);
        guess[28] ~ beta(5, 25);
      
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
      stan_code(ecpe_dina_bn_hier)
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
        matrix[I,C] Xi;                      // class attribute indicator
      }
      parameters {
        ////////////////////////////////// structural intercepts
        real g1_0;
        real g2_0;
        real g3_0;
      
        ////////////////////////////////// structural main effects
        real<lower=0> g1_12;
        real<lower=0> g2_13;
      
      
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        simplex[C] Vc;
        vector[C] log_Vc;
      
        ////////////////////////////////// class membership probabilities
        Vc[1] = (1 - inv_logit(g1_0)) * (1 - inv_logit(g2_0)) * (1 - inv_logit(g3_0));
        Vc[2] = inv_logit(g1_0) * (1 - inv_logit(g2_0)) * (1 - inv_logit(g3_0));
        Vc[3] = (1 - inv_logit(g1_0 + g1_12)) * inv_logit(g2_0) * (1 - inv_logit(g3_0));
        Vc[4] = (1 - inv_logit(g1_0)) * (1 - inv_logit(g2_0 + g2_13)) * inv_logit(g3_0);
        Vc[5] = inv_logit(g1_0 + g1_12) * inv_logit(g2_0) * (1 - inv_logit(g3_0));
        Vc[6] = inv_logit(g1_0) * (1 - inv_logit(g2_0 + g2_13)) * inv_logit(g3_0);
        Vc[7] = (1 - inv_logit(g1_0 + g1_12)) * inv_logit(g2_0 + g2_13) * inv_logit(g3_0);
        Vc[8] = inv_logit(g1_0 + g1_12) * inv_logit(g2_0 + g2_13) * inv_logit(g3_0);
      
        log_Vc = log(Vc);
        matrix[I,C] pi;
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
      }
      model {
      
        ////////////////////////////////// priors
        g1_0 ~ normal(0, 2);
        g2_0 ~ normal(0, 2);
        g3_0 ~ normal(0, 2);
        g1_12 ~ lognormal(0, 1);
        g2_13 ~ lognormal(0, 1);
        slip[1] ~ beta(5, 25);
        guess[1] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[28] ~ beta(5, 25);
        guess[28] ~ beta(5, 25);
      
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

# dino script works

    Code
      stan_code(ecpe_dino_unst)
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
        matrix[I,C] Xi;                      // class attribute indicator
      }
      parameters {
        simplex[C] Vc;                  // base rates of class membership
      
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
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
        slip[5] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[28] ~ beta(5, 25);
        guess[28] ~ beta(5, 25);
      
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
      stan_code(mdm_dino_unst)
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
        matrix[I,C] Xi;                      // class attribute indicator
      }
      parameters {
        simplex[C] Vc;                  // base rates of class membership
      
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
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
      stan_code(dtmr_dino_unst)
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
        matrix[I,C] Xi;                      // class attribute indicator
      }
      parameters {
        simplex[C] Vc;                  // base rates of class membership
      
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
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
        slip[5] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
      
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
      stan_code(ecpe_dino_indp)
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
        matrix[I,C] Xi;                      // class attribute indicator
        int<lower=1> A;                      // number of attributes
        matrix[C,A] Alpha;                   // attribute pattern for class
      }
      parameters {
        array[A] real<lower=0,upper=1> eta;
      
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
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
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
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
        slip[4] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[28] ~ beta(5, 25);
        guess[28] ~ beta(5, 25);
      
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
      stan_code(dtmr_dino_logl)
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
        matrix[I,C] Xi;                      // class attribute indicator
      }
      parameters {
        ////////////////////////////////// structural parameters
        real g_11;
        real g_12;
        real g_13;
        real g_14;
        real g_212;
        real g_213;
        real g_214;
        real g_223;
        real g_224;
        real g_234;
        real g_3123;
        real g_3124;
        real g_3134;
        real g_3234;
        real g_41234;
      
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        simplex[C] Vc;
        vector[C] log_Vc;
        vector[C] mu;
      
        ////////////////////////////////// probability of class membership
        mu[1] = 0;
        mu[2] = g_11;
        mu[3] = g_12;
        mu[4] = g_13;
        mu[5] = g_14;
        mu[6] = g_11+g_12+g_212;
        mu[7] = g_11+g_13+g_213;
        mu[8] = g_11+g_14+g_214;
        mu[9] = g_12+g_13+g_223;
        mu[10] = g_12+g_14+g_224;
        mu[11] = g_13+g_14+g_234;
        mu[12] = g_11+g_12+g_13+g_212+g_213+g_223+g_3123;
        mu[13] = g_11+g_12+g_14+g_212+g_214+g_224+g_3124;
        mu[14] = g_11+g_13+g_14+g_213+g_214+g_234+g_3134;
        mu[15] = g_12+g_13+g_14+g_223+g_224+g_234+g_3234;
        mu[16] = g_11+g_12+g_13+g_14+g_212+g_213+g_214+g_223+g_224+g_234+g_3123+g_3124+g_3134+g_3234+g_41234;
      
        log_Vc = mu - log_sum_exp(mu);
        Vc = exp(log_Vc);
        matrix[I,C] pi;
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
      }
      model {
      
        ////////////////////////////////// priors
        g_11 ~ normal(0, 10);
        g_12 ~ normal(0, 10);
        g_13 ~ normal(0, 10);
        g_14 ~ normal(0, 10);
        g_212 ~ normal(0, 10);
        g_213 ~ normal(0, 10);
        g_214 ~ normal(0, 10);
        g_223 ~ normal(0, 10);
        g_224 ~ normal(0, 10);
        g_234 ~ normal(0, 10);
        g_3123 ~ normal(0, 10);
        g_3124 ~ normal(0, 10);
        g_3134 ~ normal(0, 10);
        g_3234 ~ normal(0, 10);
        g_41234 ~ normal(0, 10);
        slip[1] ~ beta(5, 25);
        guess[1] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
      
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
      stan_code(ecpe_dino_bn)
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
        matrix[I,C] Xi;                      // class attribute indicator
      }
      parameters {
        ////////////////////////////////// structural intercepts
        real g1_0;
        real g2_0;
        real g3_0;
      
        ////////////////////////////////// structural main effects
        real<lower=0> g2_11;
        real<lower=0> g3_11;
        real<lower=0> g3_12;
      
        ////////////////////////////////// structural interactions
        real<lower=-1 * min([g3_11,g3_12])> g3_212;
      
        ////////////////////////////////// item parameters
        array[I] real<lower=0,upper=1> slip;
        array[I] real<lower=0,upper=1> guess;
      }
      transformed parameters {
        simplex[C] Vc;
        vector[C] log_Vc;
      
        ////////////////////////////////// class membership probabilities
        Vc[1] = (1 - inv_logit(g1_0)) * (1 - inv_logit(g2_0)) * (1 - inv_logit(g3_0));
        Vc[2] = inv_logit(g1_0) * (1 - inv_logit(g2_0 + g2_11)) * (1 - inv_logit(g3_0 + g3_11));
        Vc[3] = (1 - inv_logit(g1_0)) * inv_logit(g2_0) * (1 - inv_logit(g3_0 + g3_12));
        Vc[4] = (1 - inv_logit(g1_0)) * (1 - inv_logit(g2_0)) * inv_logit(g3_0);
        Vc[5] = inv_logit(g1_0) * inv_logit(g2_0 + g2_11) * (1 - inv_logit(g3_0 + g3_11 + g3_12 + g3_212));
        Vc[6] = inv_logit(g1_0) * (1 - inv_logit(g2_0 + g2_11)) * inv_logit(g3_0 + g3_11);
        Vc[7] = (1 - inv_logit(g1_0)) * inv_logit(g2_0) * inv_logit(g3_0 + g3_12);
        Vc[8] = inv_logit(g1_0) * inv_logit(g2_0 + g2_11) * inv_logit(g3_0 + g3_11 + g3_12 + g3_212);
      
        log_Vc = log(Vc);
        matrix[I,C] pi;
      
        for (i in 1:I) {
          for (c in 1:C) {
            pi[i,c] = ((1 - slip[i]) ^ Xi[i,c]) * (guess[i] ^ (1 - Xi[i,c]));
          }
        }
      }
      model {
      
        ////////////////////////////////// priors
        g1_0 ~ normal(0, 2);
        g2_0 ~ normal(0, 2);
        g3_0 ~ normal(0, 2);
        g2_11 ~ lognormal(0, 1);
        g3_11 ~ lognormal(0, 1);
        g3_12 ~ lognormal(0, 1);
        g3_212 ~ normal(0, 2);
        slip[1] ~ beta(5, 25);
        guess[1] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[28] ~ beta(5, 25);
        guess[28] ~ beta(5, 25);
      
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

