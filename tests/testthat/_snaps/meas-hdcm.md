# hdcm script works with unconstrained structural model

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
      
        ////////////////////////////////// item intercepts
        real l1_0;
        real l2_0;
        real l3_0;
        real l4_0;
        real l5_0;
        real l6_0;
        real l7_0;
        real l8_0;
        real l9_0;
        real l10_0;
        real l11_0;
        real l12_0;
        real l13_0;
        real l14_0;
        real l15_0;
        real l16_0;
        real l17_0;
        real l18_0;
        real l19_0;
        real l20_0;
        real l21_0;
        real l22_0;
        real l23_0;
        real l24_0;
        real l25_0;
        real l26_0;
        real l27_0;
        real l28_0;
      
        ////////////////////////////////// item main effects
        real<lower=0> l1_11;
        real<lower=0> l1_12;
        real<lower=0> l2_12;
        real<lower=0> l3_11;
        real<lower=0> l3_13;
        real<lower=0> l4_13;
        real<lower=0> l5_13;
        real<lower=0> l6_13;
        real<lower=0> l7_11;
        real<lower=0> l7_13;
        real<lower=0> l8_12;
        real<lower=0> l9_13;
        real<lower=0> l10_11;
        real<lower=0> l11_11;
        real<lower=0> l11_13;
        real<lower=0> l12_11;
        real<lower=0> l12_13;
        real<lower=0> l13_11;
        real<lower=0> l14_11;
        real<lower=0> l15_13;
        real<lower=0> l16_11;
        real<lower=0> l16_13;
        real<lower=0> l17_12;
        real<lower=0> l17_13;
        real<lower=0> l18_13;
        real<lower=0> l19_13;
        real<lower=0> l20_11;
        real<lower=0> l20_13;
        real<lower=0> l21_11;
        real<lower=0> l21_13;
        real<lower=0> l22_13;
        real<lower=0> l23_12;
        real<lower=0> l24_12;
        real<lower=0> l25_11;
        real<lower=0> l26_13;
        real<lower=0> l27_11;
        real<lower=0> l28_13;
      
        ////////////////////////////////// item interactions
        real<lower=-1 * min([l1_11,l1_12])> l1_212;
        real<lower=-1 * min([l3_11,l3_13])> l3_213;
        real<lower=-1 * min([l7_11,l7_13])> l7_213;
        real<lower=-1 * min([l11_11,l11_13])> l11_213;
        real<lower=-1 * min([l12_11,l12_13])> l12_213;
        real<lower=-1 * min([l16_11,l16_13])> l16_213;
        real<lower=-1 * min([l17_12,l17_13])> l17_223;
        real<lower=-1 * min([l20_11,l20_13])> l20_213;
        real<lower=-1 * min([l21_11,l21_13])> l21_213;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = inv_logit(l1_0);
        pi[1,2] = inv_logit(l1_0);
        pi[1,3] = inv_logit(l1_0+l1_12);
        pi[1,4] = inv_logit(l1_0+l1_11+l1_12+l1_212);
        pi[2,1] = inv_logit(l2_0);
        pi[2,2] = inv_logit(l2_0);
        pi[2,3] = inv_logit(l2_0+l2_12);
        pi[2,4] = inv_logit(l2_0+l2_12);
        pi[3,1] = inv_logit(l3_0);
        pi[3,2] = inv_logit(l3_0+l3_13);
        pi[3,3] = inv_logit(l3_0+l3_13);
        pi[3,4] = inv_logit(l3_0+l3_11+l3_13+l3_213);
        pi[4,1] = inv_logit(l4_0);
        pi[4,2] = inv_logit(l4_0+l4_13);
        pi[4,3] = inv_logit(l4_0+l4_13);
        pi[4,4] = inv_logit(l4_0+l4_13);
        pi[5,1] = inv_logit(l5_0);
        pi[5,2] = inv_logit(l5_0+l5_13);
        pi[5,3] = inv_logit(l5_0+l5_13);
        pi[5,4] = inv_logit(l5_0+l5_13);
        pi[6,1] = inv_logit(l6_0);
        pi[6,2] = inv_logit(l6_0+l6_13);
        pi[6,3] = inv_logit(l6_0+l6_13);
        pi[6,4] = inv_logit(l6_0+l6_13);
        pi[7,1] = inv_logit(l7_0);
        pi[7,2] = inv_logit(l7_0+l7_13);
        pi[7,3] = inv_logit(l7_0+l7_13);
        pi[7,4] = inv_logit(l7_0+l7_11+l7_13+l7_213);
        pi[8,1] = inv_logit(l8_0);
        pi[8,2] = inv_logit(l8_0);
        pi[8,3] = inv_logit(l8_0+l8_12);
        pi[8,4] = inv_logit(l8_0+l8_12);
        pi[9,1] = inv_logit(l9_0);
        pi[9,2] = inv_logit(l9_0+l9_13);
        pi[9,3] = inv_logit(l9_0+l9_13);
        pi[9,4] = inv_logit(l9_0+l9_13);
        pi[10,1] = inv_logit(l10_0);
        pi[10,2] = inv_logit(l10_0);
        pi[10,3] = inv_logit(l10_0);
        pi[10,4] = inv_logit(l10_0+l10_11);
        pi[11,1] = inv_logit(l11_0);
        pi[11,2] = inv_logit(l11_0+l11_13);
        pi[11,3] = inv_logit(l11_0+l11_13);
        pi[11,4] = inv_logit(l11_0+l11_11+l11_13+l11_213);
        pi[12,1] = inv_logit(l12_0);
        pi[12,2] = inv_logit(l12_0+l12_13);
        pi[12,3] = inv_logit(l12_0+l12_13);
        pi[12,4] = inv_logit(l12_0+l12_11+l12_13+l12_213);
        pi[13,1] = inv_logit(l13_0);
        pi[13,2] = inv_logit(l13_0);
        pi[13,3] = inv_logit(l13_0);
        pi[13,4] = inv_logit(l13_0+l13_11);
        pi[14,1] = inv_logit(l14_0);
        pi[14,2] = inv_logit(l14_0);
        pi[14,3] = inv_logit(l14_0);
        pi[14,4] = inv_logit(l14_0+l14_11);
        pi[15,1] = inv_logit(l15_0);
        pi[15,2] = inv_logit(l15_0+l15_13);
        pi[15,3] = inv_logit(l15_0+l15_13);
        pi[15,4] = inv_logit(l15_0+l15_13);
        pi[16,1] = inv_logit(l16_0);
        pi[16,2] = inv_logit(l16_0+l16_13);
        pi[16,3] = inv_logit(l16_0+l16_13);
        pi[16,4] = inv_logit(l16_0+l16_11+l16_13+l16_213);
        pi[17,1] = inv_logit(l17_0);
        pi[17,2] = inv_logit(l17_0+l17_13);
        pi[17,3] = inv_logit(l17_0+l17_12+l17_13+l17_223);
        pi[17,4] = inv_logit(l17_0+l17_12+l17_13+l17_223);
        pi[18,1] = inv_logit(l18_0);
        pi[18,2] = inv_logit(l18_0+l18_13);
        pi[18,3] = inv_logit(l18_0+l18_13);
        pi[18,4] = inv_logit(l18_0+l18_13);
        pi[19,1] = inv_logit(l19_0);
        pi[19,2] = inv_logit(l19_0+l19_13);
        pi[19,3] = inv_logit(l19_0+l19_13);
        pi[19,4] = inv_logit(l19_0+l19_13);
        pi[20,1] = inv_logit(l20_0);
        pi[20,2] = inv_logit(l20_0+l20_13);
        pi[20,3] = inv_logit(l20_0+l20_13);
        pi[20,4] = inv_logit(l20_0+l20_11+l20_13+l20_213);
        pi[21,1] = inv_logit(l21_0);
        pi[21,2] = inv_logit(l21_0+l21_13);
        pi[21,3] = inv_logit(l21_0+l21_13);
        pi[21,4] = inv_logit(l21_0+l21_11+l21_13+l21_213);
        pi[22,1] = inv_logit(l22_0);
        pi[22,2] = inv_logit(l22_0+l22_13);
        pi[22,3] = inv_logit(l22_0+l22_13);
        pi[22,4] = inv_logit(l22_0+l22_13);
        pi[23,1] = inv_logit(l23_0);
        pi[23,2] = inv_logit(l23_0);
        pi[23,3] = inv_logit(l23_0+l23_12);
        pi[23,4] = inv_logit(l23_0+l23_12);
        pi[24,1] = inv_logit(l24_0);
        pi[24,2] = inv_logit(l24_0);
        pi[24,3] = inv_logit(l24_0+l24_12);
        pi[24,4] = inv_logit(l24_0+l24_12);
        pi[25,1] = inv_logit(l25_0);
        pi[25,2] = inv_logit(l25_0);
        pi[25,3] = inv_logit(l25_0);
        pi[25,4] = inv_logit(l25_0+l25_11);
        pi[26,1] = inv_logit(l26_0);
        pi[26,2] = inv_logit(l26_0+l26_13);
        pi[26,3] = inv_logit(l26_0+l26_13);
        pi[26,4] = inv_logit(l26_0+l26_13);
        pi[27,1] = inv_logit(l27_0);
        pi[27,2] = inv_logit(l27_0);
        pi[27,3] = inv_logit(l27_0);
        pi[27,4] = inv_logit(l27_0+l27_11);
        pi[28,1] = inv_logit(l28_0);
        pi[28,2] = inv_logit(l28_0+l28_13);
        pi[28,3] = inv_logit(l28_0+l28_13);
        pi[28,4] = inv_logit(l28_0+l28_13);
      }
      model {
      
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        l1_0 ~ normal(0, 2);
        l1_11 ~ lognormal(0, 1);
        l1_12 ~ lognormal(0, 1);
        l1_212 ~ normal(0, 2);
        l2_0 ~ normal(0, 2);
        l2_12 ~ lognormal(0, 1);
        l3_0 ~ normal(0, 2);
        l3_11 ~ lognormal(0, 1);
        l3_13 ~ lognormal(0, 1);
        l3_213 ~ normal(0, 2);
        l4_0 ~ normal(0, 2);
        l4_13 ~ lognormal(0, 1);
        l5_0 ~ normal(0, 2);
        l5_13 ~ lognormal(0, 1);
        l6_0 ~ normal(0, 2);
        l6_13 ~ lognormal(0, 1);
        l7_0 ~ normal(0, 2);
        l7_11 ~ lognormal(0, 1);
        l7_13 ~ lognormal(0, 1);
        l7_213 ~ normal(0, 2);
        l8_0 ~ normal(0, 2);
        l8_12 ~ lognormal(0, 1);
        l9_0 ~ normal(0, 2);
        l9_13 ~ lognormal(0, 1);
        l10_0 ~ normal(0, 2);
        l10_11 ~ lognormal(0, 1);
        l11_0 ~ normal(0, 2);
        l11_11 ~ lognormal(0, 1);
        l11_13 ~ lognormal(0, 1);
        l11_213 ~ normal(0, 2);
        l12_0 ~ normal(0, 2);
        l12_11 ~ lognormal(0, 1);
        l12_13 ~ lognormal(0, 1);
        l12_213 ~ normal(0, 2);
        l13_0 ~ normal(0, 2);
        l13_11 ~ lognormal(0, 1);
        l14_0 ~ normal(0, 2);
        l14_11 ~ lognormal(0, 1);
        l15_0 ~ normal(0, 2);
        l15_13 ~ lognormal(0, 1);
        l16_0 ~ normal(0, 2);
        l16_11 ~ lognormal(0, 1);
        l16_13 ~ lognormal(0, 1);
        l16_213 ~ normal(0, 2);
        l17_0 ~ normal(0, 2);
        l17_12 ~ lognormal(0, 1);
        l17_13 ~ lognormal(0, 1);
        l17_223 ~ normal(0, 2);
        l18_0 ~ normal(0, 2);
        l18_13 ~ lognormal(0, 1);
        l19_0 ~ normal(0, 2);
        l19_13 ~ lognormal(0, 1);
        l20_0 ~ normal(0, 2);
        l20_11 ~ lognormal(0, 1);
        l20_13 ~ lognormal(0, 1);
        l20_213 ~ normal(0, 2);
        l21_0 ~ normal(0, 2);
        l21_11 ~ lognormal(0, 1);
        l21_13 ~ lognormal(0, 1);
        l21_213 ~ normal(0, 2);
        l22_0 ~ normal(0, 2);
        l22_13 ~ lognormal(0, 1);
        l23_0 ~ normal(0, 2);
        l23_12 ~ lognormal(0, 1);
        l24_0 ~ normal(0, 2);
        l24_12 ~ lognormal(0, 1);
        l25_0 ~ normal(0, 2);
        l25_11 ~ lognormal(0, 1);
        l26_0 ~ normal(0, 2);
        l26_13 ~ lognormal(0, 1);
        l27_0 ~ normal(0, 2);
        l27_11 ~ lognormal(0, 1);
        l28_0 ~ normal(0, 2);
        l28_13 ~ lognormal(0, 1);
      
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
      
        ////////////////////////////////// item intercepts
        real l1_0;
        real l2_0;
        real l3_0;
        real l4_0;
        real l5_0;
        real l6_0;
        real l7_0;
        real l8_0;
        real l9_0;
        real l10_0;
        real l11_0;
        real l12_0;
        real l13_0;
        real l14_0;
        real l15_0;
        real l16_0;
        real l17_0;
        real l18_0;
        real l19_0;
        real l20_0;
        real l21_0;
        real l22_0;
        real l23_0;
        real l24_0;
        real l25_0;
        real l26_0;
        real l27_0;
      
        ////////////////////////////////// item main effects
        real<lower=0> l1_11;
        real<lower=0> l2_13;
        real<lower=0> l3_12;
        real<lower=0> l4_11;
        real<lower=0> l5_11;
        real<lower=0> l6_12;
        real<lower=0> l7_11;
        real<lower=0> l8_13;
        real<lower=0> l9_13;
        real<lower=0> l10_13;
        real<lower=0> l11_13;
        real<lower=0> l12_11;
        real<lower=0> l13_14;
        real<lower=0> l14_11;
        real<lower=0> l14_14;
        real<lower=0> l15_11;
        real<lower=0> l15_14;
        real<lower=0> l16_11;
        real<lower=0> l17_11;
        real<lower=0> l18_12;
        real<lower=0> l18_14;
        real<lower=0> l19_11;
        real<lower=0> l19_12;
        real<lower=0> l20_12;
        real<lower=0> l20_14;
        real<lower=0> l21_12;
        real<lower=0> l22_12;
        real<lower=0> l23_11;
        real<lower=0> l24_11;
        real<lower=0> l24_12;
        real<lower=0> l25_11;
        real<lower=0> l25_12;
        real<lower=0> l26_11;
        real<lower=0> l27_11;
        real<lower=0> l27_12;
      
        ////////////////////////////////// item interactions
        real<lower=-1 * min([l14_11,l14_14])> l14_214;
        real<lower=-1 * min([l15_11,l15_14])> l15_214;
        real<lower=-1 * min([l18_12,l18_14])> l18_224;
        real<lower=-1 * min([l19_11,l19_12])> l19_212;
        real<lower=-1 * min([l20_12,l20_14])> l20_224;
        real<lower=-1 * min([l24_11,l24_12])> l24_212;
        real<lower=-1 * min([l25_11,l25_12])> l25_212;
        real<lower=-1 * min([l27_11,l27_12])> l27_212;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = inv_logit(l1_0);
        pi[1,2] = inv_logit(l1_0+l1_11);
        pi[1,3] = inv_logit(l1_0+l1_11);
        pi[1,4] = inv_logit(l1_0+l1_11);
        pi[1,5] = inv_logit(l1_0+l1_11);
        pi[2,1] = inv_logit(l2_0);
        pi[2,2] = inv_logit(l2_0);
        pi[2,3] = inv_logit(l2_0);
        pi[2,4] = inv_logit(l2_0+l2_13);
        pi[2,5] = inv_logit(l2_0+l2_13);
        pi[3,1] = inv_logit(l3_0);
        pi[3,2] = inv_logit(l3_0);
        pi[3,3] = inv_logit(l3_0+l3_12);
        pi[3,4] = inv_logit(l3_0+l3_12);
        pi[3,5] = inv_logit(l3_0+l3_12);
        pi[4,1] = inv_logit(l4_0);
        pi[4,2] = inv_logit(l4_0+l4_11);
        pi[4,3] = inv_logit(l4_0+l4_11);
        pi[4,4] = inv_logit(l4_0+l4_11);
        pi[4,5] = inv_logit(l4_0+l4_11);
        pi[5,1] = inv_logit(l5_0);
        pi[5,2] = inv_logit(l5_0+l5_11);
        pi[5,3] = inv_logit(l5_0+l5_11);
        pi[5,4] = inv_logit(l5_0+l5_11);
        pi[5,5] = inv_logit(l5_0+l5_11);
        pi[6,1] = inv_logit(l6_0);
        pi[6,2] = inv_logit(l6_0);
        pi[6,3] = inv_logit(l6_0+l6_12);
        pi[6,4] = inv_logit(l6_0+l6_12);
        pi[6,5] = inv_logit(l6_0+l6_12);
        pi[7,1] = inv_logit(l7_0);
        pi[7,2] = inv_logit(l7_0+l7_11);
        pi[7,3] = inv_logit(l7_0+l7_11);
        pi[7,4] = inv_logit(l7_0+l7_11);
        pi[7,5] = inv_logit(l7_0+l7_11);
        pi[8,1] = inv_logit(l8_0);
        pi[8,2] = inv_logit(l8_0);
        pi[8,3] = inv_logit(l8_0);
        pi[8,4] = inv_logit(l8_0+l8_13);
        pi[8,5] = inv_logit(l8_0+l8_13);
        pi[9,1] = inv_logit(l9_0);
        pi[9,2] = inv_logit(l9_0);
        pi[9,3] = inv_logit(l9_0);
        pi[9,4] = inv_logit(l9_0+l9_13);
        pi[9,5] = inv_logit(l9_0+l9_13);
        pi[10,1] = inv_logit(l10_0);
        pi[10,2] = inv_logit(l10_0);
        pi[10,3] = inv_logit(l10_0);
        pi[10,4] = inv_logit(l10_0+l10_13);
        pi[10,5] = inv_logit(l10_0+l10_13);
        pi[11,1] = inv_logit(l11_0);
        pi[11,2] = inv_logit(l11_0);
        pi[11,3] = inv_logit(l11_0);
        pi[11,4] = inv_logit(l11_0+l11_13);
        pi[11,5] = inv_logit(l11_0+l11_13);
        pi[12,1] = inv_logit(l12_0);
        pi[12,2] = inv_logit(l12_0+l12_11);
        pi[12,3] = inv_logit(l12_0+l12_11);
        pi[12,4] = inv_logit(l12_0+l12_11);
        pi[12,5] = inv_logit(l12_0+l12_11);
        pi[13,1] = inv_logit(l13_0);
        pi[13,2] = inv_logit(l13_0);
        pi[13,3] = inv_logit(l13_0);
        pi[13,4] = inv_logit(l13_0);
        pi[13,5] = inv_logit(l13_0+l13_14);
        pi[14,1] = inv_logit(l14_0);
        pi[14,2] = inv_logit(l14_0+l14_11);
        pi[14,3] = inv_logit(l14_0+l14_11);
        pi[14,4] = inv_logit(l14_0+l14_11);
        pi[14,5] = inv_logit(l14_0+l14_11+l14_14+l14_214);
        pi[15,1] = inv_logit(l15_0);
        pi[15,2] = inv_logit(l15_0+l15_11);
        pi[15,3] = inv_logit(l15_0+l15_11);
        pi[15,4] = inv_logit(l15_0+l15_11);
        pi[15,5] = inv_logit(l15_0+l15_11+l15_14+l15_214);
        pi[16,1] = inv_logit(l16_0);
        pi[16,2] = inv_logit(l16_0+l16_11);
        pi[16,3] = inv_logit(l16_0+l16_11);
        pi[16,4] = inv_logit(l16_0+l16_11);
        pi[16,5] = inv_logit(l16_0+l16_11);
        pi[17,1] = inv_logit(l17_0);
        pi[17,2] = inv_logit(l17_0+l17_11);
        pi[17,3] = inv_logit(l17_0+l17_11);
        pi[17,4] = inv_logit(l17_0+l17_11);
        pi[17,5] = inv_logit(l17_0+l17_11);
        pi[18,1] = inv_logit(l18_0);
        pi[18,2] = inv_logit(l18_0);
        pi[18,3] = inv_logit(l18_0+l18_12);
        pi[18,4] = inv_logit(l18_0+l18_12);
        pi[18,5] = inv_logit(l18_0+l18_12+l18_14+l18_224);
        pi[19,1] = inv_logit(l19_0);
        pi[19,2] = inv_logit(l19_0+l19_11);
        pi[19,3] = inv_logit(l19_0+l19_11+l19_12+l19_212);
        pi[19,4] = inv_logit(l19_0+l19_11+l19_12+l19_212);
        pi[19,5] = inv_logit(l19_0+l19_11+l19_12+l19_212);
        pi[20,1] = inv_logit(l20_0);
        pi[20,2] = inv_logit(l20_0);
        pi[20,3] = inv_logit(l20_0+l20_12);
        pi[20,4] = inv_logit(l20_0+l20_12);
        pi[20,5] = inv_logit(l20_0+l20_12+l20_14+l20_224);
        pi[21,1] = inv_logit(l21_0);
        pi[21,2] = inv_logit(l21_0);
        pi[21,3] = inv_logit(l21_0+l21_12);
        pi[21,4] = inv_logit(l21_0+l21_12);
        pi[21,5] = inv_logit(l21_0+l21_12);
        pi[22,1] = inv_logit(l22_0);
        pi[22,2] = inv_logit(l22_0);
        pi[22,3] = inv_logit(l22_0+l22_12);
        pi[22,4] = inv_logit(l22_0+l22_12);
        pi[22,5] = inv_logit(l22_0+l22_12);
        pi[23,1] = inv_logit(l23_0);
        pi[23,2] = inv_logit(l23_0+l23_11);
        pi[23,3] = inv_logit(l23_0+l23_11);
        pi[23,4] = inv_logit(l23_0+l23_11);
        pi[23,5] = inv_logit(l23_0+l23_11);
        pi[24,1] = inv_logit(l24_0);
        pi[24,2] = inv_logit(l24_0+l24_11);
        pi[24,3] = inv_logit(l24_0+l24_11+l24_12+l24_212);
        pi[24,4] = inv_logit(l24_0+l24_11+l24_12+l24_212);
        pi[24,5] = inv_logit(l24_0+l24_11+l24_12+l24_212);
        pi[25,1] = inv_logit(l25_0);
        pi[25,2] = inv_logit(l25_0+l25_11);
        pi[25,3] = inv_logit(l25_0+l25_11+l25_12+l25_212);
        pi[25,4] = inv_logit(l25_0+l25_11+l25_12+l25_212);
        pi[25,5] = inv_logit(l25_0+l25_11+l25_12+l25_212);
        pi[26,1] = inv_logit(l26_0);
        pi[26,2] = inv_logit(l26_0+l26_11);
        pi[26,3] = inv_logit(l26_0+l26_11);
        pi[26,4] = inv_logit(l26_0+l26_11);
        pi[26,5] = inv_logit(l26_0+l26_11);
        pi[27,1] = inv_logit(l27_0);
        pi[27,2] = inv_logit(l27_0+l27_11);
        pi[27,3] = inv_logit(l27_0+l27_11+l27_12+l27_212);
        pi[27,4] = inv_logit(l27_0+l27_11+l27_12+l27_212);
        pi[27,5] = inv_logit(l27_0+l27_11+l27_12+l27_212);
      }
      model {
      
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        l1_0 ~ normal(0, 2);
        l1_11 ~ lognormal(0, 1);
        l2_0 ~ normal(0, 2);
        l2_13 ~ lognormal(0, 1);
        l3_0 ~ normal(0, 2);
        l3_12 ~ lognormal(0, 1);
        l4_0 ~ normal(0, 2);
        l4_11 ~ lognormal(0, 1);
        l5_0 ~ normal(0, 2);
        l5_11 ~ lognormal(0, 1);
        l6_0 ~ normal(0, 2);
        l6_12 ~ lognormal(0, 1);
        l7_0 ~ normal(0, 2);
        l7_11 ~ lognormal(0, 1);
        l8_0 ~ normal(0, 2);
        l8_13 ~ lognormal(0, 1);
        l9_0 ~ normal(0, 2);
        l9_13 ~ lognormal(0, 1);
        l10_0 ~ normal(0, 2);
        l10_13 ~ lognormal(0, 1);
        l11_0 ~ normal(0, 2);
        l11_13 ~ lognormal(0, 1);
        l12_0 ~ normal(0, 2);
        l12_11 ~ lognormal(0, 1);
        l13_0 ~ normal(0, 2);
        l13_14 ~ lognormal(0, 1);
        l14_0 ~ normal(0, 2);
        l14_11 ~ lognormal(0, 1);
        l14_14 ~ lognormal(0, 1);
        l14_214 ~ normal(0, 2);
        l15_0 ~ normal(0, 2);
        l15_11 ~ lognormal(0, 1);
        l15_14 ~ lognormal(0, 1);
        l15_214 ~ normal(0, 2);
        l16_0 ~ normal(0, 2);
        l16_11 ~ lognormal(0, 1);
        l17_0 ~ normal(0, 2);
        l17_11 ~ lognormal(0, 1);
        l18_0 ~ normal(0, 2);
        l18_12 ~ lognormal(0, 1);
        l18_14 ~ lognormal(0, 1);
        l18_224 ~ normal(0, 2);
        l19_0 ~ normal(0, 2);
        l19_11 ~ lognormal(0, 1);
        l19_12 ~ lognormal(0, 1);
        l19_212 ~ normal(0, 2);
        l20_0 ~ normal(0, 2);
        l20_12 ~ lognormal(0, 1);
        l20_14 ~ lognormal(0, 1);
        l20_224 ~ normal(0, 2);
        l21_0 ~ normal(0, 2);
        l21_12 ~ lognormal(0, 1);
        l22_0 ~ normal(0, 2);
        l22_12 ~ lognormal(0, 1);
        l23_0 ~ normal(0, 2);
        l23_11 ~ lognormal(0, 1);
        l24_0 ~ normal(0, 2);
        l24_11 ~ lognormal(0, 1);
        l24_12 ~ lognormal(0, 1);
        l24_212 ~ normal(0, 2);
        l25_0 ~ normal(0, 2);
        l25_11 ~ lognormal(0, 1);
        l25_12 ~ lognormal(0, 1);
        l25_212 ~ normal(0, 2);
        l26_0 ~ normal(0, 2);
        l26_11 ~ lognormal(0, 1);
        l27_0 ~ normal(0, 2);
        l27_11 ~ lognormal(0, 1);
        l27_12 ~ lognormal(0, 1);
        l27_212 ~ normal(0, 2);
      
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

