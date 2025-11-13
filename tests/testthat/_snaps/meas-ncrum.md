# ncrum script works

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
      }
      parameters {
        simplex[C] Vc;
      
        ////////////////////////////////// measurement parameters
        real<lower=0,upper=1> pistar_1;
        real<lower=0,upper=1> rstar_11;
        real<lower=0,upper=1> rstar_12;
        real<lower=0,upper=1> pistar_2;
        real<lower=0,upper=1> rstar_22;
        real<lower=0,upper=1> pistar_3;
        real<lower=0,upper=1> rstar_31;
        real<lower=0,upper=1> rstar_33;
        real<lower=0,upper=1> pistar_4;
        real<lower=0,upper=1> rstar_43;
        real<lower=0,upper=1> pistar_5;
        real<lower=0,upper=1> rstar_53;
        real<lower=0,upper=1> pistar_6;
        real<lower=0,upper=1> rstar_63;
        real<lower=0,upper=1> pistar_7;
        real<lower=0,upper=1> rstar_71;
        real<lower=0,upper=1> rstar_73;
        real<lower=0,upper=1> pistar_8;
        real<lower=0,upper=1> rstar_82;
        real<lower=0,upper=1> pistar_9;
        real<lower=0,upper=1> rstar_93;
        real<lower=0,upper=1> pistar_10;
        real<lower=0,upper=1> rstar_101;
        real<lower=0,upper=1> pistar_11;
        real<lower=0,upper=1> rstar_111;
        real<lower=0,upper=1> rstar_113;
        real<lower=0,upper=1> pistar_12;
        real<lower=0,upper=1> rstar_121;
        real<lower=0,upper=1> rstar_123;
        real<lower=0,upper=1> pistar_13;
        real<lower=0,upper=1> rstar_131;
        real<lower=0,upper=1> pistar_14;
        real<lower=0,upper=1> rstar_141;
        real<lower=0,upper=1> pistar_15;
        real<lower=0,upper=1> rstar_153;
        real<lower=0,upper=1> pistar_16;
        real<lower=0,upper=1> rstar_161;
        real<lower=0,upper=1> rstar_163;
        real<lower=0,upper=1> pistar_17;
        real<lower=0,upper=1> rstar_172;
        real<lower=0,upper=1> rstar_173;
        real<lower=0,upper=1> pistar_18;
        real<lower=0,upper=1> rstar_183;
        real<lower=0,upper=1> pistar_19;
        real<lower=0,upper=1> rstar_193;
        real<lower=0,upper=1> pistar_20;
        real<lower=0,upper=1> rstar_201;
        real<lower=0,upper=1> rstar_203;
        real<lower=0,upper=1> pistar_21;
        real<lower=0,upper=1> rstar_211;
        real<lower=0,upper=1> rstar_213;
        real<lower=0,upper=1> pistar_22;
        real<lower=0,upper=1> rstar_223;
        real<lower=0,upper=1> pistar_23;
        real<lower=0,upper=1> rstar_232;
        real<lower=0,upper=1> pistar_24;
        real<lower=0,upper=1> rstar_242;
        real<lower=0,upper=1> pistar_25;
        real<lower=0,upper=1> rstar_251;
        real<lower=0,upper=1> pistar_26;
        real<lower=0,upper=1> rstar_263;
        real<lower=0,upper=1> pistar_27;
        real<lower=0,upper=1> rstar_271;
        real<lower=0,upper=1> pistar_28;
        real<lower=0,upper=1> rstar_283;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = pistar_1*rstar_11*rstar_12;
        pi[1,2] = pistar_1*rstar_12;
        pi[1,3] = pistar_1*rstar_11;
        pi[1,4] = pistar_1*rstar_11*rstar_12;
        pi[1,5] = pistar_1;
        pi[1,6] = pistar_1*rstar_12;
        pi[1,7] = pistar_1*rstar_11;
        pi[1,8] = pistar_1;
        pi[2,1] = pistar_2*rstar_22;
        pi[2,2] = pistar_2*rstar_22;
        pi[2,3] = pistar_2;
        pi[2,4] = pistar_2*rstar_22;
        pi[2,5] = pistar_2;
        pi[2,6] = pistar_2*rstar_22;
        pi[2,7] = pistar_2;
        pi[2,8] = pistar_2;
        pi[3,1] = pistar_3*rstar_31*rstar_33;
        pi[3,2] = pistar_3*rstar_33;
        pi[3,3] = pistar_3*rstar_31*rstar_33;
        pi[3,4] = pistar_3*rstar_31;
        pi[3,5] = pistar_3*rstar_33;
        pi[3,6] = pistar_3;
        pi[3,7] = pistar_3*rstar_31;
        pi[3,8] = pistar_3;
        pi[4,1] = pistar_4*rstar_43;
        pi[4,2] = pistar_4*rstar_43;
        pi[4,3] = pistar_4*rstar_43;
        pi[4,4] = pistar_4;
        pi[4,5] = pistar_4*rstar_43;
        pi[4,6] = pistar_4;
        pi[4,7] = pistar_4;
        pi[4,8] = pistar_4;
        pi[5,1] = pistar_5*rstar_53;
        pi[5,2] = pistar_5*rstar_53;
        pi[5,3] = pistar_5*rstar_53;
        pi[5,4] = pistar_5;
        pi[5,5] = pistar_5*rstar_53;
        pi[5,6] = pistar_5;
        pi[5,7] = pistar_5;
        pi[5,8] = pistar_5;
        pi[6,1] = pistar_6*rstar_63;
        pi[6,2] = pistar_6*rstar_63;
        pi[6,3] = pistar_6*rstar_63;
        pi[6,4] = pistar_6;
        pi[6,5] = pistar_6*rstar_63;
        pi[6,6] = pistar_6;
        pi[6,7] = pistar_6;
        pi[6,8] = pistar_6;
        pi[7,1] = pistar_7*rstar_71*rstar_73;
        pi[7,2] = pistar_7*rstar_73;
        pi[7,3] = pistar_7*rstar_71*rstar_73;
        pi[7,4] = pistar_7*rstar_71;
        pi[7,5] = pistar_7*rstar_73;
        pi[7,6] = pistar_7;
        pi[7,7] = pistar_7*rstar_71;
        pi[7,8] = pistar_7;
        pi[8,1] = pistar_8*rstar_82;
        pi[8,2] = pistar_8*rstar_82;
        pi[8,3] = pistar_8;
        pi[8,4] = pistar_8*rstar_82;
        pi[8,5] = pistar_8;
        pi[8,6] = pistar_8*rstar_82;
        pi[8,7] = pistar_8;
        pi[8,8] = pistar_8;
        pi[9,1] = pistar_9*rstar_93;
        pi[9,2] = pistar_9*rstar_93;
        pi[9,3] = pistar_9*rstar_93;
        pi[9,4] = pistar_9;
        pi[9,5] = pistar_9*rstar_93;
        pi[9,6] = pistar_9;
        pi[9,7] = pistar_9;
        pi[9,8] = pistar_9;
        pi[10,1] = pistar_10*rstar_101;
        pi[10,2] = pistar_10;
        pi[10,3] = pistar_10*rstar_101;
        pi[10,4] = pistar_10*rstar_101;
        pi[10,5] = pistar_10;
        pi[10,6] = pistar_10;
        pi[10,7] = pistar_10*rstar_101;
        pi[10,8] = pistar_10;
        pi[11,1] = pistar_11*rstar_111*rstar_113;
        pi[11,2] = pistar_11*rstar_113;
        pi[11,3] = pistar_11*rstar_111*rstar_113;
        pi[11,4] = pistar_11*rstar_111;
        pi[11,5] = pistar_11*rstar_113;
        pi[11,6] = pistar_11;
        pi[11,7] = pistar_11*rstar_111;
        pi[11,8] = pistar_11;
        pi[12,1] = pistar_12*rstar_121*rstar_123;
        pi[12,2] = pistar_12*rstar_123;
        pi[12,3] = pistar_12*rstar_121*rstar_123;
        pi[12,4] = pistar_12*rstar_121;
        pi[12,5] = pistar_12*rstar_123;
        pi[12,6] = pistar_12;
        pi[12,7] = pistar_12*rstar_121;
        pi[12,8] = pistar_12;
        pi[13,1] = pistar_13*rstar_131;
        pi[13,2] = pistar_13;
        pi[13,3] = pistar_13*rstar_131;
        pi[13,4] = pistar_13*rstar_131;
        pi[13,5] = pistar_13;
        pi[13,6] = pistar_13;
        pi[13,7] = pistar_13*rstar_131;
        pi[13,8] = pistar_13;
        pi[14,1] = pistar_14*rstar_141;
        pi[14,2] = pistar_14;
        pi[14,3] = pistar_14*rstar_141;
        pi[14,4] = pistar_14*rstar_141;
        pi[14,5] = pistar_14;
        pi[14,6] = pistar_14;
        pi[14,7] = pistar_14*rstar_141;
        pi[14,8] = pistar_14;
        pi[15,1] = pistar_15*rstar_153;
        pi[15,2] = pistar_15*rstar_153;
        pi[15,3] = pistar_15*rstar_153;
        pi[15,4] = pistar_15;
        pi[15,5] = pistar_15*rstar_153;
        pi[15,6] = pistar_15;
        pi[15,7] = pistar_15;
        pi[15,8] = pistar_15;
        pi[16,1] = pistar_16*rstar_161*rstar_163;
        pi[16,2] = pistar_16*rstar_163;
        pi[16,3] = pistar_16*rstar_161*rstar_163;
        pi[16,4] = pistar_16*rstar_161;
        pi[16,5] = pistar_16*rstar_163;
        pi[16,6] = pistar_16;
        pi[16,7] = pistar_16*rstar_161;
        pi[16,8] = pistar_16;
        pi[17,1] = pistar_17*rstar_172*rstar_173;
        pi[17,2] = pistar_17*rstar_172*rstar_173;
        pi[17,3] = pistar_17*rstar_173;
        pi[17,4] = pistar_17*rstar_172;
        pi[17,5] = pistar_17*rstar_173;
        pi[17,6] = pistar_17*rstar_172;
        pi[17,7] = pistar_17;
        pi[17,8] = pistar_17;
        pi[18,1] = pistar_18*rstar_183;
        pi[18,2] = pistar_18*rstar_183;
        pi[18,3] = pistar_18*rstar_183;
        pi[18,4] = pistar_18;
        pi[18,5] = pistar_18*rstar_183;
        pi[18,6] = pistar_18;
        pi[18,7] = pistar_18;
        pi[18,8] = pistar_18;
        pi[19,1] = pistar_19*rstar_193;
        pi[19,2] = pistar_19*rstar_193;
        pi[19,3] = pistar_19*rstar_193;
        pi[19,4] = pistar_19;
        pi[19,5] = pistar_19*rstar_193;
        pi[19,6] = pistar_19;
        pi[19,7] = pistar_19;
        pi[19,8] = pistar_19;
        pi[20,1] = pistar_20*rstar_201*rstar_203;
        pi[20,2] = pistar_20*rstar_203;
        pi[20,3] = pistar_20*rstar_201*rstar_203;
        pi[20,4] = pistar_20*rstar_201;
        pi[20,5] = pistar_20*rstar_203;
        pi[20,6] = pistar_20;
        pi[20,7] = pistar_20*rstar_201;
        pi[20,8] = pistar_20;
        pi[21,1] = pistar_21*rstar_211*rstar_213;
        pi[21,2] = pistar_21*rstar_213;
        pi[21,3] = pistar_21*rstar_211*rstar_213;
        pi[21,4] = pistar_21*rstar_211;
        pi[21,5] = pistar_21*rstar_213;
        pi[21,6] = pistar_21;
        pi[21,7] = pistar_21*rstar_211;
        pi[21,8] = pistar_21;
        pi[22,1] = pistar_22*rstar_223;
        pi[22,2] = pistar_22*rstar_223;
        pi[22,3] = pistar_22*rstar_223;
        pi[22,4] = pistar_22;
        pi[22,5] = pistar_22*rstar_223;
        pi[22,6] = pistar_22;
        pi[22,7] = pistar_22;
        pi[22,8] = pistar_22;
        pi[23,1] = pistar_23*rstar_232;
        pi[23,2] = pistar_23*rstar_232;
        pi[23,3] = pistar_23;
        pi[23,4] = pistar_23*rstar_232;
        pi[23,5] = pistar_23;
        pi[23,6] = pistar_23*rstar_232;
        pi[23,7] = pistar_23;
        pi[23,8] = pistar_23;
        pi[24,1] = pistar_24*rstar_242;
        pi[24,2] = pistar_24*rstar_242;
        pi[24,3] = pistar_24;
        pi[24,4] = pistar_24*rstar_242;
        pi[24,5] = pistar_24;
        pi[24,6] = pistar_24*rstar_242;
        pi[24,7] = pistar_24;
        pi[24,8] = pistar_24;
        pi[25,1] = pistar_25*rstar_251;
        pi[25,2] = pistar_25;
        pi[25,3] = pistar_25*rstar_251;
        pi[25,4] = pistar_25*rstar_251;
        pi[25,5] = pistar_25;
        pi[25,6] = pistar_25;
        pi[25,7] = pistar_25*rstar_251;
        pi[25,8] = pistar_25;
        pi[26,1] = pistar_26*rstar_263;
        pi[26,2] = pistar_26*rstar_263;
        pi[26,3] = pistar_26*rstar_263;
        pi[26,4] = pistar_26;
        pi[26,5] = pistar_26*rstar_263;
        pi[26,6] = pistar_26;
        pi[26,7] = pistar_26;
        pi[26,8] = pistar_26;
        pi[27,1] = pistar_27*rstar_271;
        pi[27,2] = pistar_27;
        pi[27,3] = pistar_27*rstar_271;
        pi[27,4] = pistar_27*rstar_271;
        pi[27,5] = pistar_27;
        pi[27,6] = pistar_27;
        pi[27,7] = pistar_27*rstar_271;
        pi[27,8] = pistar_27;
        pi[28,1] = pistar_28*rstar_283;
        pi[28,2] = pistar_28*rstar_283;
        pi[28,3] = pistar_28*rstar_283;
        pi[28,4] = pistar_28;
        pi[28,5] = pistar_28*rstar_283;
        pi[28,6] = pistar_28;
        pi[28,7] = pistar_28;
        pi[28,8] = pistar_28;
      }
      model {
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        pistar_1 ~ beta(15, 3);
        rstar_11 ~ beta(2, 2);
        rstar_12 ~ beta(2, 2);
        pistar_2 ~ beta(15, 3);
        rstar_22 ~ beta(2, 2);
        pistar_3 ~ beta(15, 3);
        rstar_31 ~ beta(2, 2);
        rstar_33 ~ beta(2, 2);
        pistar_4 ~ beta(15, 3);
        rstar_43 ~ beta(2, 2);
        pistar_5 ~ beta(15, 3);
        rstar_53 ~ beta(2, 2);
        pistar_6 ~ beta(15, 3);
        rstar_63 ~ beta(2, 2);
        pistar_7 ~ beta(15, 3);
        rstar_71 ~ beta(2, 2);
        rstar_73 ~ beta(2, 2);
        pistar_8 ~ beta(15, 3);
        rstar_82 ~ beta(2, 2);
        pistar_9 ~ beta(15, 3);
        rstar_93 ~ beta(2, 2);
        pistar_10 ~ beta(15, 3);
        rstar_101 ~ beta(2, 2);
        pistar_11 ~ beta(15, 3);
        rstar_111 ~ beta(2, 2);
        rstar_113 ~ beta(2, 2);
        pistar_12 ~ beta(15, 3);
        rstar_121 ~ beta(2, 2);
        rstar_123 ~ beta(2, 2);
        pistar_13 ~ beta(15, 3);
        rstar_131 ~ beta(2, 2);
        pistar_14 ~ beta(15, 3);
        rstar_141 ~ beta(2, 2);
        pistar_15 ~ beta(15, 3);
        rstar_153 ~ beta(2, 2);
        pistar_16 ~ beta(15, 3);
        rstar_161 ~ beta(2, 2);
        rstar_163 ~ beta(2, 2);
        pistar_17 ~ beta(15, 3);
        rstar_172 ~ beta(2, 2);
        rstar_173 ~ beta(2, 2);
        pistar_18 ~ beta(15, 3);
        rstar_183 ~ beta(2, 2);
        pistar_19 ~ beta(15, 3);
        rstar_193 ~ beta(2, 2);
        pistar_20 ~ beta(15, 3);
        rstar_201 ~ beta(2, 2);
        rstar_203 ~ beta(2, 2);
        pistar_21 ~ beta(15, 3);
        rstar_211 ~ beta(2, 2);
        rstar_213 ~ beta(2, 2);
        pistar_22 ~ beta(15, 3);
        rstar_223 ~ beta(2, 2);
        pistar_23 ~ beta(15, 3);
        rstar_232 ~ beta(2, 2);
        pistar_24 ~ beta(15, 3);
        rstar_242 ~ beta(2, 2);
        pistar_25 ~ beta(15, 3);
        rstar_251 ~ beta(2, 2);
        pistar_26 ~ beta(15, 3);
        rstar_263 ~ beta(2, 2);
        pistar_27 ~ beta(15, 3);
        rstar_271 ~ beta(2, 2);
        pistar_28 ~ beta(15, 3);
        rstar_283 ~ beta(2, 2);
      
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
      }
      parameters {
        simplex[C] Vc;
      
        ////////////////////////////////// measurement parameters
        real<lower=0,upper=1> pistar_1;
        real<lower=0,upper=1> rstar_11;
        real<lower=0,upper=1> pistar_2;
        real<lower=0,upper=1> rstar_21;
        real<lower=0,upper=1> pistar_3;
        real<lower=0,upper=1> rstar_31;
        real<lower=0,upper=1> pistar_4;
        real<lower=0,upper=1> rstar_41;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = pistar_1*rstar_11;
        pi[1,2] = pistar_1;
        pi[2,1] = pistar_2*rstar_21;
        pi[2,2] = pistar_2;
        pi[3,1] = pistar_3*rstar_31;
        pi[3,2] = pistar_3;
        pi[4,1] = pistar_4*rstar_41;
        pi[4,2] = pistar_4;
      }
      model {
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        pistar_1 ~ beta(15, 3);
        rstar_11 ~ beta(2, 2);
        pistar_2 ~ beta(15, 3);
        rstar_21 ~ beta(2, 2);
        pistar_3 ~ beta(15, 3);
        rstar_31 ~ beta(2, 2);
        pistar_4 ~ beta(15, 3);
        rstar_41 ~ beta(2, 2);
      
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
      }
      parameters {
        simplex[C] Vc;
      
        ////////////////////////////////// measurement parameters
        real<lower=0,upper=1> pistar_1;
        real<lower=0,upper=1> rstar_11;
        real<lower=0,upper=1> pistar_2;
        real<lower=0,upper=1> rstar_23;
        real<lower=0,upper=1> pistar_3;
        real<lower=0,upper=1> rstar_32;
        real<lower=0,upper=1> pistar_4;
        real<lower=0,upper=1> rstar_41;
        real<lower=0,upper=1> pistar_5;
        real<lower=0,upper=1> rstar_51;
        real<lower=0,upper=1> pistar_6;
        real<lower=0,upper=1> rstar_62;
        real<lower=0,upper=1> pistar_7;
        real<lower=0,upper=1> rstar_71;
        real<lower=0,upper=1> pistar_8;
        real<lower=0,upper=1> rstar_83;
        real<lower=0,upper=1> pistar_9;
        real<lower=0,upper=1> rstar_93;
        real<lower=0,upper=1> pistar_10;
        real<lower=0,upper=1> rstar_103;
        real<lower=0,upper=1> pistar_11;
        real<lower=0,upper=1> rstar_113;
        real<lower=0,upper=1> pistar_12;
        real<lower=0,upper=1> rstar_121;
        real<lower=0,upper=1> pistar_13;
        real<lower=0,upper=1> rstar_134;
        real<lower=0,upper=1> pistar_14;
        real<lower=0,upper=1> rstar_141;
        real<lower=0,upper=1> rstar_144;
        real<lower=0,upper=1> pistar_15;
        real<lower=0,upper=1> rstar_151;
        real<lower=0,upper=1> rstar_154;
        real<lower=0,upper=1> pistar_16;
        real<lower=0,upper=1> rstar_161;
        real<lower=0,upper=1> pistar_17;
        real<lower=0,upper=1> rstar_171;
        real<lower=0,upper=1> pistar_18;
        real<lower=0,upper=1> rstar_182;
        real<lower=0,upper=1> rstar_184;
        real<lower=0,upper=1> pistar_19;
        real<lower=0,upper=1> rstar_191;
        real<lower=0,upper=1> rstar_192;
        real<lower=0,upper=1> pistar_20;
        real<lower=0,upper=1> rstar_202;
        real<lower=0,upper=1> rstar_204;
        real<lower=0,upper=1> pistar_21;
        real<lower=0,upper=1> rstar_212;
        real<lower=0,upper=1> pistar_22;
        real<lower=0,upper=1> rstar_222;
        real<lower=0,upper=1> pistar_23;
        real<lower=0,upper=1> rstar_231;
        real<lower=0,upper=1> pistar_24;
        real<lower=0,upper=1> rstar_241;
        real<lower=0,upper=1> rstar_242;
        real<lower=0,upper=1> pistar_25;
        real<lower=0,upper=1> rstar_251;
        real<lower=0,upper=1> rstar_252;
        real<lower=0,upper=1> pistar_26;
        real<lower=0,upper=1> rstar_261;
        real<lower=0,upper=1> pistar_27;
        real<lower=0,upper=1> rstar_271;
        real<lower=0,upper=1> rstar_272;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = pistar_1*rstar_11;
        pi[1,2] = pistar_1;
        pi[1,3] = pistar_1*rstar_11;
        pi[1,4] = pistar_1*rstar_11;
        pi[1,5] = pistar_1*rstar_11;
        pi[1,6] = pistar_1;
        pi[1,7] = pistar_1;
        pi[1,8] = pistar_1;
        pi[1,9] = pistar_1*rstar_11;
        pi[1,10] = pistar_1*rstar_11;
        pi[1,11] = pistar_1*rstar_11;
        pi[1,12] = pistar_1;
        pi[1,13] = pistar_1;
        pi[1,14] = pistar_1;
        pi[1,15] = pistar_1*rstar_11;
        pi[1,16] = pistar_1;
        pi[2,1] = pistar_2*rstar_23;
        pi[2,2] = pistar_2*rstar_23;
        pi[2,3] = pistar_2*rstar_23;
        pi[2,4] = pistar_2;
        pi[2,5] = pistar_2*rstar_23;
        pi[2,6] = pistar_2*rstar_23;
        pi[2,7] = pistar_2;
        pi[2,8] = pistar_2*rstar_23;
        pi[2,9] = pistar_2;
        pi[2,10] = pistar_2*rstar_23;
        pi[2,11] = pistar_2;
        pi[2,12] = pistar_2;
        pi[2,13] = pistar_2*rstar_23;
        pi[2,14] = pistar_2;
        pi[2,15] = pistar_2;
        pi[2,16] = pistar_2;
        pi[3,1] = pistar_3*rstar_32;
        pi[3,2] = pistar_3*rstar_32;
        pi[3,3] = pistar_3;
        pi[3,4] = pistar_3*rstar_32;
        pi[3,5] = pistar_3*rstar_32;
        pi[3,6] = pistar_3;
        pi[3,7] = pistar_3*rstar_32;
        pi[3,8] = pistar_3*rstar_32;
        pi[3,9] = pistar_3;
        pi[3,10] = pistar_3;
        pi[3,11] = pistar_3*rstar_32;
        pi[3,12] = pistar_3;
        pi[3,13] = pistar_3;
        pi[3,14] = pistar_3*rstar_32;
        pi[3,15] = pistar_3;
        pi[3,16] = pistar_3;
        pi[4,1] = pistar_4*rstar_41;
        pi[4,2] = pistar_4;
        pi[4,3] = pistar_4*rstar_41;
        pi[4,4] = pistar_4*rstar_41;
        pi[4,5] = pistar_4*rstar_41;
        pi[4,6] = pistar_4;
        pi[4,7] = pistar_4;
        pi[4,8] = pistar_4;
        pi[4,9] = pistar_4*rstar_41;
        pi[4,10] = pistar_4*rstar_41;
        pi[4,11] = pistar_4*rstar_41;
        pi[4,12] = pistar_4;
        pi[4,13] = pistar_4;
        pi[4,14] = pistar_4;
        pi[4,15] = pistar_4*rstar_41;
        pi[4,16] = pistar_4;
        pi[5,1] = pistar_5*rstar_51;
        pi[5,2] = pistar_5;
        pi[5,3] = pistar_5*rstar_51;
        pi[5,4] = pistar_5*rstar_51;
        pi[5,5] = pistar_5*rstar_51;
        pi[5,6] = pistar_5;
        pi[5,7] = pistar_5;
        pi[5,8] = pistar_5;
        pi[5,9] = pistar_5*rstar_51;
        pi[5,10] = pistar_5*rstar_51;
        pi[5,11] = pistar_5*rstar_51;
        pi[5,12] = pistar_5;
        pi[5,13] = pistar_5;
        pi[5,14] = pistar_5;
        pi[5,15] = pistar_5*rstar_51;
        pi[5,16] = pistar_5;
        pi[6,1] = pistar_6*rstar_62;
        pi[6,2] = pistar_6*rstar_62;
        pi[6,3] = pistar_6;
        pi[6,4] = pistar_6*rstar_62;
        pi[6,5] = pistar_6*rstar_62;
        pi[6,6] = pistar_6;
        pi[6,7] = pistar_6*rstar_62;
        pi[6,8] = pistar_6*rstar_62;
        pi[6,9] = pistar_6;
        pi[6,10] = pistar_6;
        pi[6,11] = pistar_6*rstar_62;
        pi[6,12] = pistar_6;
        pi[6,13] = pistar_6;
        pi[6,14] = pistar_6*rstar_62;
        pi[6,15] = pistar_6;
        pi[6,16] = pistar_6;
        pi[7,1] = pistar_7*rstar_71;
        pi[7,2] = pistar_7;
        pi[7,3] = pistar_7*rstar_71;
        pi[7,4] = pistar_7*rstar_71;
        pi[7,5] = pistar_7*rstar_71;
        pi[7,6] = pistar_7;
        pi[7,7] = pistar_7;
        pi[7,8] = pistar_7;
        pi[7,9] = pistar_7*rstar_71;
        pi[7,10] = pistar_7*rstar_71;
        pi[7,11] = pistar_7*rstar_71;
        pi[7,12] = pistar_7;
        pi[7,13] = pistar_7;
        pi[7,14] = pistar_7;
        pi[7,15] = pistar_7*rstar_71;
        pi[7,16] = pistar_7;
        pi[8,1] = pistar_8*rstar_83;
        pi[8,2] = pistar_8*rstar_83;
        pi[8,3] = pistar_8*rstar_83;
        pi[8,4] = pistar_8;
        pi[8,5] = pistar_8*rstar_83;
        pi[8,6] = pistar_8*rstar_83;
        pi[8,7] = pistar_8;
        pi[8,8] = pistar_8*rstar_83;
        pi[8,9] = pistar_8;
        pi[8,10] = pistar_8*rstar_83;
        pi[8,11] = pistar_8;
        pi[8,12] = pistar_8;
        pi[8,13] = pistar_8*rstar_83;
        pi[8,14] = pistar_8;
        pi[8,15] = pistar_8;
        pi[8,16] = pistar_8;
        pi[9,1] = pistar_9*rstar_93;
        pi[9,2] = pistar_9*rstar_93;
        pi[9,3] = pistar_9*rstar_93;
        pi[9,4] = pistar_9;
        pi[9,5] = pistar_9*rstar_93;
        pi[9,6] = pistar_9*rstar_93;
        pi[9,7] = pistar_9;
        pi[9,8] = pistar_9*rstar_93;
        pi[9,9] = pistar_9;
        pi[9,10] = pistar_9*rstar_93;
        pi[9,11] = pistar_9;
        pi[9,12] = pistar_9;
        pi[9,13] = pistar_9*rstar_93;
        pi[9,14] = pistar_9;
        pi[9,15] = pistar_9;
        pi[9,16] = pistar_9;
        pi[10,1] = pistar_10*rstar_103;
        pi[10,2] = pistar_10*rstar_103;
        pi[10,3] = pistar_10*rstar_103;
        pi[10,4] = pistar_10;
        pi[10,5] = pistar_10*rstar_103;
        pi[10,6] = pistar_10*rstar_103;
        pi[10,7] = pistar_10;
        pi[10,8] = pistar_10*rstar_103;
        pi[10,9] = pistar_10;
        pi[10,10] = pistar_10*rstar_103;
        pi[10,11] = pistar_10;
        pi[10,12] = pistar_10;
        pi[10,13] = pistar_10*rstar_103;
        pi[10,14] = pistar_10;
        pi[10,15] = pistar_10;
        pi[10,16] = pistar_10;
        pi[11,1] = pistar_11*rstar_113;
        pi[11,2] = pistar_11*rstar_113;
        pi[11,3] = pistar_11*rstar_113;
        pi[11,4] = pistar_11;
        pi[11,5] = pistar_11*rstar_113;
        pi[11,6] = pistar_11*rstar_113;
        pi[11,7] = pistar_11;
        pi[11,8] = pistar_11*rstar_113;
        pi[11,9] = pistar_11;
        pi[11,10] = pistar_11*rstar_113;
        pi[11,11] = pistar_11;
        pi[11,12] = pistar_11;
        pi[11,13] = pistar_11*rstar_113;
        pi[11,14] = pistar_11;
        pi[11,15] = pistar_11;
        pi[11,16] = pistar_11;
        pi[12,1] = pistar_12*rstar_121;
        pi[12,2] = pistar_12;
        pi[12,3] = pistar_12*rstar_121;
        pi[12,4] = pistar_12*rstar_121;
        pi[12,5] = pistar_12*rstar_121;
        pi[12,6] = pistar_12;
        pi[12,7] = pistar_12;
        pi[12,8] = pistar_12;
        pi[12,9] = pistar_12*rstar_121;
        pi[12,10] = pistar_12*rstar_121;
        pi[12,11] = pistar_12*rstar_121;
        pi[12,12] = pistar_12;
        pi[12,13] = pistar_12;
        pi[12,14] = pistar_12;
        pi[12,15] = pistar_12*rstar_121;
        pi[12,16] = pistar_12;
        pi[13,1] = pistar_13*rstar_134;
        pi[13,2] = pistar_13*rstar_134;
        pi[13,3] = pistar_13*rstar_134;
        pi[13,4] = pistar_13*rstar_134;
        pi[13,5] = pistar_13;
        pi[13,6] = pistar_13*rstar_134;
        pi[13,7] = pistar_13*rstar_134;
        pi[13,8] = pistar_13;
        pi[13,9] = pistar_13*rstar_134;
        pi[13,10] = pistar_13;
        pi[13,11] = pistar_13;
        pi[13,12] = pistar_13*rstar_134;
        pi[13,13] = pistar_13;
        pi[13,14] = pistar_13;
        pi[13,15] = pistar_13;
        pi[13,16] = pistar_13;
        pi[14,1] = pistar_14*rstar_141*rstar_144;
        pi[14,2] = pistar_14*rstar_144;
        pi[14,3] = pistar_14*rstar_141*rstar_144;
        pi[14,4] = pistar_14*rstar_141*rstar_144;
        pi[14,5] = pistar_14*rstar_141;
        pi[14,6] = pistar_14*rstar_144;
        pi[14,7] = pistar_14*rstar_144;
        pi[14,8] = pistar_14;
        pi[14,9] = pistar_14*rstar_141*rstar_144;
        pi[14,10] = pistar_14*rstar_141;
        pi[14,11] = pistar_14*rstar_141;
        pi[14,12] = pistar_14*rstar_144;
        pi[14,13] = pistar_14;
        pi[14,14] = pistar_14;
        pi[14,15] = pistar_14*rstar_141;
        pi[14,16] = pistar_14;
        pi[15,1] = pistar_15*rstar_151*rstar_154;
        pi[15,2] = pistar_15*rstar_154;
        pi[15,3] = pistar_15*rstar_151*rstar_154;
        pi[15,4] = pistar_15*rstar_151*rstar_154;
        pi[15,5] = pistar_15*rstar_151;
        pi[15,6] = pistar_15*rstar_154;
        pi[15,7] = pistar_15*rstar_154;
        pi[15,8] = pistar_15;
        pi[15,9] = pistar_15*rstar_151*rstar_154;
        pi[15,10] = pistar_15*rstar_151;
        pi[15,11] = pistar_15*rstar_151;
        pi[15,12] = pistar_15*rstar_154;
        pi[15,13] = pistar_15;
        pi[15,14] = pistar_15;
        pi[15,15] = pistar_15*rstar_151;
        pi[15,16] = pistar_15;
        pi[16,1] = pistar_16*rstar_161;
        pi[16,2] = pistar_16;
        pi[16,3] = pistar_16*rstar_161;
        pi[16,4] = pistar_16*rstar_161;
        pi[16,5] = pistar_16*rstar_161;
        pi[16,6] = pistar_16;
        pi[16,7] = pistar_16;
        pi[16,8] = pistar_16;
        pi[16,9] = pistar_16*rstar_161;
        pi[16,10] = pistar_16*rstar_161;
        pi[16,11] = pistar_16*rstar_161;
        pi[16,12] = pistar_16;
        pi[16,13] = pistar_16;
        pi[16,14] = pistar_16;
        pi[16,15] = pistar_16*rstar_161;
        pi[16,16] = pistar_16;
        pi[17,1] = pistar_17*rstar_171;
        pi[17,2] = pistar_17;
        pi[17,3] = pistar_17*rstar_171;
        pi[17,4] = pistar_17*rstar_171;
        pi[17,5] = pistar_17*rstar_171;
        pi[17,6] = pistar_17;
        pi[17,7] = pistar_17;
        pi[17,8] = pistar_17;
        pi[17,9] = pistar_17*rstar_171;
        pi[17,10] = pistar_17*rstar_171;
        pi[17,11] = pistar_17*rstar_171;
        pi[17,12] = pistar_17;
        pi[17,13] = pistar_17;
        pi[17,14] = pistar_17;
        pi[17,15] = pistar_17*rstar_171;
        pi[17,16] = pistar_17;
        pi[18,1] = pistar_18*rstar_182*rstar_184;
        pi[18,2] = pistar_18*rstar_182*rstar_184;
        pi[18,3] = pistar_18*rstar_184;
        pi[18,4] = pistar_18*rstar_182*rstar_184;
        pi[18,5] = pistar_18*rstar_182;
        pi[18,6] = pistar_18*rstar_184;
        pi[18,7] = pistar_18*rstar_182*rstar_184;
        pi[18,8] = pistar_18*rstar_182;
        pi[18,9] = pistar_18*rstar_184;
        pi[18,10] = pistar_18;
        pi[18,11] = pistar_18*rstar_182;
        pi[18,12] = pistar_18*rstar_184;
        pi[18,13] = pistar_18;
        pi[18,14] = pistar_18*rstar_182;
        pi[18,15] = pistar_18;
        pi[18,16] = pistar_18;
        pi[19,1] = pistar_19*rstar_191*rstar_192;
        pi[19,2] = pistar_19*rstar_192;
        pi[19,3] = pistar_19*rstar_191;
        pi[19,4] = pistar_19*rstar_191*rstar_192;
        pi[19,5] = pistar_19*rstar_191*rstar_192;
        pi[19,6] = pistar_19;
        pi[19,7] = pistar_19*rstar_192;
        pi[19,8] = pistar_19*rstar_192;
        pi[19,9] = pistar_19*rstar_191;
        pi[19,10] = pistar_19*rstar_191;
        pi[19,11] = pistar_19*rstar_191*rstar_192;
        pi[19,12] = pistar_19;
        pi[19,13] = pistar_19;
        pi[19,14] = pistar_19*rstar_192;
        pi[19,15] = pistar_19*rstar_191;
        pi[19,16] = pistar_19;
        pi[20,1] = pistar_20*rstar_202*rstar_204;
        pi[20,2] = pistar_20*rstar_202*rstar_204;
        pi[20,3] = pistar_20*rstar_204;
        pi[20,4] = pistar_20*rstar_202*rstar_204;
        pi[20,5] = pistar_20*rstar_202;
        pi[20,6] = pistar_20*rstar_204;
        pi[20,7] = pistar_20*rstar_202*rstar_204;
        pi[20,8] = pistar_20*rstar_202;
        pi[20,9] = pistar_20*rstar_204;
        pi[20,10] = pistar_20;
        pi[20,11] = pistar_20*rstar_202;
        pi[20,12] = pistar_20*rstar_204;
        pi[20,13] = pistar_20;
        pi[20,14] = pistar_20*rstar_202;
        pi[20,15] = pistar_20;
        pi[20,16] = pistar_20;
        pi[21,1] = pistar_21*rstar_212;
        pi[21,2] = pistar_21*rstar_212;
        pi[21,3] = pistar_21;
        pi[21,4] = pistar_21*rstar_212;
        pi[21,5] = pistar_21*rstar_212;
        pi[21,6] = pistar_21;
        pi[21,7] = pistar_21*rstar_212;
        pi[21,8] = pistar_21*rstar_212;
        pi[21,9] = pistar_21;
        pi[21,10] = pistar_21;
        pi[21,11] = pistar_21*rstar_212;
        pi[21,12] = pistar_21;
        pi[21,13] = pistar_21;
        pi[21,14] = pistar_21*rstar_212;
        pi[21,15] = pistar_21;
        pi[21,16] = pistar_21;
        pi[22,1] = pistar_22*rstar_222;
        pi[22,2] = pistar_22*rstar_222;
        pi[22,3] = pistar_22;
        pi[22,4] = pistar_22*rstar_222;
        pi[22,5] = pistar_22*rstar_222;
        pi[22,6] = pistar_22;
        pi[22,7] = pistar_22*rstar_222;
        pi[22,8] = pistar_22*rstar_222;
        pi[22,9] = pistar_22;
        pi[22,10] = pistar_22;
        pi[22,11] = pistar_22*rstar_222;
        pi[22,12] = pistar_22;
        pi[22,13] = pistar_22;
        pi[22,14] = pistar_22*rstar_222;
        pi[22,15] = pistar_22;
        pi[22,16] = pistar_22;
        pi[23,1] = pistar_23*rstar_231;
        pi[23,2] = pistar_23;
        pi[23,3] = pistar_23*rstar_231;
        pi[23,4] = pistar_23*rstar_231;
        pi[23,5] = pistar_23*rstar_231;
        pi[23,6] = pistar_23;
        pi[23,7] = pistar_23;
        pi[23,8] = pistar_23;
        pi[23,9] = pistar_23*rstar_231;
        pi[23,10] = pistar_23*rstar_231;
        pi[23,11] = pistar_23*rstar_231;
        pi[23,12] = pistar_23;
        pi[23,13] = pistar_23;
        pi[23,14] = pistar_23;
        pi[23,15] = pistar_23*rstar_231;
        pi[23,16] = pistar_23;
        pi[24,1] = pistar_24*rstar_241*rstar_242;
        pi[24,2] = pistar_24*rstar_242;
        pi[24,3] = pistar_24*rstar_241;
        pi[24,4] = pistar_24*rstar_241*rstar_242;
        pi[24,5] = pistar_24*rstar_241*rstar_242;
        pi[24,6] = pistar_24;
        pi[24,7] = pistar_24*rstar_242;
        pi[24,8] = pistar_24*rstar_242;
        pi[24,9] = pistar_24*rstar_241;
        pi[24,10] = pistar_24*rstar_241;
        pi[24,11] = pistar_24*rstar_241*rstar_242;
        pi[24,12] = pistar_24;
        pi[24,13] = pistar_24;
        pi[24,14] = pistar_24*rstar_242;
        pi[24,15] = pistar_24*rstar_241;
        pi[24,16] = pistar_24;
        pi[25,1] = pistar_25*rstar_251*rstar_252;
        pi[25,2] = pistar_25*rstar_252;
        pi[25,3] = pistar_25*rstar_251;
        pi[25,4] = pistar_25*rstar_251*rstar_252;
        pi[25,5] = pistar_25*rstar_251*rstar_252;
        pi[25,6] = pistar_25;
        pi[25,7] = pistar_25*rstar_252;
        pi[25,8] = pistar_25*rstar_252;
        pi[25,9] = pistar_25*rstar_251;
        pi[25,10] = pistar_25*rstar_251;
        pi[25,11] = pistar_25*rstar_251*rstar_252;
        pi[25,12] = pistar_25;
        pi[25,13] = pistar_25;
        pi[25,14] = pistar_25*rstar_252;
        pi[25,15] = pistar_25*rstar_251;
        pi[25,16] = pistar_25;
        pi[26,1] = pistar_26*rstar_261;
        pi[26,2] = pistar_26;
        pi[26,3] = pistar_26*rstar_261;
        pi[26,4] = pistar_26*rstar_261;
        pi[26,5] = pistar_26*rstar_261;
        pi[26,6] = pistar_26;
        pi[26,7] = pistar_26;
        pi[26,8] = pistar_26;
        pi[26,9] = pistar_26*rstar_261;
        pi[26,10] = pistar_26*rstar_261;
        pi[26,11] = pistar_26*rstar_261;
        pi[26,12] = pistar_26;
        pi[26,13] = pistar_26;
        pi[26,14] = pistar_26;
        pi[26,15] = pistar_26*rstar_261;
        pi[26,16] = pistar_26;
        pi[27,1] = pistar_27*rstar_271*rstar_272;
        pi[27,2] = pistar_27*rstar_272;
        pi[27,3] = pistar_27*rstar_271;
        pi[27,4] = pistar_27*rstar_271*rstar_272;
        pi[27,5] = pistar_27*rstar_271*rstar_272;
        pi[27,6] = pistar_27;
        pi[27,7] = pistar_27*rstar_272;
        pi[27,8] = pistar_27*rstar_272;
        pi[27,9] = pistar_27*rstar_271;
        pi[27,10] = pistar_27*rstar_271;
        pi[27,11] = pistar_27*rstar_271*rstar_272;
        pi[27,12] = pistar_27;
        pi[27,13] = pistar_27;
        pi[27,14] = pistar_27*rstar_272;
        pi[27,15] = pistar_27*rstar_271;
        pi[27,16] = pistar_27;
      }
      model {
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        pistar_1 ~ beta(15, 3);
        rstar_11 ~ beta(2, 2);
        pistar_2 ~ beta(15, 3);
        rstar_23 ~ beta(2, 2);
        pistar_3 ~ beta(15, 3);
        rstar_32 ~ beta(2, 2);
        pistar_4 ~ beta(15, 3);
        rstar_41 ~ beta(2, 2);
        pistar_5 ~ beta(15, 3);
        rstar_51 ~ beta(2, 2);
        pistar_6 ~ beta(15, 3);
        rstar_62 ~ beta(2, 2);
        pistar_7 ~ beta(15, 3);
        rstar_71 ~ beta(2, 2);
        pistar_8 ~ beta(15, 3);
        rstar_83 ~ beta(2, 2);
        pistar_9 ~ beta(15, 3);
        rstar_93 ~ beta(2, 2);
        pistar_10 ~ beta(15, 3);
        rstar_103 ~ beta(2, 2);
        pistar_11 ~ beta(15, 3);
        rstar_113 ~ beta(2, 2);
        pistar_12 ~ beta(15, 3);
        rstar_121 ~ beta(2, 2);
        pistar_13 ~ beta(15, 3);
        rstar_134 ~ beta(2, 2);
        pistar_14 ~ beta(15, 3);
        rstar_141 ~ beta(2, 2);
        rstar_144 ~ beta(2, 2);
        pistar_15 ~ beta(15, 3);
        rstar_151 ~ beta(2, 2);
        rstar_154 ~ beta(2, 2);
        pistar_16 ~ beta(15, 3);
        rstar_161 ~ beta(2, 2);
        pistar_17 ~ beta(15, 3);
        rstar_171 ~ beta(2, 2);
        pistar_18 ~ beta(15, 3);
        rstar_182 ~ beta(2, 2);
        rstar_184 ~ beta(2, 2);
        pistar_19 ~ beta(15, 3);
        rstar_191 ~ beta(2, 2);
        rstar_192 ~ beta(2, 2);
        pistar_20 ~ beta(15, 3);
        rstar_202 ~ beta(2, 2);
        rstar_204 ~ beta(2, 2);
        pistar_21 ~ beta(15, 3);
        rstar_212 ~ beta(2, 2);
        pistar_22 ~ beta(15, 3);
        rstar_222 ~ beta(2, 2);
        pistar_23 ~ beta(15, 3);
        rstar_231 ~ beta(2, 2);
        pistar_24 ~ beta(15, 3);
        rstar_241 ~ beta(2, 2);
        rstar_242 ~ beta(2, 2);
        pistar_25 ~ beta(15, 3);
        rstar_251 ~ beta(2, 2);
        rstar_252 ~ beta(2, 2);
        pistar_26 ~ beta(15, 3);
        rstar_261 ~ beta(2, 2);
        pistar_27 ~ beta(15, 3);
        rstar_271 ~ beta(2, 2);
        rstar_272 ~ beta(2, 2);
      
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
      
        ////////////////////////////////// measurement parameters
        real<lower=0,upper=1> pistar_1;
        real<lower=0,upper=1> rstar_11;
        real<lower=0,upper=1> rstar_12;
        real<lower=0,upper=1> pistar_2;
        real<lower=0,upper=1> rstar_22;
        real<lower=0,upper=1> pistar_3;
        real<lower=0,upper=1> rstar_31;
        real<lower=0,upper=1> rstar_33;
        real<lower=0,upper=1> pistar_4;
        real<lower=0,upper=1> rstar_43;
        real<lower=0,upper=1> pistar_5;
        real<lower=0,upper=1> rstar_53;
        real<lower=0,upper=1> pistar_6;
        real<lower=0,upper=1> rstar_63;
        real<lower=0,upper=1> pistar_7;
        real<lower=0,upper=1> rstar_71;
        real<lower=0,upper=1> rstar_73;
        real<lower=0,upper=1> pistar_8;
        real<lower=0,upper=1> rstar_82;
        real<lower=0,upper=1> pistar_9;
        real<lower=0,upper=1> rstar_93;
        real<lower=0,upper=1> pistar_10;
        real<lower=0,upper=1> rstar_101;
        real<lower=0,upper=1> pistar_11;
        real<lower=0,upper=1> rstar_111;
        real<lower=0,upper=1> rstar_113;
        real<lower=0,upper=1> pistar_12;
        real<lower=0,upper=1> rstar_121;
        real<lower=0,upper=1> rstar_123;
        real<lower=0,upper=1> pistar_13;
        real<lower=0,upper=1> rstar_131;
        real<lower=0,upper=1> pistar_14;
        real<lower=0,upper=1> rstar_141;
        real<lower=0,upper=1> pistar_15;
        real<lower=0,upper=1> rstar_153;
        real<lower=0,upper=1> pistar_16;
        real<lower=0,upper=1> rstar_161;
        real<lower=0,upper=1> rstar_163;
        real<lower=0,upper=1> pistar_17;
        real<lower=0,upper=1> rstar_172;
        real<lower=0,upper=1> rstar_173;
        real<lower=0,upper=1> pistar_18;
        real<lower=0,upper=1> rstar_183;
        real<lower=0,upper=1> pistar_19;
        real<lower=0,upper=1> rstar_193;
        real<lower=0,upper=1> pistar_20;
        real<lower=0,upper=1> rstar_201;
        real<lower=0,upper=1> rstar_203;
        real<lower=0,upper=1> pistar_21;
        real<lower=0,upper=1> rstar_211;
        real<lower=0,upper=1> rstar_213;
        real<lower=0,upper=1> pistar_22;
        real<lower=0,upper=1> rstar_223;
        real<lower=0,upper=1> pistar_23;
        real<lower=0,upper=1> rstar_232;
        real<lower=0,upper=1> pistar_24;
        real<lower=0,upper=1> rstar_242;
        real<lower=0,upper=1> pistar_25;
        real<lower=0,upper=1> rstar_251;
        real<lower=0,upper=1> pistar_26;
        real<lower=0,upper=1> rstar_263;
        real<lower=0,upper=1> pistar_27;
        real<lower=0,upper=1> rstar_271;
        real<lower=0,upper=1> pistar_28;
        real<lower=0,upper=1> rstar_283;
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
        pi[1,1] = pistar_1*rstar_11*rstar_12;
        pi[1,2] = pistar_1*rstar_12;
        pi[1,3] = pistar_1*rstar_11;
        pi[1,4] = pistar_1*rstar_11*rstar_12;
        pi[1,5] = pistar_1;
        pi[1,6] = pistar_1*rstar_12;
        pi[1,7] = pistar_1*rstar_11;
        pi[1,8] = pistar_1;
        pi[2,1] = pistar_2*rstar_22;
        pi[2,2] = pistar_2*rstar_22;
        pi[2,3] = pistar_2;
        pi[2,4] = pistar_2*rstar_22;
        pi[2,5] = pistar_2;
        pi[2,6] = pistar_2*rstar_22;
        pi[2,7] = pistar_2;
        pi[2,8] = pistar_2;
        pi[3,1] = pistar_3*rstar_31*rstar_33;
        pi[3,2] = pistar_3*rstar_33;
        pi[3,3] = pistar_3*rstar_31*rstar_33;
        pi[3,4] = pistar_3*rstar_31;
        pi[3,5] = pistar_3*rstar_33;
        pi[3,6] = pistar_3;
        pi[3,7] = pistar_3*rstar_31;
        pi[3,8] = pistar_3;
        pi[4,1] = pistar_4*rstar_43;
        pi[4,2] = pistar_4*rstar_43;
        pi[4,3] = pistar_4*rstar_43;
        pi[4,4] = pistar_4;
        pi[4,5] = pistar_4*rstar_43;
        pi[4,6] = pistar_4;
        pi[4,7] = pistar_4;
        pi[4,8] = pistar_4;
        pi[5,1] = pistar_5*rstar_53;
        pi[5,2] = pistar_5*rstar_53;
        pi[5,3] = pistar_5*rstar_53;
        pi[5,4] = pistar_5;
        pi[5,5] = pistar_5*rstar_53;
        pi[5,6] = pistar_5;
        pi[5,7] = pistar_5;
        pi[5,8] = pistar_5;
        pi[6,1] = pistar_6*rstar_63;
        pi[6,2] = pistar_6*rstar_63;
        pi[6,3] = pistar_6*rstar_63;
        pi[6,4] = pistar_6;
        pi[6,5] = pistar_6*rstar_63;
        pi[6,6] = pistar_6;
        pi[6,7] = pistar_6;
        pi[6,8] = pistar_6;
        pi[7,1] = pistar_7*rstar_71*rstar_73;
        pi[7,2] = pistar_7*rstar_73;
        pi[7,3] = pistar_7*rstar_71*rstar_73;
        pi[7,4] = pistar_7*rstar_71;
        pi[7,5] = pistar_7*rstar_73;
        pi[7,6] = pistar_7;
        pi[7,7] = pistar_7*rstar_71;
        pi[7,8] = pistar_7;
        pi[8,1] = pistar_8*rstar_82;
        pi[8,2] = pistar_8*rstar_82;
        pi[8,3] = pistar_8;
        pi[8,4] = pistar_8*rstar_82;
        pi[8,5] = pistar_8;
        pi[8,6] = pistar_8*rstar_82;
        pi[8,7] = pistar_8;
        pi[8,8] = pistar_8;
        pi[9,1] = pistar_9*rstar_93;
        pi[9,2] = pistar_9*rstar_93;
        pi[9,3] = pistar_9*rstar_93;
        pi[9,4] = pistar_9;
        pi[9,5] = pistar_9*rstar_93;
        pi[9,6] = pistar_9;
        pi[9,7] = pistar_9;
        pi[9,8] = pistar_9;
        pi[10,1] = pistar_10*rstar_101;
        pi[10,2] = pistar_10;
        pi[10,3] = pistar_10*rstar_101;
        pi[10,4] = pistar_10*rstar_101;
        pi[10,5] = pistar_10;
        pi[10,6] = pistar_10;
        pi[10,7] = pistar_10*rstar_101;
        pi[10,8] = pistar_10;
        pi[11,1] = pistar_11*rstar_111*rstar_113;
        pi[11,2] = pistar_11*rstar_113;
        pi[11,3] = pistar_11*rstar_111*rstar_113;
        pi[11,4] = pistar_11*rstar_111;
        pi[11,5] = pistar_11*rstar_113;
        pi[11,6] = pistar_11;
        pi[11,7] = pistar_11*rstar_111;
        pi[11,8] = pistar_11;
        pi[12,1] = pistar_12*rstar_121*rstar_123;
        pi[12,2] = pistar_12*rstar_123;
        pi[12,3] = pistar_12*rstar_121*rstar_123;
        pi[12,4] = pistar_12*rstar_121;
        pi[12,5] = pistar_12*rstar_123;
        pi[12,6] = pistar_12;
        pi[12,7] = pistar_12*rstar_121;
        pi[12,8] = pistar_12;
        pi[13,1] = pistar_13*rstar_131;
        pi[13,2] = pistar_13;
        pi[13,3] = pistar_13*rstar_131;
        pi[13,4] = pistar_13*rstar_131;
        pi[13,5] = pistar_13;
        pi[13,6] = pistar_13;
        pi[13,7] = pistar_13*rstar_131;
        pi[13,8] = pistar_13;
        pi[14,1] = pistar_14*rstar_141;
        pi[14,2] = pistar_14;
        pi[14,3] = pistar_14*rstar_141;
        pi[14,4] = pistar_14*rstar_141;
        pi[14,5] = pistar_14;
        pi[14,6] = pistar_14;
        pi[14,7] = pistar_14*rstar_141;
        pi[14,8] = pistar_14;
        pi[15,1] = pistar_15*rstar_153;
        pi[15,2] = pistar_15*rstar_153;
        pi[15,3] = pistar_15*rstar_153;
        pi[15,4] = pistar_15;
        pi[15,5] = pistar_15*rstar_153;
        pi[15,6] = pistar_15;
        pi[15,7] = pistar_15;
        pi[15,8] = pistar_15;
        pi[16,1] = pistar_16*rstar_161*rstar_163;
        pi[16,2] = pistar_16*rstar_163;
        pi[16,3] = pistar_16*rstar_161*rstar_163;
        pi[16,4] = pistar_16*rstar_161;
        pi[16,5] = pistar_16*rstar_163;
        pi[16,6] = pistar_16;
        pi[16,7] = pistar_16*rstar_161;
        pi[16,8] = pistar_16;
        pi[17,1] = pistar_17*rstar_172*rstar_173;
        pi[17,2] = pistar_17*rstar_172*rstar_173;
        pi[17,3] = pistar_17*rstar_173;
        pi[17,4] = pistar_17*rstar_172;
        pi[17,5] = pistar_17*rstar_173;
        pi[17,6] = pistar_17*rstar_172;
        pi[17,7] = pistar_17;
        pi[17,8] = pistar_17;
        pi[18,1] = pistar_18*rstar_183;
        pi[18,2] = pistar_18*rstar_183;
        pi[18,3] = pistar_18*rstar_183;
        pi[18,4] = pistar_18;
        pi[18,5] = pistar_18*rstar_183;
        pi[18,6] = pistar_18;
        pi[18,7] = pistar_18;
        pi[18,8] = pistar_18;
        pi[19,1] = pistar_19*rstar_193;
        pi[19,2] = pistar_19*rstar_193;
        pi[19,3] = pistar_19*rstar_193;
        pi[19,4] = pistar_19;
        pi[19,5] = pistar_19*rstar_193;
        pi[19,6] = pistar_19;
        pi[19,7] = pistar_19;
        pi[19,8] = pistar_19;
        pi[20,1] = pistar_20*rstar_201*rstar_203;
        pi[20,2] = pistar_20*rstar_203;
        pi[20,3] = pistar_20*rstar_201*rstar_203;
        pi[20,4] = pistar_20*rstar_201;
        pi[20,5] = pistar_20*rstar_203;
        pi[20,6] = pistar_20;
        pi[20,7] = pistar_20*rstar_201;
        pi[20,8] = pistar_20;
        pi[21,1] = pistar_21*rstar_211*rstar_213;
        pi[21,2] = pistar_21*rstar_213;
        pi[21,3] = pistar_21*rstar_211*rstar_213;
        pi[21,4] = pistar_21*rstar_211;
        pi[21,5] = pistar_21*rstar_213;
        pi[21,6] = pistar_21;
        pi[21,7] = pistar_21*rstar_211;
        pi[21,8] = pistar_21;
        pi[22,1] = pistar_22*rstar_223;
        pi[22,2] = pistar_22*rstar_223;
        pi[22,3] = pistar_22*rstar_223;
        pi[22,4] = pistar_22;
        pi[22,5] = pistar_22*rstar_223;
        pi[22,6] = pistar_22;
        pi[22,7] = pistar_22;
        pi[22,8] = pistar_22;
        pi[23,1] = pistar_23*rstar_232;
        pi[23,2] = pistar_23*rstar_232;
        pi[23,3] = pistar_23;
        pi[23,4] = pistar_23*rstar_232;
        pi[23,5] = pistar_23;
        pi[23,6] = pistar_23*rstar_232;
        pi[23,7] = pistar_23;
        pi[23,8] = pistar_23;
        pi[24,1] = pistar_24*rstar_242;
        pi[24,2] = pistar_24*rstar_242;
        pi[24,3] = pistar_24;
        pi[24,4] = pistar_24*rstar_242;
        pi[24,5] = pistar_24;
        pi[24,6] = pistar_24*rstar_242;
        pi[24,7] = pistar_24;
        pi[24,8] = pistar_24;
        pi[25,1] = pistar_25*rstar_251;
        pi[25,2] = pistar_25;
        pi[25,3] = pistar_25*rstar_251;
        pi[25,4] = pistar_25*rstar_251;
        pi[25,5] = pistar_25;
        pi[25,6] = pistar_25;
        pi[25,7] = pistar_25*rstar_251;
        pi[25,8] = pistar_25;
        pi[26,1] = pistar_26*rstar_263;
        pi[26,2] = pistar_26*rstar_263;
        pi[26,3] = pistar_26*rstar_263;
        pi[26,4] = pistar_26;
        pi[26,5] = pistar_26*rstar_263;
        pi[26,6] = pistar_26;
        pi[26,7] = pistar_26;
        pi[26,8] = pistar_26;
        pi[27,1] = pistar_27*rstar_271;
        pi[27,2] = pistar_27;
        pi[27,3] = pistar_27*rstar_271;
        pi[27,4] = pistar_27*rstar_271;
        pi[27,5] = pistar_27;
        pi[27,6] = pistar_27;
        pi[27,7] = pistar_27*rstar_271;
        pi[27,8] = pistar_27;
        pi[28,1] = pistar_28*rstar_283;
        pi[28,2] = pistar_28*rstar_283;
        pi[28,3] = pistar_28*rstar_283;
        pi[28,4] = pistar_28;
        pi[28,5] = pistar_28*rstar_283;
        pi[28,6] = pistar_28;
        pi[28,7] = pistar_28;
        pi[28,8] = pistar_28;
      }
      model {
        ////////////////////////////////// priors
        eta[1] ~ beta(1, 1);
        eta[2] ~ beta(1, 1);
        eta[3] ~ beta(1, 1);
        pistar_1 ~ beta(15, 3);
        rstar_11 ~ beta(2, 2);
        rstar_12 ~ beta(2, 2);
        pistar_2 ~ beta(15, 3);
        rstar_22 ~ beta(2, 2);
        pistar_3 ~ beta(15, 3);
        rstar_31 ~ beta(2, 2);
        rstar_33 ~ beta(2, 2);
        pistar_4 ~ beta(15, 3);
        rstar_43 ~ beta(2, 2);
        pistar_5 ~ beta(15, 3);
        rstar_53 ~ beta(2, 2);
        pistar_6 ~ beta(15, 3);
        rstar_63 ~ beta(2, 2);
        pistar_7 ~ beta(15, 3);
        rstar_71 ~ beta(2, 2);
        rstar_73 ~ beta(2, 2);
        pistar_8 ~ beta(15, 3);
        rstar_82 ~ beta(2, 2);
        pistar_9 ~ beta(15, 3);
        rstar_93 ~ beta(2, 2);
        pistar_10 ~ beta(15, 3);
        rstar_101 ~ beta(2, 2);
        pistar_11 ~ beta(15, 3);
        rstar_111 ~ beta(2, 2);
        rstar_113 ~ beta(2, 2);
        pistar_12 ~ beta(15, 3);
        rstar_121 ~ beta(2, 2);
        rstar_123 ~ beta(2, 2);
        pistar_13 ~ beta(15, 3);
        rstar_131 ~ beta(2, 2);
        pistar_14 ~ beta(15, 3);
        rstar_141 ~ beta(2, 2);
        pistar_15 ~ beta(15, 3);
        rstar_153 ~ beta(2, 2);
        pistar_16 ~ beta(15, 3);
        rstar_161 ~ beta(2, 2);
        rstar_163 ~ beta(2, 2);
        pistar_17 ~ beta(15, 3);
        rstar_172 ~ beta(2, 2);
        rstar_173 ~ beta(2, 2);
        pistar_18 ~ beta(15, 3);
        rstar_183 ~ beta(2, 2);
        pistar_19 ~ beta(15, 3);
        rstar_193 ~ beta(2, 2);
        pistar_20 ~ beta(15, 3);
        rstar_201 ~ beta(2, 2);
        rstar_203 ~ beta(2, 2);
        pistar_21 ~ beta(15, 3);
        rstar_211 ~ beta(2, 2);
        rstar_213 ~ beta(2, 2);
        pistar_22 ~ beta(15, 3);
        rstar_223 ~ beta(2, 2);
        pistar_23 ~ beta(15, 3);
        rstar_232 ~ beta(2, 2);
        pistar_24 ~ beta(15, 3);
        rstar_242 ~ beta(2, 2);
        pistar_25 ~ beta(15, 3);
        rstar_251 ~ beta(2, 2);
        pistar_26 ~ beta(15, 3);
        rstar_263 ~ beta(2, 2);
        pistar_27 ~ beta(15, 3);
        rstar_271 ~ beta(2, 2);
        pistar_28 ~ beta(15, 3);
        rstar_283 ~ beta(2, 2);
      
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
      }
      parameters {
        simplex[C] Vc;
      
        ////////////////////////////////// measurement parameters
        real<lower=0,upper=1> pistar_1;
        real<lower=0,upper=1> rstar_11;
        real<lower=0,upper=1> pistar_2;
        real<lower=0,upper=1> rstar_23;
        real<lower=0,upper=1> pistar_3;
        real<lower=0,upper=1> rstar_32;
        real<lower=0,upper=1> pistar_4;
        real<lower=0,upper=1> rstar_41;
        real<lower=0,upper=1> pistar_5;
        real<lower=0,upper=1> rstar_51;
        real<lower=0,upper=1> pistar_6;
        real<lower=0,upper=1> rstar_62;
        real<lower=0,upper=1> pistar_7;
        real<lower=0,upper=1> rstar_71;
        real<lower=0,upper=1> pistar_8;
        real<lower=0,upper=1> rstar_83;
        real<lower=0,upper=1> pistar_9;
        real<lower=0,upper=1> rstar_93;
        real<lower=0,upper=1> pistar_10;
        real<lower=0,upper=1> rstar_103;
        real<lower=0,upper=1> pistar_11;
        real<lower=0,upper=1> rstar_113;
        real<lower=0,upper=1> pistar_12;
        real<lower=0,upper=1> rstar_121;
        real<lower=0,upper=1> pistar_13;
        real<lower=0,upper=1> rstar_134;
        real<lower=0,upper=1> pistar_14;
        real<lower=0,upper=1> rstar_141;
        real<lower=0,upper=1> pistar_15;
        real<lower=0,upper=1> rstar_151;
        real<lower=0,upper=1> pistar_16;
        real<lower=0,upper=1> rstar_162;
        real<lower=0,upper=1> pistar_17;
        real<lower=0,upper=1> rstar_172;
        real<lower=0,upper=1> pistar_18;
        real<lower=0,upper=1> rstar_181;
        real<lower=0,upper=1> pistar_19;
        real<lower=0,upper=1> rstar_191;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = pistar_1*rstar_11;
        pi[1,2] = pistar_1;
        pi[1,3] = pistar_1*rstar_11;
        pi[1,4] = pistar_1*rstar_11;
        pi[1,5] = pistar_1*rstar_11;
        pi[1,6] = pistar_1;
        pi[1,7] = pistar_1;
        pi[1,8] = pistar_1;
        pi[1,9] = pistar_1*rstar_11;
        pi[1,10] = pistar_1*rstar_11;
        pi[1,11] = pistar_1*rstar_11;
        pi[1,12] = pistar_1;
        pi[1,13] = pistar_1;
        pi[1,14] = pistar_1;
        pi[1,15] = pistar_1*rstar_11;
        pi[1,16] = pistar_1;
        pi[2,1] = pistar_2*rstar_23;
        pi[2,2] = pistar_2*rstar_23;
        pi[2,3] = pistar_2*rstar_23;
        pi[2,4] = pistar_2;
        pi[2,5] = pistar_2*rstar_23;
        pi[2,6] = pistar_2*rstar_23;
        pi[2,7] = pistar_2;
        pi[2,8] = pistar_2*rstar_23;
        pi[2,9] = pistar_2;
        pi[2,10] = pistar_2*rstar_23;
        pi[2,11] = pistar_2;
        pi[2,12] = pistar_2;
        pi[2,13] = pistar_2*rstar_23;
        pi[2,14] = pistar_2;
        pi[2,15] = pistar_2;
        pi[2,16] = pistar_2;
        pi[3,1] = pistar_3*rstar_32;
        pi[3,2] = pistar_3*rstar_32;
        pi[3,3] = pistar_3;
        pi[3,4] = pistar_3*rstar_32;
        pi[3,5] = pistar_3*rstar_32;
        pi[3,6] = pistar_3;
        pi[3,7] = pistar_3*rstar_32;
        pi[3,8] = pistar_3*rstar_32;
        pi[3,9] = pistar_3;
        pi[3,10] = pistar_3;
        pi[3,11] = pistar_3*rstar_32;
        pi[3,12] = pistar_3;
        pi[3,13] = pistar_3;
        pi[3,14] = pistar_3*rstar_32;
        pi[3,15] = pistar_3;
        pi[3,16] = pistar_3;
        pi[4,1] = pistar_4*rstar_41;
        pi[4,2] = pistar_4;
        pi[4,3] = pistar_4*rstar_41;
        pi[4,4] = pistar_4*rstar_41;
        pi[4,5] = pistar_4*rstar_41;
        pi[4,6] = pistar_4;
        pi[4,7] = pistar_4;
        pi[4,8] = pistar_4;
        pi[4,9] = pistar_4*rstar_41;
        pi[4,10] = pistar_4*rstar_41;
        pi[4,11] = pistar_4*rstar_41;
        pi[4,12] = pistar_4;
        pi[4,13] = pistar_4;
        pi[4,14] = pistar_4;
        pi[4,15] = pistar_4*rstar_41;
        pi[4,16] = pistar_4;
        pi[5,1] = pistar_5*rstar_51;
        pi[5,2] = pistar_5;
        pi[5,3] = pistar_5*rstar_51;
        pi[5,4] = pistar_5*rstar_51;
        pi[5,5] = pistar_5*rstar_51;
        pi[5,6] = pistar_5;
        pi[5,7] = pistar_5;
        pi[5,8] = pistar_5;
        pi[5,9] = pistar_5*rstar_51;
        pi[5,10] = pistar_5*rstar_51;
        pi[5,11] = pistar_5*rstar_51;
        pi[5,12] = pistar_5;
        pi[5,13] = pistar_5;
        pi[5,14] = pistar_5;
        pi[5,15] = pistar_5*rstar_51;
        pi[5,16] = pistar_5;
        pi[6,1] = pistar_6*rstar_62;
        pi[6,2] = pistar_6*rstar_62;
        pi[6,3] = pistar_6;
        pi[6,4] = pistar_6*rstar_62;
        pi[6,5] = pistar_6*rstar_62;
        pi[6,6] = pistar_6;
        pi[6,7] = pistar_6*rstar_62;
        pi[6,8] = pistar_6*rstar_62;
        pi[6,9] = pistar_6;
        pi[6,10] = pistar_6;
        pi[6,11] = pistar_6*rstar_62;
        pi[6,12] = pistar_6;
        pi[6,13] = pistar_6;
        pi[6,14] = pistar_6*rstar_62;
        pi[6,15] = pistar_6;
        pi[6,16] = pistar_6;
        pi[7,1] = pistar_7*rstar_71;
        pi[7,2] = pistar_7;
        pi[7,3] = pistar_7*rstar_71;
        pi[7,4] = pistar_7*rstar_71;
        pi[7,5] = pistar_7*rstar_71;
        pi[7,6] = pistar_7;
        pi[7,7] = pistar_7;
        pi[7,8] = pistar_7;
        pi[7,9] = pistar_7*rstar_71;
        pi[7,10] = pistar_7*rstar_71;
        pi[7,11] = pistar_7*rstar_71;
        pi[7,12] = pistar_7;
        pi[7,13] = pistar_7;
        pi[7,14] = pistar_7;
        pi[7,15] = pistar_7*rstar_71;
        pi[7,16] = pistar_7;
        pi[8,1] = pistar_8*rstar_83;
        pi[8,2] = pistar_8*rstar_83;
        pi[8,3] = pistar_8*rstar_83;
        pi[8,4] = pistar_8;
        pi[8,5] = pistar_8*rstar_83;
        pi[8,6] = pistar_8*rstar_83;
        pi[8,7] = pistar_8;
        pi[8,8] = pistar_8*rstar_83;
        pi[8,9] = pistar_8;
        pi[8,10] = pistar_8*rstar_83;
        pi[8,11] = pistar_8;
        pi[8,12] = pistar_8;
        pi[8,13] = pistar_8*rstar_83;
        pi[8,14] = pistar_8;
        pi[8,15] = pistar_8;
        pi[8,16] = pistar_8;
        pi[9,1] = pistar_9*rstar_93;
        pi[9,2] = pistar_9*rstar_93;
        pi[9,3] = pistar_9*rstar_93;
        pi[9,4] = pistar_9;
        pi[9,5] = pistar_9*rstar_93;
        pi[9,6] = pistar_9*rstar_93;
        pi[9,7] = pistar_9;
        pi[9,8] = pistar_9*rstar_93;
        pi[9,9] = pistar_9;
        pi[9,10] = pistar_9*rstar_93;
        pi[9,11] = pistar_9;
        pi[9,12] = pistar_9;
        pi[9,13] = pistar_9*rstar_93;
        pi[9,14] = pistar_9;
        pi[9,15] = pistar_9;
        pi[9,16] = pistar_9;
        pi[10,1] = pistar_10*rstar_103;
        pi[10,2] = pistar_10*rstar_103;
        pi[10,3] = pistar_10*rstar_103;
        pi[10,4] = pistar_10;
        pi[10,5] = pistar_10*rstar_103;
        pi[10,6] = pistar_10*rstar_103;
        pi[10,7] = pistar_10;
        pi[10,8] = pistar_10*rstar_103;
        pi[10,9] = pistar_10;
        pi[10,10] = pistar_10*rstar_103;
        pi[10,11] = pistar_10;
        pi[10,12] = pistar_10;
        pi[10,13] = pistar_10*rstar_103;
        pi[10,14] = pistar_10;
        pi[10,15] = pistar_10;
        pi[10,16] = pistar_10;
        pi[11,1] = pistar_11*rstar_113;
        pi[11,2] = pistar_11*rstar_113;
        pi[11,3] = pistar_11*rstar_113;
        pi[11,4] = pistar_11;
        pi[11,5] = pistar_11*rstar_113;
        pi[11,6] = pistar_11*rstar_113;
        pi[11,7] = pistar_11;
        pi[11,8] = pistar_11*rstar_113;
        pi[11,9] = pistar_11;
        pi[11,10] = pistar_11*rstar_113;
        pi[11,11] = pistar_11;
        pi[11,12] = pistar_11;
        pi[11,13] = pistar_11*rstar_113;
        pi[11,14] = pistar_11;
        pi[11,15] = pistar_11;
        pi[11,16] = pistar_11;
        pi[12,1] = pistar_12*rstar_121;
        pi[12,2] = pistar_12;
        pi[12,3] = pistar_12*rstar_121;
        pi[12,4] = pistar_12*rstar_121;
        pi[12,5] = pistar_12*rstar_121;
        pi[12,6] = pistar_12;
        pi[12,7] = pistar_12;
        pi[12,8] = pistar_12;
        pi[12,9] = pistar_12*rstar_121;
        pi[12,10] = pistar_12*rstar_121;
        pi[12,11] = pistar_12*rstar_121;
        pi[12,12] = pistar_12;
        pi[12,13] = pistar_12;
        pi[12,14] = pistar_12;
        pi[12,15] = pistar_12*rstar_121;
        pi[12,16] = pistar_12;
        pi[13,1] = pistar_13*rstar_134;
        pi[13,2] = pistar_13*rstar_134;
        pi[13,3] = pistar_13*rstar_134;
        pi[13,4] = pistar_13*rstar_134;
        pi[13,5] = pistar_13;
        pi[13,6] = pistar_13*rstar_134;
        pi[13,7] = pistar_13*rstar_134;
        pi[13,8] = pistar_13;
        pi[13,9] = pistar_13*rstar_134;
        pi[13,10] = pistar_13;
        pi[13,11] = pistar_13;
        pi[13,12] = pistar_13*rstar_134;
        pi[13,13] = pistar_13;
        pi[13,14] = pistar_13;
        pi[13,15] = pistar_13;
        pi[13,16] = pistar_13;
        pi[14,1] = pistar_14*rstar_141;
        pi[14,2] = pistar_14;
        pi[14,3] = pistar_14*rstar_141;
        pi[14,4] = pistar_14*rstar_141;
        pi[14,5] = pistar_14*rstar_141;
        pi[14,6] = pistar_14;
        pi[14,7] = pistar_14;
        pi[14,8] = pistar_14;
        pi[14,9] = pistar_14*rstar_141;
        pi[14,10] = pistar_14*rstar_141;
        pi[14,11] = pistar_14*rstar_141;
        pi[14,12] = pistar_14;
        pi[14,13] = pistar_14;
        pi[14,14] = pistar_14;
        pi[14,15] = pistar_14*rstar_141;
        pi[14,16] = pistar_14;
        pi[15,1] = pistar_15*rstar_151;
        pi[15,2] = pistar_15;
        pi[15,3] = pistar_15*rstar_151;
        pi[15,4] = pistar_15*rstar_151;
        pi[15,5] = pistar_15*rstar_151;
        pi[15,6] = pistar_15;
        pi[15,7] = pistar_15;
        pi[15,8] = pistar_15;
        pi[15,9] = pistar_15*rstar_151;
        pi[15,10] = pistar_15*rstar_151;
        pi[15,11] = pistar_15*rstar_151;
        pi[15,12] = pistar_15;
        pi[15,13] = pistar_15;
        pi[15,14] = pistar_15;
        pi[15,15] = pistar_15*rstar_151;
        pi[15,16] = pistar_15;
        pi[16,1] = pistar_16*rstar_162;
        pi[16,2] = pistar_16*rstar_162;
        pi[16,3] = pistar_16;
        pi[16,4] = pistar_16*rstar_162;
        pi[16,5] = pistar_16*rstar_162;
        pi[16,6] = pistar_16;
        pi[16,7] = pistar_16*rstar_162;
        pi[16,8] = pistar_16*rstar_162;
        pi[16,9] = pistar_16;
        pi[16,10] = pistar_16;
        pi[16,11] = pistar_16*rstar_162;
        pi[16,12] = pistar_16;
        pi[16,13] = pistar_16;
        pi[16,14] = pistar_16*rstar_162;
        pi[16,15] = pistar_16;
        pi[16,16] = pistar_16;
        pi[17,1] = pistar_17*rstar_172;
        pi[17,2] = pistar_17*rstar_172;
        pi[17,3] = pistar_17;
        pi[17,4] = pistar_17*rstar_172;
        pi[17,5] = pistar_17*rstar_172;
        pi[17,6] = pistar_17;
        pi[17,7] = pistar_17*rstar_172;
        pi[17,8] = pistar_17*rstar_172;
        pi[17,9] = pistar_17;
        pi[17,10] = pistar_17;
        pi[17,11] = pistar_17*rstar_172;
        pi[17,12] = pistar_17;
        pi[17,13] = pistar_17;
        pi[17,14] = pistar_17*rstar_172;
        pi[17,15] = pistar_17;
        pi[17,16] = pistar_17;
        pi[18,1] = pistar_18*rstar_181;
        pi[18,2] = pistar_18;
        pi[18,3] = pistar_18*rstar_181;
        pi[18,4] = pistar_18*rstar_181;
        pi[18,5] = pistar_18*rstar_181;
        pi[18,6] = pistar_18;
        pi[18,7] = pistar_18;
        pi[18,8] = pistar_18;
        pi[18,9] = pistar_18*rstar_181;
        pi[18,10] = pistar_18*rstar_181;
        pi[18,11] = pistar_18*rstar_181;
        pi[18,12] = pistar_18;
        pi[18,13] = pistar_18;
        pi[18,14] = pistar_18;
        pi[18,15] = pistar_18*rstar_181;
        pi[18,16] = pistar_18;
        pi[19,1] = pistar_19*rstar_191;
        pi[19,2] = pistar_19;
        pi[19,3] = pistar_19*rstar_191;
        pi[19,4] = pistar_19*rstar_191;
        pi[19,5] = pistar_19*rstar_191;
        pi[19,6] = pistar_19;
        pi[19,7] = pistar_19;
        pi[19,8] = pistar_19;
        pi[19,9] = pistar_19*rstar_191;
        pi[19,10] = pistar_19*rstar_191;
        pi[19,11] = pistar_19*rstar_191;
        pi[19,12] = pistar_19;
        pi[19,13] = pistar_19;
        pi[19,14] = pistar_19;
        pi[19,15] = pistar_19*rstar_191;
        pi[19,16] = pistar_19;
      }
      model {
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        pistar_1 ~ beta(15, 3);
        rstar_11 ~ beta(2, 2);
        pistar_2 ~ beta(15, 3);
        rstar_23 ~ beta(2, 2);
        pistar_3 ~ beta(15, 3);
        rstar_32 ~ beta(2, 2);
        pistar_4 ~ beta(15, 3);
        rstar_41 ~ beta(2, 2);
        pistar_5 ~ beta(15, 3);
        rstar_51 ~ beta(2, 2);
        pistar_6 ~ beta(15, 3);
        rstar_62 ~ beta(2, 2);
        pistar_7 ~ beta(15, 3);
        rstar_71 ~ beta(2, 2);
        pistar_8 ~ beta(15, 3);
        rstar_83 ~ beta(2, 2);
        pistar_9 ~ beta(15, 3);
        rstar_93 ~ beta(2, 2);
        pistar_10 ~ beta(15, 3);
        rstar_103 ~ beta(2, 2);
        pistar_11 ~ beta(15, 3);
        rstar_113 ~ beta(2, 2);
        pistar_12 ~ beta(15, 3);
        rstar_121 ~ beta(2, 2);
        pistar_13 ~ beta(15, 3);
        rstar_134 ~ beta(2, 2);
        pistar_14 ~ beta(15, 3);
        rstar_141 ~ beta(2, 2);
        pistar_15 ~ beta(15, 3);
        rstar_151 ~ beta(2, 2);
        pistar_16 ~ beta(15, 3);
        rstar_162 ~ beta(2, 2);
        pistar_17 ~ beta(15, 3);
        rstar_172 ~ beta(2, 2);
        pistar_18 ~ beta(15, 3);
        rstar_181 ~ beta(2, 2);
        pistar_19 ~ beta(15, 3);
        rstar_191 ~ beta(2, 2);
      
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

# ncrum with hierarchy works

    Code
      stan_code(ecpe_ncrum_hdcm)
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
      }
      parameters {
        simplex[C] Vc;
      
        ////////////////////////////////// measurement parameters
        real<lower=0,upper=1> pistar_1;
        real<lower=0,upper=1> rstar_11;
        real<lower=0,upper=1> rstar_12;
        real<lower=0,upper=1> pistar_2;
        real<lower=0,upper=1> rstar_22;
        real<lower=0,upper=1> pistar_3;
        real<lower=0,upper=1> rstar_31;
        real<lower=0,upper=1> rstar_33;
        real<lower=0,upper=1> pistar_4;
        real<lower=0,upper=1> rstar_43;
        real<lower=0,upper=1> pistar_5;
        real<lower=0,upper=1> rstar_53;
        real<lower=0,upper=1> pistar_6;
        real<lower=0,upper=1> rstar_63;
        real<lower=0,upper=1> pistar_7;
        real<lower=0,upper=1> rstar_71;
        real<lower=0,upper=1> rstar_73;
        real<lower=0,upper=1> pistar_8;
        real<lower=0,upper=1> rstar_82;
        real<lower=0,upper=1> pistar_9;
        real<lower=0,upper=1> rstar_93;
        real<lower=0,upper=1> pistar_10;
        real<lower=0,upper=1> rstar_101;
        real<lower=0,upper=1> pistar_11;
        real<lower=0,upper=1> rstar_111;
        real<lower=0,upper=1> rstar_113;
        real<lower=0,upper=1> pistar_12;
        real<lower=0,upper=1> rstar_121;
        real<lower=0,upper=1> rstar_123;
        real<lower=0,upper=1> pistar_13;
        real<lower=0,upper=1> rstar_131;
        real<lower=0,upper=1> pistar_14;
        real<lower=0,upper=1> rstar_141;
        real<lower=0,upper=1> pistar_15;
        real<lower=0,upper=1> rstar_153;
        real<lower=0,upper=1> pistar_16;
        real<lower=0,upper=1> rstar_161;
        real<lower=0,upper=1> rstar_163;
        real<lower=0,upper=1> pistar_17;
        real<lower=0,upper=1> rstar_172;
        real<lower=0,upper=1> rstar_173;
        real<lower=0,upper=1> pistar_18;
        real<lower=0,upper=1> rstar_183;
        real<lower=0,upper=1> pistar_19;
        real<lower=0,upper=1> rstar_193;
        real<lower=0,upper=1> pistar_20;
        real<lower=0,upper=1> rstar_201;
        real<lower=0,upper=1> rstar_203;
        real<lower=0,upper=1> pistar_21;
        real<lower=0,upper=1> rstar_211;
        real<lower=0,upper=1> rstar_213;
        real<lower=0,upper=1> pistar_22;
        real<lower=0,upper=1> rstar_223;
        real<lower=0,upper=1> pistar_23;
        real<lower=0,upper=1> rstar_232;
        real<lower=0,upper=1> pistar_24;
        real<lower=0,upper=1> rstar_242;
        real<lower=0,upper=1> pistar_25;
        real<lower=0,upper=1> rstar_251;
        real<lower=0,upper=1> pistar_26;
        real<lower=0,upper=1> rstar_263;
        real<lower=0,upper=1> pistar_27;
        real<lower=0,upper=1> rstar_271;
        real<lower=0,upper=1> pistar_28;
        real<lower=0,upper=1> rstar_283;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = pistar_1*rstar_11*rstar_12;
        pi[1,2] = pistar_1*rstar_11*rstar_12;
        pi[1,3] = pistar_1*rstar_11;
        pi[1,4] = pistar_1;
        pi[2,1] = pistar_2*rstar_22;
        pi[2,2] = pistar_2*rstar_22;
        pi[2,3] = pistar_2;
        pi[2,4] = pistar_2;
        pi[3,1] = pistar_3*rstar_31*rstar_33;
        pi[3,2] = pistar_3*rstar_31;
        pi[3,3] = pistar_3*rstar_31;
        pi[3,4] = pistar_3;
        pi[4,1] = pistar_4*rstar_43;
        pi[4,2] = pistar_4;
        pi[4,3] = pistar_4;
        pi[4,4] = pistar_4;
        pi[5,1] = pistar_5*rstar_53;
        pi[5,2] = pistar_5;
        pi[5,3] = pistar_5;
        pi[5,4] = pistar_5;
        pi[6,1] = pistar_6*rstar_63;
        pi[6,2] = pistar_6;
        pi[6,3] = pistar_6;
        pi[6,4] = pistar_6;
        pi[7,1] = pistar_7*rstar_71*rstar_73;
        pi[7,2] = pistar_7*rstar_71;
        pi[7,3] = pistar_7*rstar_71;
        pi[7,4] = pistar_7;
        pi[8,1] = pistar_8*rstar_82;
        pi[8,2] = pistar_8*rstar_82;
        pi[8,3] = pistar_8;
        pi[8,4] = pistar_8;
        pi[9,1] = pistar_9*rstar_93;
        pi[9,2] = pistar_9;
        pi[9,3] = pistar_9;
        pi[9,4] = pistar_9;
        pi[10,1] = pistar_10*rstar_101;
        pi[10,2] = pistar_10*rstar_101;
        pi[10,3] = pistar_10*rstar_101;
        pi[10,4] = pistar_10;
        pi[11,1] = pistar_11*rstar_111*rstar_113;
        pi[11,2] = pistar_11*rstar_111;
        pi[11,3] = pistar_11*rstar_111;
        pi[11,4] = pistar_11;
        pi[12,1] = pistar_12*rstar_121*rstar_123;
        pi[12,2] = pistar_12*rstar_121;
        pi[12,3] = pistar_12*rstar_121;
        pi[12,4] = pistar_12;
        pi[13,1] = pistar_13*rstar_131;
        pi[13,2] = pistar_13*rstar_131;
        pi[13,3] = pistar_13*rstar_131;
        pi[13,4] = pistar_13;
        pi[14,1] = pistar_14*rstar_141;
        pi[14,2] = pistar_14*rstar_141;
        pi[14,3] = pistar_14*rstar_141;
        pi[14,4] = pistar_14;
        pi[15,1] = pistar_15*rstar_153;
        pi[15,2] = pistar_15;
        pi[15,3] = pistar_15;
        pi[15,4] = pistar_15;
        pi[16,1] = pistar_16*rstar_161*rstar_163;
        pi[16,2] = pistar_16*rstar_161;
        pi[16,3] = pistar_16*rstar_161;
        pi[16,4] = pistar_16;
        pi[17,1] = pistar_17*rstar_172*rstar_173;
        pi[17,2] = pistar_17*rstar_172;
        pi[17,3] = pistar_17;
        pi[17,4] = pistar_17;
        pi[18,1] = pistar_18*rstar_183;
        pi[18,2] = pistar_18;
        pi[18,3] = pistar_18;
        pi[18,4] = pistar_18;
        pi[19,1] = pistar_19*rstar_193;
        pi[19,2] = pistar_19;
        pi[19,3] = pistar_19;
        pi[19,4] = pistar_19;
        pi[20,1] = pistar_20*rstar_201*rstar_203;
        pi[20,2] = pistar_20*rstar_201;
        pi[20,3] = pistar_20*rstar_201;
        pi[20,4] = pistar_20;
        pi[21,1] = pistar_21*rstar_211*rstar_213;
        pi[21,2] = pistar_21*rstar_211;
        pi[21,3] = pistar_21*rstar_211;
        pi[21,4] = pistar_21;
        pi[22,1] = pistar_22*rstar_223;
        pi[22,2] = pistar_22;
        pi[22,3] = pistar_22;
        pi[22,4] = pistar_22;
        pi[23,1] = pistar_23*rstar_232;
        pi[23,2] = pistar_23*rstar_232;
        pi[23,3] = pistar_23;
        pi[23,4] = pistar_23;
        pi[24,1] = pistar_24*rstar_242;
        pi[24,2] = pistar_24*rstar_242;
        pi[24,3] = pistar_24;
        pi[24,4] = pistar_24;
        pi[25,1] = pistar_25*rstar_251;
        pi[25,2] = pistar_25*rstar_251;
        pi[25,3] = pistar_25*rstar_251;
        pi[25,4] = pistar_25;
        pi[26,1] = pistar_26*rstar_263;
        pi[26,2] = pistar_26;
        pi[26,3] = pistar_26;
        pi[26,4] = pistar_26;
        pi[27,1] = pistar_27*rstar_271;
        pi[27,2] = pistar_27*rstar_271;
        pi[27,3] = pistar_27*rstar_271;
        pi[27,4] = pistar_27;
        pi[28,1] = pistar_28*rstar_283;
        pi[28,2] = pistar_28;
        pi[28,3] = pistar_28;
        pi[28,4] = pistar_28;
      }
      model {
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        pistar_1 ~ beta(15, 3);
        rstar_11 ~ beta(2, 2);
        rstar_12 ~ beta(2, 2);
        pistar_2 ~ beta(15, 3);
        rstar_22 ~ beta(2, 2);
        pistar_3 ~ beta(15, 3);
        rstar_31 ~ beta(2, 2);
        rstar_33 ~ beta(2, 2);
        pistar_4 ~ beta(15, 3);
        rstar_43 ~ beta(2, 2);
        pistar_5 ~ beta(15, 3);
        rstar_53 ~ beta(2, 2);
        pistar_6 ~ beta(15, 3);
        rstar_63 ~ beta(2, 2);
        pistar_7 ~ beta(15, 3);
        rstar_71 ~ beta(2, 2);
        rstar_73 ~ beta(2, 2);
        pistar_8 ~ beta(15, 3);
        rstar_82 ~ beta(2, 2);
        pistar_9 ~ beta(15, 3);
        rstar_93 ~ beta(2, 2);
        pistar_10 ~ beta(15, 3);
        rstar_101 ~ beta(2, 2);
        pistar_11 ~ beta(15, 3);
        rstar_111 ~ beta(2, 2);
        rstar_113 ~ beta(2, 2);
        pistar_12 ~ beta(15, 3);
        rstar_121 ~ beta(2, 2);
        rstar_123 ~ beta(2, 2);
        pistar_13 ~ beta(15, 3);
        rstar_131 ~ beta(2, 2);
        pistar_14 ~ beta(15, 3);
        rstar_141 ~ beta(2, 2);
        pistar_15 ~ beta(15, 3);
        rstar_153 ~ beta(2, 2);
        pistar_16 ~ beta(15, 3);
        rstar_161 ~ beta(2, 2);
        rstar_163 ~ beta(2, 2);
        pistar_17 ~ beta(15, 3);
        rstar_172 ~ beta(2, 2);
        rstar_173 ~ beta(2, 2);
        pistar_18 ~ beta(15, 3);
        rstar_183 ~ beta(2, 2);
        pistar_19 ~ beta(15, 3);
        rstar_193 ~ beta(2, 2);
        pistar_20 ~ beta(15, 3);
        rstar_201 ~ beta(2, 2);
        rstar_203 ~ beta(2, 2);
        pistar_21 ~ beta(15, 3);
        rstar_211 ~ beta(2, 2);
        rstar_213 ~ beta(2, 2);
        pistar_22 ~ beta(15, 3);
        rstar_223 ~ beta(2, 2);
        pistar_23 ~ beta(15, 3);
        rstar_232 ~ beta(2, 2);
        pistar_24 ~ beta(15, 3);
        rstar_242 ~ beta(2, 2);
        pistar_25 ~ beta(15, 3);
        rstar_251 ~ beta(2, 2);
        pistar_26 ~ beta(15, 3);
        rstar_263 ~ beta(2, 2);
        pistar_27 ~ beta(15, 3);
        rstar_271 ~ beta(2, 2);
        pistar_28 ~ beta(15, 3);
        rstar_283 ~ beta(2, 2);
      
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

