# dina script works

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
        guess[1] ~ beta(5, 25);
        slip[1] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[28] ~ beta(5, 25);
        slip[28] ~ beta(5, 25);
      
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
        guess[1] ~ beta(5, 25);
        slip[1] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
      
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
        guess[1] ~ beta(5, 25);
        slip[1] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
      
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
        guess[1] ~ beta(5, 25);
        slip[1] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[28] ~ beta(5, 25);
        slip[28] ~ beta(5, 25);
      
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
      generate_stan(ecpe_spec3)
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
        ////////////////////////////////// strc main effects
        real g_11;
        real g_12;
        real g_13;
      
        ////////////////////////////////// strc interactions
        real g_212;
        real g_213;
        real g_223;
        real g_3123;
      
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
        mu[5] = g_11+g_12+g_212;
        mu[6] = g_11+g_13+g_213;
        mu[7] = g_12+g_13+g_223;
        mu[8] = g_11+g_12+g_13+g_212+g_213+g_223+g_3123;
      
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
        g_212 ~ normal(0, 10);
        g_213 ~ normal(0, 10);
        g_223 ~ normal(0, 10);
        g_3123 ~ normal(0, 10);
        guess[1] ~ beta(5, 25);
        slip[1] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[28] ~ beta(5, 25);
        slip[28] ~ beta(5, 25);
      
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
        guess[1] ~ beta(5, 25);
        slip[1] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[28] ~ beta(5, 25);
        slip[28] ~ beta(5, 25);
      
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
        guess[1] ~ beta(5, 25);
        slip[1] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
      
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
        guess[1] ~ beta(5, 25);
        slip[1] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
      
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
        guess[1] ~ beta(5, 25);
        slip[1] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[28] ~ beta(5, 25);
        slip[28] ~ beta(5, 25);
      
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
      generate_stan(ecpe_spec3)
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
        ////////////////////////////////// strc main effects
        real g_11;
        real g_12;
        real g_13;
      
        ////////////////////////////////// strc interactions
        real g_212;
        real g_213;
        real g_223;
        real g_3123;
      
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
        mu[5] = g_11+g_12+g_212;
        mu[6] = g_11+g_13+g_213;
        mu[7] = g_12+g_13+g_223;
        mu[8] = g_11+g_12+g_13+g_212+g_213+g_223+g_3123;
      
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
        g_212 ~ normal(0, 10);
        g_213 ~ normal(0, 10);
        g_223 ~ normal(0, 10);
        g_3123 ~ normal(0, 10);
        guess[1] ~ beta(5, 25);
        slip[1] ~ beta(5, 25);
        guess[2] ~ beta(5, 25);
        slip[2] ~ beta(5, 25);
        guess[3] ~ beta(5, 25);
        slip[3] ~ beta(5, 25);
        guess[4] ~ beta(5, 25);
        slip[4] ~ beta(5, 25);
        guess[5] ~ beta(5, 25);
        slip[5] ~ beta(5, 25);
        guess[6] ~ beta(5, 25);
        slip[6] ~ beta(5, 25);
        guess[7] ~ beta(5, 25);
        slip[7] ~ beta(5, 25);
        guess[8] ~ beta(5, 25);
        slip[8] ~ beta(5, 25);
        guess[9] ~ beta(5, 25);
        slip[9] ~ beta(5, 25);
        guess[10] ~ beta(5, 25);
        slip[10] ~ beta(5, 25);
        guess[11] ~ beta(5, 25);
        slip[11] ~ beta(5, 25);
        guess[12] ~ beta(5, 25);
        slip[12] ~ beta(5, 25);
        guess[13] ~ beta(5, 25);
        slip[13] ~ beta(5, 25);
        guess[14] ~ beta(5, 25);
        slip[14] ~ beta(5, 25);
        guess[15] ~ beta(5, 25);
        slip[15] ~ beta(5, 25);
        guess[16] ~ beta(5, 25);
        slip[16] ~ beta(5, 25);
        guess[17] ~ beta(5, 25);
        slip[17] ~ beta(5, 25);
        guess[18] ~ beta(5, 25);
        slip[18] ~ beta(5, 25);
        guess[19] ~ beta(5, 25);
        slip[19] ~ beta(5, 25);
        guess[20] ~ beta(5, 25);
        slip[20] ~ beta(5, 25);
        guess[21] ~ beta(5, 25);
        slip[21] ~ beta(5, 25);
        guess[22] ~ beta(5, 25);
        slip[22] ~ beta(5, 25);
        guess[23] ~ beta(5, 25);
        slip[23] ~ beta(5, 25);
        guess[24] ~ beta(5, 25);
        slip[24] ~ beta(5, 25);
        guess[25] ~ beta(5, 25);
        slip[25] ~ beta(5, 25);
        guess[26] ~ beta(5, 25);
        slip[26] ~ beta(5, 25);
        guess[27] ~ beta(5, 25);
        slip[27] ~ beta(5, 25);
        guess[28] ~ beta(5, 25);
        slip[28] ~ beta(5, 25);
      
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

