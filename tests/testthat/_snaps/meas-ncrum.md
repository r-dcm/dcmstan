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
        simplex[C] Vc;                  // base rates of class membership
      
        ////////////////////////////////// parameters
        real<lower=0,upper=1> penalty_1_1;
        real<lower=0,upper=1> slip_1_1;
        real<lower=0,upper=1> penalty_1_2;
        real<lower=0,upper=1> slip_1_2;
        real<lower=0,upper=1> penalty_2_2;
        real<lower=0,upper=1> slip_2_2;
        real<lower=0,upper=1> penalty_3_1;
        real<lower=0,upper=1> slip_3_1;
        real<lower=0,upper=1> penalty_3_3;
        real<lower=0,upper=1> slip_3_3;
        real<lower=0,upper=1> penalty_4_3;
        real<lower=0,upper=1> slip_4_3;
        real<lower=0,upper=1> penalty_5_3;
        real<lower=0,upper=1> slip_5_3;
        real<lower=0,upper=1> penalty_6_3;
        real<lower=0,upper=1> slip_6_3;
        real<lower=0,upper=1> penalty_7_1;
        real<lower=0,upper=1> slip_7_1;
        real<lower=0,upper=1> penalty_7_3;
        real<lower=0,upper=1> slip_7_3;
        real<lower=0,upper=1> penalty_8_2;
        real<lower=0,upper=1> slip_8_2;
        real<lower=0,upper=1> penalty_9_3;
        real<lower=0,upper=1> slip_9_3;
        real<lower=0,upper=1> penalty_10_1;
        real<lower=0,upper=1> slip_10_1;
        real<lower=0,upper=1> penalty_11_1;
        real<lower=0,upper=1> slip_11_1;
        real<lower=0,upper=1> penalty_11_3;
        real<lower=0,upper=1> slip_11_3;
        real<lower=0,upper=1> penalty_12_1;
        real<lower=0,upper=1> slip_12_1;
        real<lower=0,upper=1> penalty_12_3;
        real<lower=0,upper=1> slip_12_3;
        real<lower=0,upper=1> penalty_13_1;
        real<lower=0,upper=1> slip_13_1;
        real<lower=0,upper=1> penalty_14_1;
        real<lower=0,upper=1> slip_14_1;
        real<lower=0,upper=1> penalty_15_3;
        real<lower=0,upper=1> slip_15_3;
        real<lower=0,upper=1> penalty_16_1;
        real<lower=0,upper=1> slip_16_1;
        real<lower=0,upper=1> penalty_16_3;
        real<lower=0,upper=1> slip_16_3;
        real<lower=0,upper=1> penalty_17_2;
        real<lower=0,upper=1> slip_17_2;
        real<lower=0,upper=1> penalty_17_3;
        real<lower=0,upper=1> slip_17_3;
        real<lower=0,upper=1> penalty_18_3;
        real<lower=0,upper=1> slip_18_3;
        real<lower=0,upper=1> penalty_19_3;
        real<lower=0,upper=1> slip_19_3;
        real<lower=0,upper=1> penalty_20_1;
        real<lower=0,upper=1> slip_20_1;
        real<lower=0,upper=1> penalty_20_3;
        real<lower=0,upper=1> slip_20_3;
        real<lower=0,upper=1> penalty_21_1;
        real<lower=0,upper=1> slip_21_1;
        real<lower=0,upper=1> penalty_21_3;
        real<lower=0,upper=1> slip_21_3;
        real<lower=0,upper=1> penalty_22_3;
        real<lower=0,upper=1> slip_22_3;
        real<lower=0,upper=1> penalty_23_2;
        real<lower=0,upper=1> slip_23_2;
        real<lower=0,upper=1> penalty_24_2;
        real<lower=0,upper=1> slip_24_2;
        real<lower=0,upper=1> penalty_25_1;
        real<lower=0,upper=1> slip_25_1;
        real<lower=0,upper=1> penalty_26_3;
        real<lower=0,upper=1> slip_26_3;
        real<lower=0,upper=1> penalty_27_1;
        real<lower=0,upper=1> slip_27_1;
        real<lower=0,upper=1> penalty_28_3;
        real<lower=0,upper=1> slip_28_3;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = (1 - slip_1_1) * penalty_1_1 * (1 - slip_1_2) * penalty_1_2;
        pi[2,1] = (1 - slip_2_2) * penalty_2_2;
        pi[3,1] = (1 - slip_3_1) * penalty_3_1 * (1 - slip_3_3) * penalty_3_3;
        pi[4,1] = (1 - slip_4_3) * penalty_4_3;
        pi[5,1] = (1 - slip_5_3) * penalty_5_3;
        pi[6,1] = (1 - slip_6_3) * penalty_6_3;
        pi[7,1] = (1 - slip_7_1) * penalty_7_1 * (1 - slip_7_3) * penalty_7_3;
        pi[8,1] = (1 - slip_8_2) * penalty_8_2;
        pi[9,1] = (1 - slip_9_3) * penalty_9_3;
        pi[10,1] = (1 - slip_10_1) * penalty_10_1;
        pi[11,1] = (1 - slip_11_1) * penalty_11_1 * (1 - slip_11_3) * penalty_11_3;
        pi[12,1] = (1 - slip_12_1) * penalty_12_1 * (1 - slip_12_3) * penalty_12_3;
        pi[13,1] = (1 - slip_13_1) * penalty_13_1;
        pi[14,1] = (1 - slip_14_1) * penalty_14_1;
        pi[15,1] = (1 - slip_15_3) * penalty_15_3;
        pi[16,1] = (1 - slip_16_1) * penalty_16_1 * (1 - slip_16_3) * penalty_16_3;
        pi[17,1] = (1 - slip_17_2) * penalty_17_2 * (1 - slip_17_3) * penalty_17_3;
        pi[18,1] = (1 - slip_18_3) * penalty_18_3;
        pi[19,1] = (1 - slip_19_3) * penalty_19_3;
        pi[20,1] = (1 - slip_20_1) * penalty_20_1 * (1 - slip_20_3) * penalty_20_3;
        pi[21,1] = (1 - slip_21_1) * penalty_21_1 * (1 - slip_21_3) * penalty_21_3;
        pi[22,1] = (1 - slip_22_3) * penalty_22_3;
        pi[23,1] = (1 - slip_23_2) * penalty_23_2;
        pi[24,1] = (1 - slip_24_2) * penalty_24_2;
        pi[25,1] = (1 - slip_25_1) * penalty_25_1;
        pi[26,1] = (1 - slip_26_3) * penalty_26_3;
        pi[27,1] = (1 - slip_27_1) * penalty_27_1;
        pi[28,1] = (1 - slip_28_3) * penalty_28_3;
        pi[1,2] = (1 - slip_1_1) * (1 - slip_1_2) * penalty_1_2;
        pi[2,2] = (1 - slip_2_2) * penalty_2_2;
        pi[3,2] = (1 - slip_3_1) * (1 - slip_3_3) * penalty_3_3;
        pi[4,2] = (1 - slip_4_3) * penalty_4_3;
        pi[5,2] = (1 - slip_5_3) * penalty_5_3;
        pi[6,2] = (1 - slip_6_3) * penalty_6_3;
        pi[7,2] = (1 - slip_7_1) * (1 - slip_7_3) * penalty_7_3;
        pi[8,2] = (1 - slip_8_2) * penalty_8_2;
        pi[9,2] = (1 - slip_9_3) * penalty_9_3;
        pi[10,2] = (1 - slip_10_1);
        pi[11,2] = (1 - slip_11_1) * (1 - slip_11_3) * penalty_11_3;
        pi[12,2] = (1 - slip_12_1) * (1 - slip_12_3) * penalty_12_3;
        pi[13,2] = (1 - slip_13_1);
        pi[14,2] = (1 - slip_14_1);
        pi[15,2] = (1 - slip_15_3) * penalty_15_3;
        pi[16,2] = (1 - slip_16_1) * (1 - slip_16_3) * penalty_16_3;
        pi[17,2] = (1 - slip_17_2) * penalty_17_2 * (1 - slip_17_3) * penalty_17_3;
        pi[18,2] = (1 - slip_18_3) * penalty_18_3;
        pi[19,2] = (1 - slip_19_3) * penalty_19_3;
        pi[20,2] = (1 - slip_20_1) * (1 - slip_20_3) * penalty_20_3;
        pi[21,2] = (1 - slip_21_1) * (1 - slip_21_3) * penalty_21_3;
        pi[22,2] = (1 - slip_22_3) * penalty_22_3;
        pi[23,2] = (1 - slip_23_2) * penalty_23_2;
        pi[24,2] = (1 - slip_24_2) * penalty_24_2;
        pi[25,2] = (1 - slip_25_1);
        pi[26,2] = (1 - slip_26_3) * penalty_26_3;
        pi[27,2] = (1 - slip_27_1);
        pi[28,2] = (1 - slip_28_3) * penalty_28_3;
        pi[1,3] = (1 - slip_1_1) * penalty_1_1 * (1 - slip_1_2);
        pi[2,3] = (1 - slip_2_2);
        pi[3,3] = (1 - slip_3_1) * penalty_3_1 * (1 - slip_3_3) * penalty_3_3;
        pi[4,3] = (1 - slip_4_3) * penalty_4_3;
        pi[5,3] = (1 - slip_5_3) * penalty_5_3;
        pi[6,3] = (1 - slip_6_3) * penalty_6_3;
        pi[7,3] = (1 - slip_7_1) * penalty_7_1 * (1 - slip_7_3) * penalty_7_3;
        pi[8,3] = (1 - slip_8_2);
        pi[9,3] = (1 - slip_9_3) * penalty_9_3;
        pi[10,3] = (1 - slip_10_1) * penalty_10_1;
        pi[11,3] = (1 - slip_11_1) * penalty_11_1 * (1 - slip_11_3) * penalty_11_3;
        pi[12,3] = (1 - slip_12_1) * penalty_12_1 * (1 - slip_12_3) * penalty_12_3;
        pi[13,3] = (1 - slip_13_1) * penalty_13_1;
        pi[14,3] = (1 - slip_14_1) * penalty_14_1;
        pi[15,3] = (1 - slip_15_3) * penalty_15_3;
        pi[16,3] = (1 - slip_16_1) * penalty_16_1 * (1 - slip_16_3) * penalty_16_3;
        pi[17,3] = (1 - slip_17_2) * (1 - slip_17_3) * penalty_17_3;
        pi[18,3] = (1 - slip_18_3) * penalty_18_3;
        pi[19,3] = (1 - slip_19_3) * penalty_19_3;
        pi[20,3] = (1 - slip_20_1) * penalty_20_1 * (1 - slip_20_3) * penalty_20_3;
        pi[21,3] = (1 - slip_21_1) * penalty_21_1 * (1 - slip_21_3) * penalty_21_3;
        pi[22,3] = (1 - slip_22_3) * penalty_22_3;
        pi[23,3] = (1 - slip_23_2);
        pi[24,3] = (1 - slip_24_2);
        pi[25,3] = (1 - slip_25_1) * penalty_25_1;
        pi[26,3] = (1 - slip_26_3) * penalty_26_3;
        pi[27,3] = (1 - slip_27_1) * penalty_27_1;
        pi[28,3] = (1 - slip_28_3) * penalty_28_3;
        pi[1,4] = (1 - slip_1_1) * penalty_1_1 * (1 - slip_1_2) * penalty_1_2;
        pi[2,4] = (1 - slip_2_2) * penalty_2_2;
        pi[3,4] = (1 - slip_3_1) * penalty_3_1 * (1 - slip_3_3);
        pi[4,4] = (1 - slip_4_3);
        pi[5,4] = (1 - slip_5_3);
        pi[6,4] = (1 - slip_6_3);
        pi[7,4] = (1 - slip_7_1) * penalty_7_1 * (1 - slip_7_3);
        pi[8,4] = (1 - slip_8_2) * penalty_8_2;
        pi[9,4] = (1 - slip_9_3);
        pi[10,4] = (1 - slip_10_1) * penalty_10_1;
        pi[11,4] = (1 - slip_11_1) * penalty_11_1 * (1 - slip_11_3);
        pi[12,4] = (1 - slip_12_1) * penalty_12_1 * (1 - slip_12_3);
        pi[13,4] = (1 - slip_13_1) * penalty_13_1;
        pi[14,4] = (1 - slip_14_1) * penalty_14_1;
        pi[15,4] = (1 - slip_15_3);
        pi[16,4] = (1 - slip_16_1) * penalty_16_1 * (1 - slip_16_3);
        pi[17,4] = (1 - slip_17_2) * penalty_17_2 * (1 - slip_17_3);
        pi[18,4] = (1 - slip_18_3);
        pi[19,4] = (1 - slip_19_3);
        pi[20,4] = (1 - slip_20_1) * penalty_20_1 * (1 - slip_20_3);
        pi[21,4] = (1 - slip_21_1) * penalty_21_1 * (1 - slip_21_3);
        pi[22,4] = (1 - slip_22_3);
        pi[23,4] = (1 - slip_23_2) * penalty_23_2;
        pi[24,4] = (1 - slip_24_2) * penalty_24_2;
        pi[25,4] = (1 - slip_25_1) * penalty_25_1;
        pi[26,4] = (1 - slip_26_3);
        pi[27,4] = (1 - slip_27_1) * penalty_27_1;
        pi[28,4] = (1 - slip_28_3);
        pi[1,5] = (1 - slip_1_1) * (1 - slip_1_2);
        pi[2,5] = (1 - slip_2_2);
        pi[3,5] = (1 - slip_3_1) * (1 - slip_3_3) * penalty_3_3;
        pi[4,5] = (1 - slip_4_3) * penalty_4_3;
        pi[5,5] = (1 - slip_5_3) * penalty_5_3;
        pi[6,5] = (1 - slip_6_3) * penalty_6_3;
        pi[7,5] = (1 - slip_7_1) * (1 - slip_7_3) * penalty_7_3;
        pi[8,5] = (1 - slip_8_2);
        pi[9,5] = (1 - slip_9_3) * penalty_9_3;
        pi[10,5] = (1 - slip_10_1);
        pi[11,5] = (1 - slip_11_1) * (1 - slip_11_3) * penalty_11_3;
        pi[12,5] = (1 - slip_12_1) * (1 - slip_12_3) * penalty_12_3;
        pi[13,5] = (1 - slip_13_1);
        pi[14,5] = (1 - slip_14_1);
        pi[15,5] = (1 - slip_15_3) * penalty_15_3;
        pi[16,5] = (1 - slip_16_1) * (1 - slip_16_3) * penalty_16_3;
        pi[17,5] = (1 - slip_17_2) * (1 - slip_17_3) * penalty_17_3;
        pi[18,5] = (1 - slip_18_3) * penalty_18_3;
        pi[19,5] = (1 - slip_19_3) * penalty_19_3;
        pi[20,5] = (1 - slip_20_1) * (1 - slip_20_3) * penalty_20_3;
        pi[21,5] = (1 - slip_21_1) * (1 - slip_21_3) * penalty_21_3;
        pi[22,5] = (1 - slip_22_3) * penalty_22_3;
        pi[23,5] = (1 - slip_23_2);
        pi[24,5] = (1 - slip_24_2);
        pi[25,5] = (1 - slip_25_1);
        pi[26,5] = (1 - slip_26_3) * penalty_26_3;
        pi[27,5] = (1 - slip_27_1);
        pi[28,5] = (1 - slip_28_3) * penalty_28_3;
        pi[1,6] = (1 - slip_1_1) * (1 - slip_1_2) * penalty_1_2;
        pi[2,6] = (1 - slip_2_2) * penalty_2_2;
        pi[3,6] = (1 - slip_3_1) * (1 - slip_3_3);
        pi[4,6] = (1 - slip_4_3);
        pi[5,6] = (1 - slip_5_3);
        pi[6,6] = (1 - slip_6_3);
        pi[7,6] = (1 - slip_7_1) * (1 - slip_7_3);
        pi[8,6] = (1 - slip_8_2) * penalty_8_2;
        pi[9,6] = (1 - slip_9_3);
        pi[10,6] = (1 - slip_10_1);
        pi[11,6] = (1 - slip_11_1) * (1 - slip_11_3);
        pi[12,6] = (1 - slip_12_1) * (1 - slip_12_3);
        pi[13,6] = (1 - slip_13_1);
        pi[14,6] = (1 - slip_14_1);
        pi[15,6] = (1 - slip_15_3);
        pi[16,6] = (1 - slip_16_1) * (1 - slip_16_3);
        pi[17,6] = (1 - slip_17_2) * penalty_17_2 * (1 - slip_17_3);
        pi[18,6] = (1 - slip_18_3);
        pi[19,6] = (1 - slip_19_3);
        pi[20,6] = (1 - slip_20_1) * (1 - slip_20_3);
        pi[21,6] = (1 - slip_21_1) * (1 - slip_21_3);
        pi[22,6] = (1 - slip_22_3);
        pi[23,6] = (1 - slip_23_2) * penalty_23_2;
        pi[24,6] = (1 - slip_24_2) * penalty_24_2;
        pi[25,6] = (1 - slip_25_1);
        pi[26,6] = (1 - slip_26_3);
        pi[27,6] = (1 - slip_27_1);
        pi[28,6] = (1 - slip_28_3);
        pi[1,7] = (1 - slip_1_1) * penalty_1_1 * (1 - slip_1_2);
        pi[2,7] = (1 - slip_2_2);
        pi[3,7] = (1 - slip_3_1) * penalty_3_1 * (1 - slip_3_3);
        pi[4,7] = (1 - slip_4_3);
        pi[5,7] = (1 - slip_5_3);
        pi[6,7] = (1 - slip_6_3);
        pi[7,7] = (1 - slip_7_1) * penalty_7_1 * (1 - slip_7_3);
        pi[8,7] = (1 - slip_8_2);
        pi[9,7] = (1 - slip_9_3);
        pi[10,7] = (1 - slip_10_1) * penalty_10_1;
        pi[11,7] = (1 - slip_11_1) * penalty_11_1 * (1 - slip_11_3);
        pi[12,7] = (1 - slip_12_1) * penalty_12_1 * (1 - slip_12_3);
        pi[13,7] = (1 - slip_13_1) * penalty_13_1;
        pi[14,7] = (1 - slip_14_1) * penalty_14_1;
        pi[15,7] = (1 - slip_15_3);
        pi[16,7] = (1 - slip_16_1) * penalty_16_1 * (1 - slip_16_3);
        pi[17,7] = (1 - slip_17_2) * (1 - slip_17_3);
        pi[18,7] = (1 - slip_18_3);
        pi[19,7] = (1 - slip_19_3);
        pi[20,7] = (1 - slip_20_1) * penalty_20_1 * (1 - slip_20_3);
        pi[21,7] = (1 - slip_21_1) * penalty_21_1 * (1 - slip_21_3);
        pi[22,7] = (1 - slip_22_3);
        pi[23,7] = (1 - slip_23_2);
        pi[24,7] = (1 - slip_24_2);
        pi[25,7] = (1 - slip_25_1) * penalty_25_1;
        pi[26,7] = (1 - slip_26_3);
        pi[27,7] = (1 - slip_27_1) * penalty_27_1;
        pi[28,7] = (1 - slip_28_3);
        pi[1,8] = (1 - slip_1_1) * (1 - slip_1_2);
        pi[2,8] = (1 - slip_2_2);
        pi[3,8] = (1 - slip_3_1) * (1 - slip_3_3);
        pi[4,8] = (1 - slip_4_3);
        pi[5,8] = (1 - slip_5_3);
        pi[6,8] = (1 - slip_6_3);
        pi[7,8] = (1 - slip_7_1) * (1 - slip_7_3);
        pi[8,8] = (1 - slip_8_2);
        pi[9,8] = (1 - slip_9_3);
        pi[10,8] = (1 - slip_10_1);
        pi[11,8] = (1 - slip_11_1) * (1 - slip_11_3);
        pi[12,8] = (1 - slip_12_1) * (1 - slip_12_3);
        pi[13,8] = (1 - slip_13_1);
        pi[14,8] = (1 - slip_14_1);
        pi[15,8] = (1 - slip_15_3);
        pi[16,8] = (1 - slip_16_1) * (1 - slip_16_3);
        pi[17,8] = (1 - slip_17_2) * (1 - slip_17_3);
        pi[18,8] = (1 - slip_18_3);
        pi[19,8] = (1 - slip_19_3);
        pi[20,8] = (1 - slip_20_1) * (1 - slip_20_3);
        pi[21,8] = (1 - slip_21_1) * (1 - slip_21_3);
        pi[22,8] = (1 - slip_22_3);
        pi[23,8] = (1 - slip_23_2);
        pi[24,8] = (1 - slip_24_2);
        pi[25,8] = (1 - slip_25_1);
        pi[26,8] = (1 - slip_26_3);
        pi[27,8] = (1 - slip_27_1);
        pi[28,8] = (1 - slip_28_3);
      }
      model {
      
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        penalty_1_1 ~ beta(5, 25);
        slip_1_1 ~ beta(5, 25);
        penalty_1_2 ~ beta(5, 25);
        slip_1_2 ~ beta(5, 25);
        penalty_2_2 ~ beta(5, 25);
        slip_2_2 ~ beta(5, 25);
        penalty_3_1 ~ beta(5, 25);
        slip_3_1 ~ beta(5, 25);
        penalty_3_3 ~ beta(5, 25);
        slip_3_3 ~ beta(5, 25);
        penalty_4_3 ~ beta(5, 25);
        slip_4_3 ~ beta(5, 25);
        penalty_5_3 ~ beta(5, 25);
        slip_5_3 ~ beta(5, 25);
        penalty_6_3 ~ beta(5, 25);
        slip_6_3 ~ beta(5, 25);
        penalty_7_1 ~ beta(5, 25);
        slip_7_1 ~ beta(5, 25);
        penalty_7_3 ~ beta(5, 25);
        slip_7_3 ~ beta(5, 25);
        penalty_8_2 ~ beta(5, 25);
        slip_8_2 ~ beta(5, 25);
        penalty_9_3 ~ beta(5, 25);
        slip_9_3 ~ beta(5, 25);
        penalty_10_1 ~ beta(5, 25);
        slip_10_1 ~ beta(5, 25);
        penalty_11_1 ~ beta(5, 25);
        slip_11_1 ~ beta(5, 25);
        penalty_11_3 ~ beta(5, 25);
        slip_11_3 ~ beta(5, 25);
        penalty_12_1 ~ beta(5, 25);
        slip_12_1 ~ beta(5, 25);
        penalty_12_3 ~ beta(5, 25);
        slip_12_3 ~ beta(5, 25);
        penalty_13_1 ~ beta(5, 25);
        slip_13_1 ~ beta(5, 25);
        penalty_14_1 ~ beta(5, 25);
        slip_14_1 ~ beta(5, 25);
        penalty_15_3 ~ beta(5, 25);
        slip_15_3 ~ beta(5, 25);
        penalty_16_1 ~ beta(5, 25);
        slip_16_1 ~ beta(5, 25);
        penalty_16_3 ~ beta(5, 25);
        slip_16_3 ~ beta(5, 25);
        penalty_17_2 ~ beta(5, 25);
        slip_17_2 ~ beta(5, 25);
        penalty_17_3 ~ beta(5, 25);
        slip_17_3 ~ beta(5, 25);
        penalty_18_3 ~ beta(5, 25);
        slip_18_3 ~ beta(5, 25);
        penalty_19_3 ~ beta(5, 25);
        slip_19_3 ~ beta(5, 25);
        penalty_20_1 ~ beta(5, 25);
        slip_20_1 ~ beta(5, 25);
        penalty_20_3 ~ beta(5, 25);
        slip_20_3 ~ beta(5, 25);
        penalty_21_1 ~ beta(5, 25);
        slip_21_1 ~ beta(5, 25);
        penalty_21_3 ~ beta(5, 25);
        slip_21_3 ~ beta(5, 25);
        penalty_22_3 ~ beta(5, 25);
        slip_22_3 ~ beta(5, 25);
        penalty_23_2 ~ beta(5, 25);
        slip_23_2 ~ beta(5, 25);
        penalty_24_2 ~ beta(5, 25);
        slip_24_2 ~ beta(5, 25);
        penalty_25_1 ~ beta(5, 25);
        slip_25_1 ~ beta(5, 25);
        penalty_26_3 ~ beta(5, 25);
        slip_26_3 ~ beta(5, 25);
        penalty_27_1 ~ beta(5, 25);
        slip_27_1 ~ beta(5, 25);
        penalty_28_3 ~ beta(5, 25);
        slip_28_3 ~ beta(5, 25);
      
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
        simplex[C] Vc;                  // base rates of class membership
      
        ////////////////////////////////// parameters
        real<lower=0,upper=1> penalty_1_1;
        real<lower=0,upper=1> slip_1_1;
        real<lower=0,upper=1> penalty_2_1;
        real<lower=0,upper=1> slip_2_1;
        real<lower=0,upper=1> penalty_3_1;
        real<lower=0,upper=1> slip_3_1;
        real<lower=0,upper=1> penalty_4_1;
        real<lower=0,upper=1> slip_4_1;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = (1 - slip_1_1) * penalty_1_1;
        pi[2,1] = (1 - slip_2_1) * penalty_2_1;
        pi[3,1] = (1 - slip_3_1) * penalty_3_1;
        pi[4,1] = (1 - slip_4_1) * penalty_4_1;
        pi[1,2] = (1 - slip_1_1);
        pi[2,2] = (1 - slip_2_1);
        pi[3,2] = (1 - slip_3_1);
        pi[4,2] = (1 - slip_4_1);
      }
      model {
      
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        penalty_1_1 ~ beta(5, 25);
        slip_1_1 ~ beta(5, 25);
        penalty_2_1 ~ beta(5, 25);
        slip_2_1 ~ beta(5, 25);
        penalty_3_1 ~ beta(5, 25);
        slip_3_1 ~ beta(5, 25);
        penalty_4_1 ~ beta(5, 25);
        slip_4_1 ~ beta(5, 25);
      
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
        simplex[C] Vc;                  // base rates of class membership
      
        ////////////////////////////////// parameters
        real<lower=0,upper=1> penalty_1_1;
        real<lower=0,upper=1> slip_1_1;
        real<lower=0,upper=1> penalty_2_3;
        real<lower=0,upper=1> slip_2_3;
        real<lower=0,upper=1> penalty_3_2;
        real<lower=0,upper=1> slip_3_2;
        real<lower=0,upper=1> penalty_4_1;
        real<lower=0,upper=1> slip_4_1;
        real<lower=0,upper=1> penalty_5_1;
        real<lower=0,upper=1> slip_5_1;
        real<lower=0,upper=1> penalty_6_2;
        real<lower=0,upper=1> slip_6_2;
        real<lower=0,upper=1> penalty_7_1;
        real<lower=0,upper=1> slip_7_1;
        real<lower=0,upper=1> penalty_8_3;
        real<lower=0,upper=1> slip_8_3;
        real<lower=0,upper=1> penalty_9_3;
        real<lower=0,upper=1> slip_9_3;
        real<lower=0,upper=1> penalty_10_3;
        real<lower=0,upper=1> slip_10_3;
        real<lower=0,upper=1> penalty_11_3;
        real<lower=0,upper=1> slip_11_3;
        real<lower=0,upper=1> penalty_12_1;
        real<lower=0,upper=1> slip_12_1;
        real<lower=0,upper=1> penalty_13_4;
        real<lower=0,upper=1> slip_13_4;
        real<lower=0,upper=1> penalty_14_1;
        real<lower=0,upper=1> slip_14_1;
        real<lower=0,upper=1> penalty_14_4;
        real<lower=0,upper=1> slip_14_4;
        real<lower=0,upper=1> penalty_15_1;
        real<lower=0,upper=1> slip_15_1;
        real<lower=0,upper=1> penalty_15_4;
        real<lower=0,upper=1> slip_15_4;
        real<lower=0,upper=1> penalty_16_1;
        real<lower=0,upper=1> slip_16_1;
        real<lower=0,upper=1> penalty_17_1;
        real<lower=0,upper=1> slip_17_1;
        real<lower=0,upper=1> penalty_18_2;
        real<lower=0,upper=1> slip_18_2;
        real<lower=0,upper=1> penalty_18_4;
        real<lower=0,upper=1> slip_18_4;
        real<lower=0,upper=1> penalty_19_1;
        real<lower=0,upper=1> slip_19_1;
        real<lower=0,upper=1> penalty_19_2;
        real<lower=0,upper=1> slip_19_2;
        real<lower=0,upper=1> penalty_20_2;
        real<lower=0,upper=1> slip_20_2;
        real<lower=0,upper=1> penalty_20_4;
        real<lower=0,upper=1> slip_20_4;
        real<lower=0,upper=1> penalty_21_2;
        real<lower=0,upper=1> slip_21_2;
        real<lower=0,upper=1> penalty_22_2;
        real<lower=0,upper=1> slip_22_2;
        real<lower=0,upper=1> penalty_23_1;
        real<lower=0,upper=1> slip_23_1;
        real<lower=0,upper=1> penalty_24_1;
        real<lower=0,upper=1> slip_24_1;
        real<lower=0,upper=1> penalty_24_2;
        real<lower=0,upper=1> slip_24_2;
        real<lower=0,upper=1> penalty_25_1;
        real<lower=0,upper=1> slip_25_1;
        real<lower=0,upper=1> penalty_25_2;
        real<lower=0,upper=1> slip_25_2;
        real<lower=0,upper=1> penalty_26_1;
        real<lower=0,upper=1> slip_26_1;
        real<lower=0,upper=1> penalty_27_1;
        real<lower=0,upper=1> slip_27_1;
        real<lower=0,upper=1> penalty_27_2;
        real<lower=0,upper=1> slip_27_2;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = (1 - slip_1_1) * penalty_1_1;
        pi[2,1] = (1 - slip_2_3) * penalty_2_3;
        pi[3,1] = (1 - slip_3_2) * penalty_3_2;
        pi[4,1] = (1 - slip_4_1) * penalty_4_1;
        pi[5,1] = (1 - slip_5_1) * penalty_5_1;
        pi[6,1] = (1 - slip_6_2) * penalty_6_2;
        pi[7,1] = (1 - slip_7_1) * penalty_7_1;
        pi[8,1] = (1 - slip_8_3) * penalty_8_3;
        pi[9,1] = (1 - slip_9_3) * penalty_9_3;
        pi[10,1] = (1 - slip_10_3) * penalty_10_3;
        pi[11,1] = (1 - slip_11_3) * penalty_11_3;
        pi[12,1] = (1 - slip_12_1) * penalty_12_1;
        pi[13,1] = (1 - slip_13_4) * penalty_13_4;
        pi[14,1] = (1 - slip_14_1) * penalty_14_1 * (1 - slip_14_4) * penalty_14_4;
        pi[15,1] = (1 - slip_15_1) * penalty_15_1 * (1 - slip_15_4) * penalty_15_4;
        pi[16,1] = (1 - slip_16_1) * penalty_16_1;
        pi[17,1] = (1 - slip_17_1) * penalty_17_1;
        pi[18,1] = (1 - slip_18_2) * penalty_18_2 * (1 - slip_18_4) * penalty_18_4;
        pi[19,1] = (1 - slip_19_1) * penalty_19_1 * (1 - slip_19_2) * penalty_19_2;
        pi[20,1] = (1 - slip_20_2) * penalty_20_2 * (1 - slip_20_4) * penalty_20_4;
        pi[21,1] = (1 - slip_21_2) * penalty_21_2;
        pi[22,1] = (1 - slip_22_2) * penalty_22_2;
        pi[23,1] = (1 - slip_23_1) * penalty_23_1;
        pi[24,1] = (1 - slip_24_1) * penalty_24_1 * (1 - slip_24_2) * penalty_24_2;
        pi[25,1] = (1 - slip_25_1) * penalty_25_1 * (1 - slip_25_2) * penalty_25_2;
        pi[26,1] = (1 - slip_26_1) * penalty_26_1;
        pi[27,1] = (1 - slip_27_1) * penalty_27_1 * (1 - slip_27_2) * penalty_27_2;
        pi[1,2] = (1 - slip_1_1);
        pi[2,2] = (1 - slip_2_3) * penalty_2_3;
        pi[3,2] = (1 - slip_3_2) * penalty_3_2;
        pi[4,2] = (1 - slip_4_1);
        pi[5,2] = (1 - slip_5_1);
        pi[6,2] = (1 - slip_6_2) * penalty_6_2;
        pi[7,2] = (1 - slip_7_1);
        pi[8,2] = (1 - slip_8_3) * penalty_8_3;
        pi[9,2] = (1 - slip_9_3) * penalty_9_3;
        pi[10,2] = (1 - slip_10_3) * penalty_10_3;
        pi[11,2] = (1 - slip_11_3) * penalty_11_3;
        pi[12,2] = (1 - slip_12_1);
        pi[13,2] = (1 - slip_13_4) * penalty_13_4;
        pi[14,2] = (1 - slip_14_1) * (1 - slip_14_4) * penalty_14_4;
        pi[15,2] = (1 - slip_15_1) * (1 - slip_15_4) * penalty_15_4;
        pi[16,2] = (1 - slip_16_1);
        pi[17,2] = (1 - slip_17_1);
        pi[18,2] = (1 - slip_18_2) * penalty_18_2 * (1 - slip_18_4) * penalty_18_4;
        pi[19,2] = (1 - slip_19_1) * (1 - slip_19_2) * penalty_19_2;
        pi[20,2] = (1 - slip_20_2) * penalty_20_2 * (1 - slip_20_4) * penalty_20_4;
        pi[21,2] = (1 - slip_21_2) * penalty_21_2;
        pi[22,2] = (1 - slip_22_2) * penalty_22_2;
        pi[23,2] = (1 - slip_23_1);
        pi[24,2] = (1 - slip_24_1) * (1 - slip_24_2) * penalty_24_2;
        pi[25,2] = (1 - slip_25_1) * (1 - slip_25_2) * penalty_25_2;
        pi[26,2] = (1 - slip_26_1);
        pi[27,2] = (1 - slip_27_1) * (1 - slip_27_2) * penalty_27_2;
        pi[1,3] = (1 - slip_1_1) * penalty_1_1;
        pi[2,3] = (1 - slip_2_3) * penalty_2_3;
        pi[3,3] = (1 - slip_3_2);
        pi[4,3] = (1 - slip_4_1) * penalty_4_1;
        pi[5,3] = (1 - slip_5_1) * penalty_5_1;
        pi[6,3] = (1 - slip_6_2);
        pi[7,3] = (1 - slip_7_1) * penalty_7_1;
        pi[8,3] = (1 - slip_8_3) * penalty_8_3;
        pi[9,3] = (1 - slip_9_3) * penalty_9_3;
        pi[10,3] = (1 - slip_10_3) * penalty_10_3;
        pi[11,3] = (1 - slip_11_3) * penalty_11_3;
        pi[12,3] = (1 - slip_12_1) * penalty_12_1;
        pi[13,3] = (1 - slip_13_4) * penalty_13_4;
        pi[14,3] = (1 - slip_14_1) * penalty_14_1 * (1 - slip_14_4) * penalty_14_4;
        pi[15,3] = (1 - slip_15_1) * penalty_15_1 * (1 - slip_15_4) * penalty_15_4;
        pi[16,3] = (1 - slip_16_1) * penalty_16_1;
        pi[17,3] = (1 - slip_17_1) * penalty_17_1;
        pi[18,3] = (1 - slip_18_2) * (1 - slip_18_4) * penalty_18_4;
        pi[19,3] = (1 - slip_19_1) * penalty_19_1 * (1 - slip_19_2);
        pi[20,3] = (1 - slip_20_2) * (1 - slip_20_4) * penalty_20_4;
        pi[21,3] = (1 - slip_21_2);
        pi[22,3] = (1 - slip_22_2);
        pi[23,3] = (1 - slip_23_1) * penalty_23_1;
        pi[24,3] = (1 - slip_24_1) * penalty_24_1 * (1 - slip_24_2);
        pi[25,3] = (1 - slip_25_1) * penalty_25_1 * (1 - slip_25_2);
        pi[26,3] = (1 - slip_26_1) * penalty_26_1;
        pi[27,3] = (1 - slip_27_1) * penalty_27_1 * (1 - slip_27_2);
        pi[1,4] = (1 - slip_1_1) * penalty_1_1;
        pi[2,4] = (1 - slip_2_3);
        pi[3,4] = (1 - slip_3_2) * penalty_3_2;
        pi[4,4] = (1 - slip_4_1) * penalty_4_1;
        pi[5,4] = (1 - slip_5_1) * penalty_5_1;
        pi[6,4] = (1 - slip_6_2) * penalty_6_2;
        pi[7,4] = (1 - slip_7_1) * penalty_7_1;
        pi[8,4] = (1 - slip_8_3);
        pi[9,4] = (1 - slip_9_3);
        pi[10,4] = (1 - slip_10_3);
        pi[11,4] = (1 - slip_11_3);
        pi[12,4] = (1 - slip_12_1) * penalty_12_1;
        pi[13,4] = (1 - slip_13_4) * penalty_13_4;
        pi[14,4] = (1 - slip_14_1) * penalty_14_1 * (1 - slip_14_4) * penalty_14_4;
        pi[15,4] = (1 - slip_15_1) * penalty_15_1 * (1 - slip_15_4) * penalty_15_4;
        pi[16,4] = (1 - slip_16_1) * penalty_16_1;
        pi[17,4] = (1 - slip_17_1) * penalty_17_1;
        pi[18,4] = (1 - slip_18_2) * penalty_18_2 * (1 - slip_18_4) * penalty_18_4;
        pi[19,4] = (1 - slip_19_1) * penalty_19_1 * (1 - slip_19_2) * penalty_19_2;
        pi[20,4] = (1 - slip_20_2) * penalty_20_2 * (1 - slip_20_4) * penalty_20_4;
        pi[21,4] = (1 - slip_21_2) * penalty_21_2;
        pi[22,4] = (1 - slip_22_2) * penalty_22_2;
        pi[23,4] = (1 - slip_23_1) * penalty_23_1;
        pi[24,4] = (1 - slip_24_1) * penalty_24_1 * (1 - slip_24_2) * penalty_24_2;
        pi[25,4] = (1 - slip_25_1) * penalty_25_1 * (1 - slip_25_2) * penalty_25_2;
        pi[26,4] = (1 - slip_26_1) * penalty_26_1;
        pi[27,4] = (1 - slip_27_1) * penalty_27_1 * (1 - slip_27_2) * penalty_27_2;
        pi[1,5] = (1 - slip_1_1) * penalty_1_1;
        pi[2,5] = (1 - slip_2_3) * penalty_2_3;
        pi[3,5] = (1 - slip_3_2) * penalty_3_2;
        pi[4,5] = (1 - slip_4_1) * penalty_4_1;
        pi[5,5] = (1 - slip_5_1) * penalty_5_1;
        pi[6,5] = (1 - slip_6_2) * penalty_6_2;
        pi[7,5] = (1 - slip_7_1) * penalty_7_1;
        pi[8,5] = (1 - slip_8_3) * penalty_8_3;
        pi[9,5] = (1 - slip_9_3) * penalty_9_3;
        pi[10,5] = (1 - slip_10_3) * penalty_10_3;
        pi[11,5] = (1 - slip_11_3) * penalty_11_3;
        pi[12,5] = (1 - slip_12_1) * penalty_12_1;
        pi[13,5] = (1 - slip_13_4);
        pi[14,5] = (1 - slip_14_1) * penalty_14_1 * (1 - slip_14_4);
        pi[15,5] = (1 - slip_15_1) * penalty_15_1 * (1 - slip_15_4);
        pi[16,5] = (1 - slip_16_1) * penalty_16_1;
        pi[17,5] = (1 - slip_17_1) * penalty_17_1;
        pi[18,5] = (1 - slip_18_2) * penalty_18_2 * (1 - slip_18_4);
        pi[19,5] = (1 - slip_19_1) * penalty_19_1 * (1 - slip_19_2) * penalty_19_2;
        pi[20,5] = (1 - slip_20_2) * penalty_20_2 * (1 - slip_20_4);
        pi[21,5] = (1 - slip_21_2) * penalty_21_2;
        pi[22,5] = (1 - slip_22_2) * penalty_22_2;
        pi[23,5] = (1 - slip_23_1) * penalty_23_1;
        pi[24,5] = (1 - slip_24_1) * penalty_24_1 * (1 - slip_24_2) * penalty_24_2;
        pi[25,5] = (1 - slip_25_1) * penalty_25_1 * (1 - slip_25_2) * penalty_25_2;
        pi[26,5] = (1 - slip_26_1) * penalty_26_1;
        pi[27,5] = (1 - slip_27_1) * penalty_27_1 * (1 - slip_27_2) * penalty_27_2;
        pi[1,6] = (1 - slip_1_1);
        pi[2,6] = (1 - slip_2_3) * penalty_2_3;
        pi[3,6] = (1 - slip_3_2);
        pi[4,6] = (1 - slip_4_1);
        pi[5,6] = (1 - slip_5_1);
        pi[6,6] = (1 - slip_6_2);
        pi[7,6] = (1 - slip_7_1);
        pi[8,6] = (1 - slip_8_3) * penalty_8_3;
        pi[9,6] = (1 - slip_9_3) * penalty_9_3;
        pi[10,6] = (1 - slip_10_3) * penalty_10_3;
        pi[11,6] = (1 - slip_11_3) * penalty_11_3;
        pi[12,6] = (1 - slip_12_1);
        pi[13,6] = (1 - slip_13_4) * penalty_13_4;
        pi[14,6] = (1 - slip_14_1) * (1 - slip_14_4) * penalty_14_4;
        pi[15,6] = (1 - slip_15_1) * (1 - slip_15_4) * penalty_15_4;
        pi[16,6] = (1 - slip_16_1);
        pi[17,6] = (1 - slip_17_1);
        pi[18,6] = (1 - slip_18_2) * (1 - slip_18_4) * penalty_18_4;
        pi[19,6] = (1 - slip_19_1) * (1 - slip_19_2);
        pi[20,6] = (1 - slip_20_2) * (1 - slip_20_4) * penalty_20_4;
        pi[21,6] = (1 - slip_21_2);
        pi[22,6] = (1 - slip_22_2);
        pi[23,6] = (1 - slip_23_1);
        pi[24,6] = (1 - slip_24_1) * (1 - slip_24_2);
        pi[25,6] = (1 - slip_25_1) * (1 - slip_25_2);
        pi[26,6] = (1 - slip_26_1);
        pi[27,6] = (1 - slip_27_1) * (1 - slip_27_2);
        pi[1,7] = (1 - slip_1_1);
        pi[2,7] = (1 - slip_2_3);
        pi[3,7] = (1 - slip_3_2) * penalty_3_2;
        pi[4,7] = (1 - slip_4_1);
        pi[5,7] = (1 - slip_5_1);
        pi[6,7] = (1 - slip_6_2) * penalty_6_2;
        pi[7,7] = (1 - slip_7_1);
        pi[8,7] = (1 - slip_8_3);
        pi[9,7] = (1 - slip_9_3);
        pi[10,7] = (1 - slip_10_3);
        pi[11,7] = (1 - slip_11_3);
        pi[12,7] = (1 - slip_12_1);
        pi[13,7] = (1 - slip_13_4) * penalty_13_4;
        pi[14,7] = (1 - slip_14_1) * (1 - slip_14_4) * penalty_14_4;
        pi[15,7] = (1 - slip_15_1) * (1 - slip_15_4) * penalty_15_4;
        pi[16,7] = (1 - slip_16_1);
        pi[17,7] = (1 - slip_17_1);
        pi[18,7] = (1 - slip_18_2) * penalty_18_2 * (1 - slip_18_4) * penalty_18_4;
        pi[19,7] = (1 - slip_19_1) * (1 - slip_19_2) * penalty_19_2;
        pi[20,7] = (1 - slip_20_2) * penalty_20_2 * (1 - slip_20_4) * penalty_20_4;
        pi[21,7] = (1 - slip_21_2) * penalty_21_2;
        pi[22,7] = (1 - slip_22_2) * penalty_22_2;
        pi[23,7] = (1 - slip_23_1);
        pi[24,7] = (1 - slip_24_1) * (1 - slip_24_2) * penalty_24_2;
        pi[25,7] = (1 - slip_25_1) * (1 - slip_25_2) * penalty_25_2;
        pi[26,7] = (1 - slip_26_1);
        pi[27,7] = (1 - slip_27_1) * (1 - slip_27_2) * penalty_27_2;
        pi[1,8] = (1 - slip_1_1);
        pi[2,8] = (1 - slip_2_3) * penalty_2_3;
        pi[3,8] = (1 - slip_3_2) * penalty_3_2;
        pi[4,8] = (1 - slip_4_1);
        pi[5,8] = (1 - slip_5_1);
        pi[6,8] = (1 - slip_6_2) * penalty_6_2;
        pi[7,8] = (1 - slip_7_1);
        pi[8,8] = (1 - slip_8_3) * penalty_8_3;
        pi[9,8] = (1 - slip_9_3) * penalty_9_3;
        pi[10,8] = (1 - slip_10_3) * penalty_10_3;
        pi[11,8] = (1 - slip_11_3) * penalty_11_3;
        pi[12,8] = (1 - slip_12_1);
        pi[13,8] = (1 - slip_13_4);
        pi[14,8] = (1 - slip_14_1) * (1 - slip_14_4);
        pi[15,8] = (1 - slip_15_1) * (1 - slip_15_4);
        pi[16,8] = (1 - slip_16_1);
        pi[17,8] = (1 - slip_17_1);
        pi[18,8] = (1 - slip_18_2) * penalty_18_2 * (1 - slip_18_4);
        pi[19,8] = (1 - slip_19_1) * (1 - slip_19_2) * penalty_19_2;
        pi[20,8] = (1 - slip_20_2) * penalty_20_2 * (1 - slip_20_4);
        pi[21,8] = (1 - slip_21_2) * penalty_21_2;
        pi[22,8] = (1 - slip_22_2) * penalty_22_2;
        pi[23,8] = (1 - slip_23_1);
        pi[24,8] = (1 - slip_24_1) * (1 - slip_24_2) * penalty_24_2;
        pi[25,8] = (1 - slip_25_1) * (1 - slip_25_2) * penalty_25_2;
        pi[26,8] = (1 - slip_26_1);
        pi[27,8] = (1 - slip_27_1) * (1 - slip_27_2) * penalty_27_2;
        pi[1,9] = (1 - slip_1_1) * penalty_1_1;
        pi[2,9] = (1 - slip_2_3);
        pi[3,9] = (1 - slip_3_2);
        pi[4,9] = (1 - slip_4_1) * penalty_4_1;
        pi[5,9] = (1 - slip_5_1) * penalty_5_1;
        pi[6,9] = (1 - slip_6_2);
        pi[7,9] = (1 - slip_7_1) * penalty_7_1;
        pi[8,9] = (1 - slip_8_3);
        pi[9,9] = (1 - slip_9_3);
        pi[10,9] = (1 - slip_10_3);
        pi[11,9] = (1 - slip_11_3);
        pi[12,9] = (1 - slip_12_1) * penalty_12_1;
        pi[13,9] = (1 - slip_13_4) * penalty_13_4;
        pi[14,9] = (1 - slip_14_1) * penalty_14_1 * (1 - slip_14_4) * penalty_14_4;
        pi[15,9] = (1 - slip_15_1) * penalty_15_1 * (1 - slip_15_4) * penalty_15_4;
        pi[16,9] = (1 - slip_16_1) * penalty_16_1;
        pi[17,9] = (1 - slip_17_1) * penalty_17_1;
        pi[18,9] = (1 - slip_18_2) * (1 - slip_18_4) * penalty_18_4;
        pi[19,9] = (1 - slip_19_1) * penalty_19_1 * (1 - slip_19_2);
        pi[20,9] = (1 - slip_20_2) * (1 - slip_20_4) * penalty_20_4;
        pi[21,9] = (1 - slip_21_2);
        pi[22,9] = (1 - slip_22_2);
        pi[23,9] = (1 - slip_23_1) * penalty_23_1;
        pi[24,9] = (1 - slip_24_1) * penalty_24_1 * (1 - slip_24_2);
        pi[25,9] = (1 - slip_25_1) * penalty_25_1 * (1 - slip_25_2);
        pi[26,9] = (1 - slip_26_1) * penalty_26_1;
        pi[27,9] = (1 - slip_27_1) * penalty_27_1 * (1 - slip_27_2);
        pi[1,10] = (1 - slip_1_1) * penalty_1_1;
        pi[2,10] = (1 - slip_2_3) * penalty_2_3;
        pi[3,10] = (1 - slip_3_2);
        pi[4,10] = (1 - slip_4_1) * penalty_4_1;
        pi[5,10] = (1 - slip_5_1) * penalty_5_1;
        pi[6,10] = (1 - slip_6_2);
        pi[7,10] = (1 - slip_7_1) * penalty_7_1;
        pi[8,10] = (1 - slip_8_3) * penalty_8_3;
        pi[9,10] = (1 - slip_9_3) * penalty_9_3;
        pi[10,10] = (1 - slip_10_3) * penalty_10_3;
        pi[11,10] = (1 - slip_11_3) * penalty_11_3;
        pi[12,10] = (1 - slip_12_1) * penalty_12_1;
        pi[13,10] = (1 - slip_13_4);
        pi[14,10] = (1 - slip_14_1) * penalty_14_1 * (1 - slip_14_4);
        pi[15,10] = (1 - slip_15_1) * penalty_15_1 * (1 - slip_15_4);
        pi[16,10] = (1 - slip_16_1) * penalty_16_1;
        pi[17,10] = (1 - slip_17_1) * penalty_17_1;
        pi[18,10] = (1 - slip_18_2) * (1 - slip_18_4);
        pi[19,10] = (1 - slip_19_1) * penalty_19_1 * (1 - slip_19_2);
        pi[20,10] = (1 - slip_20_2) * (1 - slip_20_4);
        pi[21,10] = (1 - slip_21_2);
        pi[22,10] = (1 - slip_22_2);
        pi[23,10] = (1 - slip_23_1) * penalty_23_1;
        pi[24,10] = (1 - slip_24_1) * penalty_24_1 * (1 - slip_24_2);
        pi[25,10] = (1 - slip_25_1) * penalty_25_1 * (1 - slip_25_2);
        pi[26,10] = (1 - slip_26_1) * penalty_26_1;
        pi[27,10] = (1 - slip_27_1) * penalty_27_1 * (1 - slip_27_2);
        pi[1,11] = (1 - slip_1_1) * penalty_1_1;
        pi[2,11] = (1 - slip_2_3);
        pi[3,11] = (1 - slip_3_2) * penalty_3_2;
        pi[4,11] = (1 - slip_4_1) * penalty_4_1;
        pi[5,11] = (1 - slip_5_1) * penalty_5_1;
        pi[6,11] = (1 - slip_6_2) * penalty_6_2;
        pi[7,11] = (1 - slip_7_1) * penalty_7_1;
        pi[8,11] = (1 - slip_8_3);
        pi[9,11] = (1 - slip_9_3);
        pi[10,11] = (1 - slip_10_3);
        pi[11,11] = (1 - slip_11_3);
        pi[12,11] = (1 - slip_12_1) * penalty_12_1;
        pi[13,11] = (1 - slip_13_4);
        pi[14,11] = (1 - slip_14_1) * penalty_14_1 * (1 - slip_14_4);
        pi[15,11] = (1 - slip_15_1) * penalty_15_1 * (1 - slip_15_4);
        pi[16,11] = (1 - slip_16_1) * penalty_16_1;
        pi[17,11] = (1 - slip_17_1) * penalty_17_1;
        pi[18,11] = (1 - slip_18_2) * penalty_18_2 * (1 - slip_18_4);
        pi[19,11] = (1 - slip_19_1) * penalty_19_1 * (1 - slip_19_2) * penalty_19_2;
        pi[20,11] = (1 - slip_20_2) * penalty_20_2 * (1 - slip_20_4);
        pi[21,11] = (1 - slip_21_2) * penalty_21_2;
        pi[22,11] = (1 - slip_22_2) * penalty_22_2;
        pi[23,11] = (1 - slip_23_1) * penalty_23_1;
        pi[24,11] = (1 - slip_24_1) * penalty_24_1 * (1 - slip_24_2) * penalty_24_2;
        pi[25,11] = (1 - slip_25_1) * penalty_25_1 * (1 - slip_25_2) * penalty_25_2;
        pi[26,11] = (1 - slip_26_1) * penalty_26_1;
        pi[27,11] = (1 - slip_27_1) * penalty_27_1 * (1 - slip_27_2) * penalty_27_2;
        pi[1,12] = (1 - slip_1_1);
        pi[2,12] = (1 - slip_2_3);
        pi[3,12] = (1 - slip_3_2);
        pi[4,12] = (1 - slip_4_1);
        pi[5,12] = (1 - slip_5_1);
        pi[6,12] = (1 - slip_6_2);
        pi[7,12] = (1 - slip_7_1);
        pi[8,12] = (1 - slip_8_3);
        pi[9,12] = (1 - slip_9_3);
        pi[10,12] = (1 - slip_10_3);
        pi[11,12] = (1 - slip_11_3);
        pi[12,12] = (1 - slip_12_1);
        pi[13,12] = (1 - slip_13_4) * penalty_13_4;
        pi[14,12] = (1 - slip_14_1) * (1 - slip_14_4) * penalty_14_4;
        pi[15,12] = (1 - slip_15_1) * (1 - slip_15_4) * penalty_15_4;
        pi[16,12] = (1 - slip_16_1);
        pi[17,12] = (1 - slip_17_1);
        pi[18,12] = (1 - slip_18_2) * (1 - slip_18_4) * penalty_18_4;
        pi[19,12] = (1 - slip_19_1) * (1 - slip_19_2);
        pi[20,12] = (1 - slip_20_2) * (1 - slip_20_4) * penalty_20_4;
        pi[21,12] = (1 - slip_21_2);
        pi[22,12] = (1 - slip_22_2);
        pi[23,12] = (1 - slip_23_1);
        pi[24,12] = (1 - slip_24_1) * (1 - slip_24_2);
        pi[25,12] = (1 - slip_25_1) * (1 - slip_25_2);
        pi[26,12] = (1 - slip_26_1);
        pi[27,12] = (1 - slip_27_1) * (1 - slip_27_2);
        pi[1,13] = (1 - slip_1_1);
        pi[2,13] = (1 - slip_2_3) * penalty_2_3;
        pi[3,13] = (1 - slip_3_2);
        pi[4,13] = (1 - slip_4_1);
        pi[5,13] = (1 - slip_5_1);
        pi[6,13] = (1 - slip_6_2);
        pi[7,13] = (1 - slip_7_1);
        pi[8,13] = (1 - slip_8_3) * penalty_8_3;
        pi[9,13] = (1 - slip_9_3) * penalty_9_3;
        pi[10,13] = (1 - slip_10_3) * penalty_10_3;
        pi[11,13] = (1 - slip_11_3) * penalty_11_3;
        pi[12,13] = (1 - slip_12_1);
        pi[13,13] = (1 - slip_13_4);
        pi[14,13] = (1 - slip_14_1) * (1 - slip_14_4);
        pi[15,13] = (1 - slip_15_1) * (1 - slip_15_4);
        pi[16,13] = (1 - slip_16_1);
        pi[17,13] = (1 - slip_17_1);
        pi[18,13] = (1 - slip_18_2) * (1 - slip_18_4);
        pi[19,13] = (1 - slip_19_1) * (1 - slip_19_2);
        pi[20,13] = (1 - slip_20_2) * (1 - slip_20_4);
        pi[21,13] = (1 - slip_21_2);
        pi[22,13] = (1 - slip_22_2);
        pi[23,13] = (1 - slip_23_1);
        pi[24,13] = (1 - slip_24_1) * (1 - slip_24_2);
        pi[25,13] = (1 - slip_25_1) * (1 - slip_25_2);
        pi[26,13] = (1 - slip_26_1);
        pi[27,13] = (1 - slip_27_1) * (1 - slip_27_2);
        pi[1,14] = (1 - slip_1_1);
        pi[2,14] = (1 - slip_2_3);
        pi[3,14] = (1 - slip_3_2) * penalty_3_2;
        pi[4,14] = (1 - slip_4_1);
        pi[5,14] = (1 - slip_5_1);
        pi[6,14] = (1 - slip_6_2) * penalty_6_2;
        pi[7,14] = (1 - slip_7_1);
        pi[8,14] = (1 - slip_8_3);
        pi[9,14] = (1 - slip_9_3);
        pi[10,14] = (1 - slip_10_3);
        pi[11,14] = (1 - slip_11_3);
        pi[12,14] = (1 - slip_12_1);
        pi[13,14] = (1 - slip_13_4);
        pi[14,14] = (1 - slip_14_1) * (1 - slip_14_4);
        pi[15,14] = (1 - slip_15_1) * (1 - slip_15_4);
        pi[16,14] = (1 - slip_16_1);
        pi[17,14] = (1 - slip_17_1);
        pi[18,14] = (1 - slip_18_2) * penalty_18_2 * (1 - slip_18_4);
        pi[19,14] = (1 - slip_19_1) * (1 - slip_19_2) * penalty_19_2;
        pi[20,14] = (1 - slip_20_2) * penalty_20_2 * (1 - slip_20_4);
        pi[21,14] = (1 - slip_21_2) * penalty_21_2;
        pi[22,14] = (1 - slip_22_2) * penalty_22_2;
        pi[23,14] = (1 - slip_23_1);
        pi[24,14] = (1 - slip_24_1) * (1 - slip_24_2) * penalty_24_2;
        pi[25,14] = (1 - slip_25_1) * (1 - slip_25_2) * penalty_25_2;
        pi[26,14] = (1 - slip_26_1);
        pi[27,14] = (1 - slip_27_1) * (1 - slip_27_2) * penalty_27_2;
        pi[1,15] = (1 - slip_1_1) * penalty_1_1;
        pi[2,15] = (1 - slip_2_3);
        pi[3,15] = (1 - slip_3_2);
        pi[4,15] = (1 - slip_4_1) * penalty_4_1;
        pi[5,15] = (1 - slip_5_1) * penalty_5_1;
        pi[6,15] = (1 - slip_6_2);
        pi[7,15] = (1 - slip_7_1) * penalty_7_1;
        pi[8,15] = (1 - slip_8_3);
        pi[9,15] = (1 - slip_9_3);
        pi[10,15] = (1 - slip_10_3);
        pi[11,15] = (1 - slip_11_3);
        pi[12,15] = (1 - slip_12_1) * penalty_12_1;
        pi[13,15] = (1 - slip_13_4);
        pi[14,15] = (1 - slip_14_1) * penalty_14_1 * (1 - slip_14_4);
        pi[15,15] = (1 - slip_15_1) * penalty_15_1 * (1 - slip_15_4);
        pi[16,15] = (1 - slip_16_1) * penalty_16_1;
        pi[17,15] = (1 - slip_17_1) * penalty_17_1;
        pi[18,15] = (1 - slip_18_2) * (1 - slip_18_4);
        pi[19,15] = (1 - slip_19_1) * penalty_19_1 * (1 - slip_19_2);
        pi[20,15] = (1 - slip_20_2) * (1 - slip_20_4);
        pi[21,15] = (1 - slip_21_2);
        pi[22,15] = (1 - slip_22_2);
        pi[23,15] = (1 - slip_23_1) * penalty_23_1;
        pi[24,15] = (1 - slip_24_1) * penalty_24_1 * (1 - slip_24_2);
        pi[25,15] = (1 - slip_25_1) * penalty_25_1 * (1 - slip_25_2);
        pi[26,15] = (1 - slip_26_1) * penalty_26_1;
        pi[27,15] = (1 - slip_27_1) * penalty_27_1 * (1 - slip_27_2);
        pi[1,16] = (1 - slip_1_1);
        pi[2,16] = (1 - slip_2_3);
        pi[3,16] = (1 - slip_3_2);
        pi[4,16] = (1 - slip_4_1);
        pi[5,16] = (1 - slip_5_1);
        pi[6,16] = (1 - slip_6_2);
        pi[7,16] = (1 - slip_7_1);
        pi[8,16] = (1 - slip_8_3);
        pi[9,16] = (1 - slip_9_3);
        pi[10,16] = (1 - slip_10_3);
        pi[11,16] = (1 - slip_11_3);
        pi[12,16] = (1 - slip_12_1);
        pi[13,16] = (1 - slip_13_4);
        pi[14,16] = (1 - slip_14_1) * (1 - slip_14_4);
        pi[15,16] = (1 - slip_15_1) * (1 - slip_15_4);
        pi[16,16] = (1 - slip_16_1);
        pi[17,16] = (1 - slip_17_1);
        pi[18,16] = (1 - slip_18_2) * (1 - slip_18_4);
        pi[19,16] = (1 - slip_19_1) * (1 - slip_19_2);
        pi[20,16] = (1 - slip_20_2) * (1 - slip_20_4);
        pi[21,16] = (1 - slip_21_2);
        pi[22,16] = (1 - slip_22_2);
        pi[23,16] = (1 - slip_23_1);
        pi[24,16] = (1 - slip_24_1) * (1 - slip_24_2);
        pi[25,16] = (1 - slip_25_1) * (1 - slip_25_2);
        pi[26,16] = (1 - slip_26_1);
        pi[27,16] = (1 - slip_27_1) * (1 - slip_27_2);
      }
      model {
      
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        penalty_1_1 ~ beta(5, 25);
        slip_1_1 ~ beta(5, 25);
        penalty_2_3 ~ beta(5, 25);
        slip_2_3 ~ beta(5, 25);
        penalty_3_2 ~ beta(5, 25);
        slip_3_2 ~ beta(5, 25);
        penalty_4_1 ~ beta(5, 25);
        slip_4_1 ~ beta(5, 25);
        penalty_5_1 ~ beta(5, 25);
        slip_5_1 ~ beta(5, 25);
        penalty_6_2 ~ beta(5, 25);
        slip_6_2 ~ beta(5, 25);
        penalty_7_1 ~ beta(5, 25);
        slip_7_1 ~ beta(5, 25);
        penalty_8_3 ~ beta(5, 25);
        slip_8_3 ~ beta(5, 25);
        penalty_9_3 ~ beta(5, 25);
        slip_9_3 ~ beta(5, 25);
        penalty_10_3 ~ beta(5, 25);
        slip_10_3 ~ beta(5, 25);
        penalty_11_3 ~ beta(5, 25);
        slip_11_3 ~ beta(5, 25);
        penalty_12_1 ~ beta(5, 25);
        slip_12_1 ~ beta(5, 25);
        penalty_13_4 ~ beta(5, 25);
        slip_13_4 ~ beta(5, 25);
        penalty_14_1 ~ beta(5, 25);
        slip_14_1 ~ beta(5, 25);
        penalty_14_4 ~ beta(5, 25);
        slip_14_4 ~ beta(5, 25);
        penalty_15_1 ~ beta(5, 25);
        slip_15_1 ~ beta(5, 25);
        penalty_15_4 ~ beta(5, 25);
        slip_15_4 ~ beta(5, 25);
        penalty_16_1 ~ beta(5, 25);
        slip_16_1 ~ beta(5, 25);
        penalty_17_1 ~ beta(5, 25);
        slip_17_1 ~ beta(5, 25);
        penalty_18_2 ~ beta(5, 25);
        slip_18_2 ~ beta(5, 25);
        penalty_18_4 ~ beta(5, 25);
        slip_18_4 ~ beta(5, 25);
        penalty_19_1 ~ beta(5, 25);
        slip_19_1 ~ beta(5, 25);
        penalty_19_2 ~ beta(5, 25);
        slip_19_2 ~ beta(5, 25);
        penalty_20_2 ~ beta(5, 25);
        slip_20_2 ~ beta(5, 25);
        penalty_20_4 ~ beta(5, 25);
        slip_20_4 ~ beta(5, 25);
        penalty_21_2 ~ beta(5, 25);
        slip_21_2 ~ beta(5, 25);
        penalty_22_2 ~ beta(5, 25);
        slip_22_2 ~ beta(5, 25);
        penalty_23_1 ~ beta(5, 25);
        slip_23_1 ~ beta(5, 25);
        penalty_24_1 ~ beta(5, 25);
        slip_24_1 ~ beta(5, 25);
        penalty_24_2 ~ beta(5, 25);
        slip_24_2 ~ beta(5, 25);
        penalty_25_1 ~ beta(5, 25);
        slip_25_1 ~ beta(5, 25);
        penalty_25_2 ~ beta(5, 25);
        slip_25_2 ~ beta(5, 25);
        penalty_26_1 ~ beta(5, 25);
        slip_26_1 ~ beta(5, 25);
        penalty_27_1 ~ beta(5, 25);
        slip_27_1 ~ beta(5, 25);
        penalty_27_2 ~ beta(5, 25);
        slip_27_2 ~ beta(5, 25);
      
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
      
        ////////////////////////////////// parameters
        real<lower=0,upper=1> penalty_1_1;
        real<lower=0,upper=1> slip_1_1;
        real<lower=0,upper=1> penalty_1_2;
        real<lower=0,upper=1> slip_1_2;
        real<lower=0,upper=1> penalty_2_2;
        real<lower=0,upper=1> slip_2_2;
        real<lower=0,upper=1> penalty_3_1;
        real<lower=0,upper=1> slip_3_1;
        real<lower=0,upper=1> penalty_3_3;
        real<lower=0,upper=1> slip_3_3;
        real<lower=0,upper=1> penalty_4_3;
        real<lower=0,upper=1> slip_4_3;
        real<lower=0,upper=1> penalty_5_3;
        real<lower=0,upper=1> slip_5_3;
        real<lower=0,upper=1> penalty_6_3;
        real<lower=0,upper=1> slip_6_3;
        real<lower=0,upper=1> penalty_7_1;
        real<lower=0,upper=1> slip_7_1;
        real<lower=0,upper=1> penalty_7_3;
        real<lower=0,upper=1> slip_7_3;
        real<lower=0,upper=1> penalty_8_2;
        real<lower=0,upper=1> slip_8_2;
        real<lower=0,upper=1> penalty_9_3;
        real<lower=0,upper=1> slip_9_3;
        real<lower=0,upper=1> penalty_10_1;
        real<lower=0,upper=1> slip_10_1;
        real<lower=0,upper=1> penalty_11_1;
        real<lower=0,upper=1> slip_11_1;
        real<lower=0,upper=1> penalty_11_3;
        real<lower=0,upper=1> slip_11_3;
        real<lower=0,upper=1> penalty_12_1;
        real<lower=0,upper=1> slip_12_1;
        real<lower=0,upper=1> penalty_12_3;
        real<lower=0,upper=1> slip_12_3;
        real<lower=0,upper=1> penalty_13_1;
        real<lower=0,upper=1> slip_13_1;
        real<lower=0,upper=1> penalty_14_1;
        real<lower=0,upper=1> slip_14_1;
        real<lower=0,upper=1> penalty_15_3;
        real<lower=0,upper=1> slip_15_3;
        real<lower=0,upper=1> penalty_16_1;
        real<lower=0,upper=1> slip_16_1;
        real<lower=0,upper=1> penalty_16_3;
        real<lower=0,upper=1> slip_16_3;
        real<lower=0,upper=1> penalty_17_2;
        real<lower=0,upper=1> slip_17_2;
        real<lower=0,upper=1> penalty_17_3;
        real<lower=0,upper=1> slip_17_3;
        real<lower=0,upper=1> penalty_18_3;
        real<lower=0,upper=1> slip_18_3;
        real<lower=0,upper=1> penalty_19_3;
        real<lower=0,upper=1> slip_19_3;
        real<lower=0,upper=1> penalty_20_1;
        real<lower=0,upper=1> slip_20_1;
        real<lower=0,upper=1> penalty_20_3;
        real<lower=0,upper=1> slip_20_3;
        real<lower=0,upper=1> penalty_21_1;
        real<lower=0,upper=1> slip_21_1;
        real<lower=0,upper=1> penalty_21_3;
        real<lower=0,upper=1> slip_21_3;
        real<lower=0,upper=1> penalty_22_3;
        real<lower=0,upper=1> slip_22_3;
        real<lower=0,upper=1> penalty_23_2;
        real<lower=0,upper=1> slip_23_2;
        real<lower=0,upper=1> penalty_24_2;
        real<lower=0,upper=1> slip_24_2;
        real<lower=0,upper=1> penalty_25_1;
        real<lower=0,upper=1> slip_25_1;
        real<lower=0,upper=1> penalty_26_3;
        real<lower=0,upper=1> slip_26_3;
        real<lower=0,upper=1> penalty_27_1;
        real<lower=0,upper=1> slip_27_1;
        real<lower=0,upper=1> penalty_28_3;
        real<lower=0,upper=1> slip_28_3;
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
        pi[1,1] = (1 - slip_1_1) * penalty_1_1 * (1 - slip_1_2) * penalty_1_2;
        pi[2,1] = (1 - slip_2_2) * penalty_2_2;
        pi[3,1] = (1 - slip_3_1) * penalty_3_1 * (1 - slip_3_3) * penalty_3_3;
        pi[4,1] = (1 - slip_4_3) * penalty_4_3;
        pi[5,1] = (1 - slip_5_3) * penalty_5_3;
        pi[6,1] = (1 - slip_6_3) * penalty_6_3;
        pi[7,1] = (1 - slip_7_1) * penalty_7_1 * (1 - slip_7_3) * penalty_7_3;
        pi[8,1] = (1 - slip_8_2) * penalty_8_2;
        pi[9,1] = (1 - slip_9_3) * penalty_9_3;
        pi[10,1] = (1 - slip_10_1) * penalty_10_1;
        pi[11,1] = (1 - slip_11_1) * penalty_11_1 * (1 - slip_11_3) * penalty_11_3;
        pi[12,1] = (1 - slip_12_1) * penalty_12_1 * (1 - slip_12_3) * penalty_12_3;
        pi[13,1] = (1 - slip_13_1) * penalty_13_1;
        pi[14,1] = (1 - slip_14_1) * penalty_14_1;
        pi[15,1] = (1 - slip_15_3) * penalty_15_3;
        pi[16,1] = (1 - slip_16_1) * penalty_16_1 * (1 - slip_16_3) * penalty_16_3;
        pi[17,1] = (1 - slip_17_2) * penalty_17_2 * (1 - slip_17_3) * penalty_17_3;
        pi[18,1] = (1 - slip_18_3) * penalty_18_3;
        pi[19,1] = (1 - slip_19_3) * penalty_19_3;
        pi[20,1] = (1 - slip_20_1) * penalty_20_1 * (1 - slip_20_3) * penalty_20_3;
        pi[21,1] = (1 - slip_21_1) * penalty_21_1 * (1 - slip_21_3) * penalty_21_3;
        pi[22,1] = (1 - slip_22_3) * penalty_22_3;
        pi[23,1] = (1 - slip_23_2) * penalty_23_2;
        pi[24,1] = (1 - slip_24_2) * penalty_24_2;
        pi[25,1] = (1 - slip_25_1) * penalty_25_1;
        pi[26,1] = (1 - slip_26_3) * penalty_26_3;
        pi[27,1] = (1 - slip_27_1) * penalty_27_1;
        pi[28,1] = (1 - slip_28_3) * penalty_28_3;
        pi[1,2] = (1 - slip_1_1) * (1 - slip_1_2) * penalty_1_2;
        pi[2,2] = (1 - slip_2_2) * penalty_2_2;
        pi[3,2] = (1 - slip_3_1) * (1 - slip_3_3) * penalty_3_3;
        pi[4,2] = (1 - slip_4_3) * penalty_4_3;
        pi[5,2] = (1 - slip_5_3) * penalty_5_3;
        pi[6,2] = (1 - slip_6_3) * penalty_6_3;
        pi[7,2] = (1 - slip_7_1) * (1 - slip_7_3) * penalty_7_3;
        pi[8,2] = (1 - slip_8_2) * penalty_8_2;
        pi[9,2] = (1 - slip_9_3) * penalty_9_3;
        pi[10,2] = (1 - slip_10_1);
        pi[11,2] = (1 - slip_11_1) * (1 - slip_11_3) * penalty_11_3;
        pi[12,2] = (1 - slip_12_1) * (1 - slip_12_3) * penalty_12_3;
        pi[13,2] = (1 - slip_13_1);
        pi[14,2] = (1 - slip_14_1);
        pi[15,2] = (1 - slip_15_3) * penalty_15_3;
        pi[16,2] = (1 - slip_16_1) * (1 - slip_16_3) * penalty_16_3;
        pi[17,2] = (1 - slip_17_2) * penalty_17_2 * (1 - slip_17_3) * penalty_17_3;
        pi[18,2] = (1 - slip_18_3) * penalty_18_3;
        pi[19,2] = (1 - slip_19_3) * penalty_19_3;
        pi[20,2] = (1 - slip_20_1) * (1 - slip_20_3) * penalty_20_3;
        pi[21,2] = (1 - slip_21_1) * (1 - slip_21_3) * penalty_21_3;
        pi[22,2] = (1 - slip_22_3) * penalty_22_3;
        pi[23,2] = (1 - slip_23_2) * penalty_23_2;
        pi[24,2] = (1 - slip_24_2) * penalty_24_2;
        pi[25,2] = (1 - slip_25_1);
        pi[26,2] = (1 - slip_26_3) * penalty_26_3;
        pi[27,2] = (1 - slip_27_1);
        pi[28,2] = (1 - slip_28_3) * penalty_28_3;
        pi[1,3] = (1 - slip_1_1) * penalty_1_1 * (1 - slip_1_2);
        pi[2,3] = (1 - slip_2_2);
        pi[3,3] = (1 - slip_3_1) * penalty_3_1 * (1 - slip_3_3) * penalty_3_3;
        pi[4,3] = (1 - slip_4_3) * penalty_4_3;
        pi[5,3] = (1 - slip_5_3) * penalty_5_3;
        pi[6,3] = (1 - slip_6_3) * penalty_6_3;
        pi[7,3] = (1 - slip_7_1) * penalty_7_1 * (1 - slip_7_3) * penalty_7_3;
        pi[8,3] = (1 - slip_8_2);
        pi[9,3] = (1 - slip_9_3) * penalty_9_3;
        pi[10,3] = (1 - slip_10_1) * penalty_10_1;
        pi[11,3] = (1 - slip_11_1) * penalty_11_1 * (1 - slip_11_3) * penalty_11_3;
        pi[12,3] = (1 - slip_12_1) * penalty_12_1 * (1 - slip_12_3) * penalty_12_3;
        pi[13,3] = (1 - slip_13_1) * penalty_13_1;
        pi[14,3] = (1 - slip_14_1) * penalty_14_1;
        pi[15,3] = (1 - slip_15_3) * penalty_15_3;
        pi[16,3] = (1 - slip_16_1) * penalty_16_1 * (1 - slip_16_3) * penalty_16_3;
        pi[17,3] = (1 - slip_17_2) * (1 - slip_17_3) * penalty_17_3;
        pi[18,3] = (1 - slip_18_3) * penalty_18_3;
        pi[19,3] = (1 - slip_19_3) * penalty_19_3;
        pi[20,3] = (1 - slip_20_1) * penalty_20_1 * (1 - slip_20_3) * penalty_20_3;
        pi[21,3] = (1 - slip_21_1) * penalty_21_1 * (1 - slip_21_3) * penalty_21_3;
        pi[22,3] = (1 - slip_22_3) * penalty_22_3;
        pi[23,3] = (1 - slip_23_2);
        pi[24,3] = (1 - slip_24_2);
        pi[25,3] = (1 - slip_25_1) * penalty_25_1;
        pi[26,3] = (1 - slip_26_3) * penalty_26_3;
        pi[27,3] = (1 - slip_27_1) * penalty_27_1;
        pi[28,3] = (1 - slip_28_3) * penalty_28_3;
        pi[1,4] = (1 - slip_1_1) * penalty_1_1 * (1 - slip_1_2) * penalty_1_2;
        pi[2,4] = (1 - slip_2_2) * penalty_2_2;
        pi[3,4] = (1 - slip_3_1) * penalty_3_1 * (1 - slip_3_3);
        pi[4,4] = (1 - slip_4_3);
        pi[5,4] = (1 - slip_5_3);
        pi[6,4] = (1 - slip_6_3);
        pi[7,4] = (1 - slip_7_1) * penalty_7_1 * (1 - slip_7_3);
        pi[8,4] = (1 - slip_8_2) * penalty_8_2;
        pi[9,4] = (1 - slip_9_3);
        pi[10,4] = (1 - slip_10_1) * penalty_10_1;
        pi[11,4] = (1 - slip_11_1) * penalty_11_1 * (1 - slip_11_3);
        pi[12,4] = (1 - slip_12_1) * penalty_12_1 * (1 - slip_12_3);
        pi[13,4] = (1 - slip_13_1) * penalty_13_1;
        pi[14,4] = (1 - slip_14_1) * penalty_14_1;
        pi[15,4] = (1 - slip_15_3);
        pi[16,4] = (1 - slip_16_1) * penalty_16_1 * (1 - slip_16_3);
        pi[17,4] = (1 - slip_17_2) * penalty_17_2 * (1 - slip_17_3);
        pi[18,4] = (1 - slip_18_3);
        pi[19,4] = (1 - slip_19_3);
        pi[20,4] = (1 - slip_20_1) * penalty_20_1 * (1 - slip_20_3);
        pi[21,4] = (1 - slip_21_1) * penalty_21_1 * (1 - slip_21_3);
        pi[22,4] = (1 - slip_22_3);
        pi[23,4] = (1 - slip_23_2) * penalty_23_2;
        pi[24,4] = (1 - slip_24_2) * penalty_24_2;
        pi[25,4] = (1 - slip_25_1) * penalty_25_1;
        pi[26,4] = (1 - slip_26_3);
        pi[27,4] = (1 - slip_27_1) * penalty_27_1;
        pi[28,4] = (1 - slip_28_3);
        pi[1,5] = (1 - slip_1_1) * (1 - slip_1_2);
        pi[2,5] = (1 - slip_2_2);
        pi[3,5] = (1 - slip_3_1) * (1 - slip_3_3) * penalty_3_3;
        pi[4,5] = (1 - slip_4_3) * penalty_4_3;
        pi[5,5] = (1 - slip_5_3) * penalty_5_3;
        pi[6,5] = (1 - slip_6_3) * penalty_6_3;
        pi[7,5] = (1 - slip_7_1) * (1 - slip_7_3) * penalty_7_3;
        pi[8,5] = (1 - slip_8_2);
        pi[9,5] = (1 - slip_9_3) * penalty_9_3;
        pi[10,5] = (1 - slip_10_1);
        pi[11,5] = (1 - slip_11_1) * (1 - slip_11_3) * penalty_11_3;
        pi[12,5] = (1 - slip_12_1) * (1 - slip_12_3) * penalty_12_3;
        pi[13,5] = (1 - slip_13_1);
        pi[14,5] = (1 - slip_14_1);
        pi[15,5] = (1 - slip_15_3) * penalty_15_3;
        pi[16,5] = (1 - slip_16_1) * (1 - slip_16_3) * penalty_16_3;
        pi[17,5] = (1 - slip_17_2) * (1 - slip_17_3) * penalty_17_3;
        pi[18,5] = (1 - slip_18_3) * penalty_18_3;
        pi[19,5] = (1 - slip_19_3) * penalty_19_3;
        pi[20,5] = (1 - slip_20_1) * (1 - slip_20_3) * penalty_20_3;
        pi[21,5] = (1 - slip_21_1) * (1 - slip_21_3) * penalty_21_3;
        pi[22,5] = (1 - slip_22_3) * penalty_22_3;
        pi[23,5] = (1 - slip_23_2);
        pi[24,5] = (1 - slip_24_2);
        pi[25,5] = (1 - slip_25_1);
        pi[26,5] = (1 - slip_26_3) * penalty_26_3;
        pi[27,5] = (1 - slip_27_1);
        pi[28,5] = (1 - slip_28_3) * penalty_28_3;
        pi[1,6] = (1 - slip_1_1) * (1 - slip_1_2) * penalty_1_2;
        pi[2,6] = (1 - slip_2_2) * penalty_2_2;
        pi[3,6] = (1 - slip_3_1) * (1 - slip_3_3);
        pi[4,6] = (1 - slip_4_3);
        pi[5,6] = (1 - slip_5_3);
        pi[6,6] = (1 - slip_6_3);
        pi[7,6] = (1 - slip_7_1) * (1 - slip_7_3);
        pi[8,6] = (1 - slip_8_2) * penalty_8_2;
        pi[9,6] = (1 - slip_9_3);
        pi[10,6] = (1 - slip_10_1);
        pi[11,6] = (1 - slip_11_1) * (1 - slip_11_3);
        pi[12,6] = (1 - slip_12_1) * (1 - slip_12_3);
        pi[13,6] = (1 - slip_13_1);
        pi[14,6] = (1 - slip_14_1);
        pi[15,6] = (1 - slip_15_3);
        pi[16,6] = (1 - slip_16_1) * (1 - slip_16_3);
        pi[17,6] = (1 - slip_17_2) * penalty_17_2 * (1 - slip_17_3);
        pi[18,6] = (1 - slip_18_3);
        pi[19,6] = (1 - slip_19_3);
        pi[20,6] = (1 - slip_20_1) * (1 - slip_20_3);
        pi[21,6] = (1 - slip_21_1) * (1 - slip_21_3);
        pi[22,6] = (1 - slip_22_3);
        pi[23,6] = (1 - slip_23_2) * penalty_23_2;
        pi[24,6] = (1 - slip_24_2) * penalty_24_2;
        pi[25,6] = (1 - slip_25_1);
        pi[26,6] = (1 - slip_26_3);
        pi[27,6] = (1 - slip_27_1);
        pi[28,6] = (1 - slip_28_3);
        pi[1,7] = (1 - slip_1_1) * penalty_1_1 * (1 - slip_1_2);
        pi[2,7] = (1 - slip_2_2);
        pi[3,7] = (1 - slip_3_1) * penalty_3_1 * (1 - slip_3_3);
        pi[4,7] = (1 - slip_4_3);
        pi[5,7] = (1 - slip_5_3);
        pi[6,7] = (1 - slip_6_3);
        pi[7,7] = (1 - slip_7_1) * penalty_7_1 * (1 - slip_7_3);
        pi[8,7] = (1 - slip_8_2);
        pi[9,7] = (1 - slip_9_3);
        pi[10,7] = (1 - slip_10_1) * penalty_10_1;
        pi[11,7] = (1 - slip_11_1) * penalty_11_1 * (1 - slip_11_3);
        pi[12,7] = (1 - slip_12_1) * penalty_12_1 * (1 - slip_12_3);
        pi[13,7] = (1 - slip_13_1) * penalty_13_1;
        pi[14,7] = (1 - slip_14_1) * penalty_14_1;
        pi[15,7] = (1 - slip_15_3);
        pi[16,7] = (1 - slip_16_1) * penalty_16_1 * (1 - slip_16_3);
        pi[17,7] = (1 - slip_17_2) * (1 - slip_17_3);
        pi[18,7] = (1 - slip_18_3);
        pi[19,7] = (1 - slip_19_3);
        pi[20,7] = (1 - slip_20_1) * penalty_20_1 * (1 - slip_20_3);
        pi[21,7] = (1 - slip_21_1) * penalty_21_1 * (1 - slip_21_3);
        pi[22,7] = (1 - slip_22_3);
        pi[23,7] = (1 - slip_23_2);
        pi[24,7] = (1 - slip_24_2);
        pi[25,7] = (1 - slip_25_1) * penalty_25_1;
        pi[26,7] = (1 - slip_26_3);
        pi[27,7] = (1 - slip_27_1) * penalty_27_1;
        pi[28,7] = (1 - slip_28_3);
        pi[1,8] = (1 - slip_1_1) * (1 - slip_1_2);
        pi[2,8] = (1 - slip_2_2);
        pi[3,8] = (1 - slip_3_1) * (1 - slip_3_3);
        pi[4,8] = (1 - slip_4_3);
        pi[5,8] = (1 - slip_5_3);
        pi[6,8] = (1 - slip_6_3);
        pi[7,8] = (1 - slip_7_1) * (1 - slip_7_3);
        pi[8,8] = (1 - slip_8_2);
        pi[9,8] = (1 - slip_9_3);
        pi[10,8] = (1 - slip_10_1);
        pi[11,8] = (1 - slip_11_1) * (1 - slip_11_3);
        pi[12,8] = (1 - slip_12_1) * (1 - slip_12_3);
        pi[13,8] = (1 - slip_13_1);
        pi[14,8] = (1 - slip_14_1);
        pi[15,8] = (1 - slip_15_3);
        pi[16,8] = (1 - slip_16_1) * (1 - slip_16_3);
        pi[17,8] = (1 - slip_17_2) * (1 - slip_17_3);
        pi[18,8] = (1 - slip_18_3);
        pi[19,8] = (1 - slip_19_3);
        pi[20,8] = (1 - slip_20_1) * (1 - slip_20_3);
        pi[21,8] = (1 - slip_21_1) * (1 - slip_21_3);
        pi[22,8] = (1 - slip_22_3);
        pi[23,8] = (1 - slip_23_2);
        pi[24,8] = (1 - slip_24_2);
        pi[25,8] = (1 - slip_25_1);
        pi[26,8] = (1 - slip_26_3);
        pi[27,8] = (1 - slip_27_1);
        pi[28,8] = (1 - slip_28_3);
      }
      model {
      
        ////////////////////////////////// priors
        eta[1] ~ beta(1, 1);
        eta[2] ~ beta(1, 1);
        eta[3] ~ beta(1, 1);
        penalty_1_1 ~ beta(5, 25);
        slip_1_1 ~ beta(5, 25);
        penalty_1_2 ~ beta(5, 25);
        slip_1_2 ~ beta(5, 25);
        penalty_2_2 ~ beta(5, 25);
        slip_2_2 ~ beta(5, 25);
        penalty_3_1 ~ beta(5, 25);
        slip_3_1 ~ beta(5, 25);
        penalty_3_3 ~ beta(5, 25);
        slip_3_3 ~ beta(5, 25);
        penalty_4_3 ~ beta(5, 25);
        slip_4_3 ~ beta(5, 25);
        penalty_5_3 ~ beta(5, 25);
        slip_5_3 ~ beta(5, 25);
        penalty_6_3 ~ beta(5, 25);
        slip_6_3 ~ beta(5, 25);
        penalty_7_1 ~ beta(5, 25);
        slip_7_1 ~ beta(5, 25);
        penalty_7_3 ~ beta(5, 25);
        slip_7_3 ~ beta(5, 25);
        penalty_8_2 ~ beta(5, 25);
        slip_8_2 ~ beta(5, 25);
        penalty_9_3 ~ beta(5, 25);
        slip_9_3 ~ beta(5, 25);
        penalty_10_1 ~ beta(5, 25);
        slip_10_1 ~ beta(5, 25);
        penalty_11_1 ~ beta(5, 25);
        slip_11_1 ~ beta(5, 25);
        penalty_11_3 ~ beta(5, 25);
        slip_11_3 ~ beta(5, 25);
        penalty_12_1 ~ beta(5, 25);
        slip_12_1 ~ beta(5, 25);
        penalty_12_3 ~ beta(5, 25);
        slip_12_3 ~ beta(5, 25);
        penalty_13_1 ~ beta(5, 25);
        slip_13_1 ~ beta(5, 25);
        penalty_14_1 ~ beta(5, 25);
        slip_14_1 ~ beta(5, 25);
        penalty_15_3 ~ beta(5, 25);
        slip_15_3 ~ beta(5, 25);
        penalty_16_1 ~ beta(5, 25);
        slip_16_1 ~ beta(5, 25);
        penalty_16_3 ~ beta(5, 25);
        slip_16_3 ~ beta(5, 25);
        penalty_17_2 ~ beta(5, 25);
        slip_17_2 ~ beta(5, 25);
        penalty_17_3 ~ beta(5, 25);
        slip_17_3 ~ beta(5, 25);
        penalty_18_3 ~ beta(5, 25);
        slip_18_3 ~ beta(5, 25);
        penalty_19_3 ~ beta(5, 25);
        slip_19_3 ~ beta(5, 25);
        penalty_20_1 ~ beta(5, 25);
        slip_20_1 ~ beta(5, 25);
        penalty_20_3 ~ beta(5, 25);
        slip_20_3 ~ beta(5, 25);
        penalty_21_1 ~ beta(5, 25);
        slip_21_1 ~ beta(5, 25);
        penalty_21_3 ~ beta(5, 25);
        slip_21_3 ~ beta(5, 25);
        penalty_22_3 ~ beta(5, 25);
        slip_22_3 ~ beta(5, 25);
        penalty_23_2 ~ beta(5, 25);
        slip_23_2 ~ beta(5, 25);
        penalty_24_2 ~ beta(5, 25);
        slip_24_2 ~ beta(5, 25);
        penalty_25_1 ~ beta(5, 25);
        slip_25_1 ~ beta(5, 25);
        penalty_26_3 ~ beta(5, 25);
        slip_26_3 ~ beta(5, 25);
        penalty_27_1 ~ beta(5, 25);
        slip_27_1 ~ beta(5, 25);
        penalty_28_3 ~ beta(5, 25);
        slip_28_3 ~ beta(5, 25);
      
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
        simplex[C] Vc;                  // base rates of class membership
      
        ////////////////////////////////// parameters
        real<lower=0,upper=1> penalty_1_1;
        real<lower=0,upper=1> slip_1_1;
        real<lower=0,upper=1> penalty_2_3;
        real<lower=0,upper=1> slip_2_3;
        real<lower=0,upper=1> penalty_3_2;
        real<lower=0,upper=1> slip_3_2;
        real<lower=0,upper=1> penalty_4_1;
        real<lower=0,upper=1> slip_4_1;
        real<lower=0,upper=1> penalty_5_1;
        real<lower=0,upper=1> slip_5_1;
        real<lower=0,upper=1> penalty_6_2;
        real<lower=0,upper=1> slip_6_2;
        real<lower=0,upper=1> penalty_7_1;
        real<lower=0,upper=1> slip_7_1;
        real<lower=0,upper=1> penalty_8_3;
        real<lower=0,upper=1> slip_8_3;
        real<lower=0,upper=1> penalty_9_3;
        real<lower=0,upper=1> slip_9_3;
        real<lower=0,upper=1> penalty_10_3;
        real<lower=0,upper=1> slip_10_3;
        real<lower=0,upper=1> penalty_11_3;
        real<lower=0,upper=1> slip_11_3;
        real<lower=0,upper=1> penalty_12_1;
        real<lower=0,upper=1> slip_12_1;
        real<lower=0,upper=1> penalty_13_4;
        real<lower=0,upper=1> slip_13_4;
        real<lower=0,upper=1> penalty_14_1;
        real<lower=0,upper=1> slip_14_1;
        real<lower=0,upper=1> penalty_15_1;
        real<lower=0,upper=1> slip_15_1;
        real<lower=0,upper=1> penalty_16_2;
        real<lower=0,upper=1> slip_16_2;
        real<lower=0,upper=1> penalty_17_2;
        real<lower=0,upper=1> slip_17_2;
        real<lower=0,upper=1> penalty_18_1;
        real<lower=0,upper=1> slip_18_1;
        real<lower=0,upper=1> penalty_19_1;
        real<lower=0,upper=1> slip_19_1;
      }
      transformed parameters {
        vector[C] log_Vc = log(Vc);
        matrix[I,C] pi;
      
        ////////////////////////////////// probability of correct response
        pi[1,1] = (1 - slip_1_1) * penalty_1_1;
        pi[2,1] = (1 - slip_2_3) * penalty_2_3;
        pi[3,1] = (1 - slip_3_2) * penalty_3_2;
        pi[4,1] = (1 - slip_4_1) * penalty_4_1;
        pi[5,1] = (1 - slip_5_1) * penalty_5_1;
        pi[6,1] = (1 - slip_6_2) * penalty_6_2;
        pi[7,1] = (1 - slip_7_1) * penalty_7_1;
        pi[8,1] = (1 - slip_8_3) * penalty_8_3;
        pi[9,1] = (1 - slip_9_3) * penalty_9_3;
        pi[10,1] = (1 - slip_10_3) * penalty_10_3;
        pi[11,1] = (1 - slip_11_3) * penalty_11_3;
        pi[12,1] = (1 - slip_12_1) * penalty_12_1;
        pi[13,1] = (1 - slip_13_4) * penalty_13_4;
        pi[14,1] = (1 - slip_14_1) * penalty_14_1;
        pi[15,1] = (1 - slip_15_1) * penalty_15_1;
        pi[16,1] = (1 - slip_16_2) * penalty_16_2;
        pi[17,1] = (1 - slip_17_2) * penalty_17_2;
        pi[18,1] = (1 - slip_18_1) * penalty_18_1;
        pi[19,1] = (1 - slip_19_1) * penalty_19_1;
        pi[1,2] = (1 - slip_1_1);
        pi[2,2] = (1 - slip_2_3) * penalty_2_3;
        pi[3,2] = (1 - slip_3_2) * penalty_3_2;
        pi[4,2] = (1 - slip_4_1);
        pi[5,2] = (1 - slip_5_1);
        pi[6,2] = (1 - slip_6_2) * penalty_6_2;
        pi[7,2] = (1 - slip_7_1);
        pi[8,2] = (1 - slip_8_3) * penalty_8_3;
        pi[9,2] = (1 - slip_9_3) * penalty_9_3;
        pi[10,2] = (1 - slip_10_3) * penalty_10_3;
        pi[11,2] = (1 - slip_11_3) * penalty_11_3;
        pi[12,2] = (1 - slip_12_1);
        pi[13,2] = (1 - slip_13_4) * penalty_13_4;
        pi[14,2] = (1 - slip_14_1);
        pi[15,2] = (1 - slip_15_1);
        pi[16,2] = (1 - slip_16_2) * penalty_16_2;
        pi[17,2] = (1 - slip_17_2) * penalty_17_2;
        pi[18,2] = (1 - slip_18_1);
        pi[19,2] = (1 - slip_19_1);
        pi[1,3] = (1 - slip_1_1) * penalty_1_1;
        pi[2,3] = (1 - slip_2_3) * penalty_2_3;
        pi[3,3] = (1 - slip_3_2);
        pi[4,3] = (1 - slip_4_1) * penalty_4_1;
        pi[5,3] = (1 - slip_5_1) * penalty_5_1;
        pi[6,3] = (1 - slip_6_2);
        pi[7,3] = (1 - slip_7_1) * penalty_7_1;
        pi[8,3] = (1 - slip_8_3) * penalty_8_3;
        pi[9,3] = (1 - slip_9_3) * penalty_9_3;
        pi[10,3] = (1 - slip_10_3) * penalty_10_3;
        pi[11,3] = (1 - slip_11_3) * penalty_11_3;
        pi[12,3] = (1 - slip_12_1) * penalty_12_1;
        pi[13,3] = (1 - slip_13_4) * penalty_13_4;
        pi[14,3] = (1 - slip_14_1) * penalty_14_1;
        pi[15,3] = (1 - slip_15_1) * penalty_15_1;
        pi[16,3] = (1 - slip_16_2);
        pi[17,3] = (1 - slip_17_2);
        pi[18,3] = (1 - slip_18_1) * penalty_18_1;
        pi[19,3] = (1 - slip_19_1) * penalty_19_1;
        pi[1,4] = (1 - slip_1_1) * penalty_1_1;
        pi[2,4] = (1 - slip_2_3);
        pi[3,4] = (1 - slip_3_2) * penalty_3_2;
        pi[4,4] = (1 - slip_4_1) * penalty_4_1;
        pi[5,4] = (1 - slip_5_1) * penalty_5_1;
        pi[6,4] = (1 - slip_6_2) * penalty_6_2;
        pi[7,4] = (1 - slip_7_1) * penalty_7_1;
        pi[8,4] = (1 - slip_8_3);
        pi[9,4] = (1 - slip_9_3);
        pi[10,4] = (1 - slip_10_3);
        pi[11,4] = (1 - slip_11_3);
        pi[12,4] = (1 - slip_12_1) * penalty_12_1;
        pi[13,4] = (1 - slip_13_4) * penalty_13_4;
        pi[14,4] = (1 - slip_14_1) * penalty_14_1;
        pi[15,4] = (1 - slip_15_1) * penalty_15_1;
        pi[16,4] = (1 - slip_16_2) * penalty_16_2;
        pi[17,4] = (1 - slip_17_2) * penalty_17_2;
        pi[18,4] = (1 - slip_18_1) * penalty_18_1;
        pi[19,4] = (1 - slip_19_1) * penalty_19_1;
        pi[1,5] = (1 - slip_1_1) * penalty_1_1;
        pi[2,5] = (1 - slip_2_3) * penalty_2_3;
        pi[3,5] = (1 - slip_3_2) * penalty_3_2;
        pi[4,5] = (1 - slip_4_1) * penalty_4_1;
        pi[5,5] = (1 - slip_5_1) * penalty_5_1;
        pi[6,5] = (1 - slip_6_2) * penalty_6_2;
        pi[7,5] = (1 - slip_7_1) * penalty_7_1;
        pi[8,5] = (1 - slip_8_3) * penalty_8_3;
        pi[9,5] = (1 - slip_9_3) * penalty_9_3;
        pi[10,5] = (1 - slip_10_3) * penalty_10_3;
        pi[11,5] = (1 - slip_11_3) * penalty_11_3;
        pi[12,5] = (1 - slip_12_1) * penalty_12_1;
        pi[13,5] = (1 - slip_13_4);
        pi[14,5] = (1 - slip_14_1) * penalty_14_1;
        pi[15,5] = (1 - slip_15_1) * penalty_15_1;
        pi[16,5] = (1 - slip_16_2) * penalty_16_2;
        pi[17,5] = (1 - slip_17_2) * penalty_17_2;
        pi[18,5] = (1 - slip_18_1) * penalty_18_1;
        pi[19,5] = (1 - slip_19_1) * penalty_19_1;
        pi[1,6] = (1 - slip_1_1);
        pi[2,6] = (1 - slip_2_3) * penalty_2_3;
        pi[3,6] = (1 - slip_3_2);
        pi[4,6] = (1 - slip_4_1);
        pi[5,6] = (1 - slip_5_1);
        pi[6,6] = (1 - slip_6_2);
        pi[7,6] = (1 - slip_7_1);
        pi[8,6] = (1 - slip_8_3) * penalty_8_3;
        pi[9,6] = (1 - slip_9_3) * penalty_9_3;
        pi[10,6] = (1 - slip_10_3) * penalty_10_3;
        pi[11,6] = (1 - slip_11_3) * penalty_11_3;
        pi[12,6] = (1 - slip_12_1);
        pi[13,6] = (1 - slip_13_4) * penalty_13_4;
        pi[14,6] = (1 - slip_14_1);
        pi[15,6] = (1 - slip_15_1);
        pi[16,6] = (1 - slip_16_2);
        pi[17,6] = (1 - slip_17_2);
        pi[18,6] = (1 - slip_18_1);
        pi[19,6] = (1 - slip_19_1);
        pi[1,7] = (1 - slip_1_1);
        pi[2,7] = (1 - slip_2_3);
        pi[3,7] = (1 - slip_3_2) * penalty_3_2;
        pi[4,7] = (1 - slip_4_1);
        pi[5,7] = (1 - slip_5_1);
        pi[6,7] = (1 - slip_6_2) * penalty_6_2;
        pi[7,7] = (1 - slip_7_1);
        pi[8,7] = (1 - slip_8_3);
        pi[9,7] = (1 - slip_9_3);
        pi[10,7] = (1 - slip_10_3);
        pi[11,7] = (1 - slip_11_3);
        pi[12,7] = (1 - slip_12_1);
        pi[13,7] = (1 - slip_13_4) * penalty_13_4;
        pi[14,7] = (1 - slip_14_1);
        pi[15,7] = (1 - slip_15_1);
        pi[16,7] = (1 - slip_16_2) * penalty_16_2;
        pi[17,7] = (1 - slip_17_2) * penalty_17_2;
        pi[18,7] = (1 - slip_18_1);
        pi[19,7] = (1 - slip_19_1);
        pi[1,8] = (1 - slip_1_1);
        pi[2,8] = (1 - slip_2_3) * penalty_2_3;
        pi[3,8] = (1 - slip_3_2) * penalty_3_2;
        pi[4,8] = (1 - slip_4_1);
        pi[5,8] = (1 - slip_5_1);
        pi[6,8] = (1 - slip_6_2) * penalty_6_2;
        pi[7,8] = (1 - slip_7_1);
        pi[8,8] = (1 - slip_8_3) * penalty_8_3;
        pi[9,8] = (1 - slip_9_3) * penalty_9_3;
        pi[10,8] = (1 - slip_10_3) * penalty_10_3;
        pi[11,8] = (1 - slip_11_3) * penalty_11_3;
        pi[12,8] = (1 - slip_12_1);
        pi[13,8] = (1 - slip_13_4);
        pi[14,8] = (1 - slip_14_1);
        pi[15,8] = (1 - slip_15_1);
        pi[16,8] = (1 - slip_16_2) * penalty_16_2;
        pi[17,8] = (1 - slip_17_2) * penalty_17_2;
        pi[18,8] = (1 - slip_18_1);
        pi[19,8] = (1 - slip_19_1);
        pi[1,9] = (1 - slip_1_1) * penalty_1_1;
        pi[2,9] = (1 - slip_2_3);
        pi[3,9] = (1 - slip_3_2);
        pi[4,9] = (1 - slip_4_1) * penalty_4_1;
        pi[5,9] = (1 - slip_5_1) * penalty_5_1;
        pi[6,9] = (1 - slip_6_2);
        pi[7,9] = (1 - slip_7_1) * penalty_7_1;
        pi[8,9] = (1 - slip_8_3);
        pi[9,9] = (1 - slip_9_3);
        pi[10,9] = (1 - slip_10_3);
        pi[11,9] = (1 - slip_11_3);
        pi[12,9] = (1 - slip_12_1) * penalty_12_1;
        pi[13,9] = (1 - slip_13_4) * penalty_13_4;
        pi[14,9] = (1 - slip_14_1) * penalty_14_1;
        pi[15,9] = (1 - slip_15_1) * penalty_15_1;
        pi[16,9] = (1 - slip_16_2);
        pi[17,9] = (1 - slip_17_2);
        pi[18,9] = (1 - slip_18_1) * penalty_18_1;
        pi[19,9] = (1 - slip_19_1) * penalty_19_1;
        pi[1,10] = (1 - slip_1_1) * penalty_1_1;
        pi[2,10] = (1 - slip_2_3) * penalty_2_3;
        pi[3,10] = (1 - slip_3_2);
        pi[4,10] = (1 - slip_4_1) * penalty_4_1;
        pi[5,10] = (1 - slip_5_1) * penalty_5_1;
        pi[6,10] = (1 - slip_6_2);
        pi[7,10] = (1 - slip_7_1) * penalty_7_1;
        pi[8,10] = (1 - slip_8_3) * penalty_8_3;
        pi[9,10] = (1 - slip_9_3) * penalty_9_3;
        pi[10,10] = (1 - slip_10_3) * penalty_10_3;
        pi[11,10] = (1 - slip_11_3) * penalty_11_3;
        pi[12,10] = (1 - slip_12_1) * penalty_12_1;
        pi[13,10] = (1 - slip_13_4);
        pi[14,10] = (1 - slip_14_1) * penalty_14_1;
        pi[15,10] = (1 - slip_15_1) * penalty_15_1;
        pi[16,10] = (1 - slip_16_2);
        pi[17,10] = (1 - slip_17_2);
        pi[18,10] = (1 - slip_18_1) * penalty_18_1;
        pi[19,10] = (1 - slip_19_1) * penalty_19_1;
        pi[1,11] = (1 - slip_1_1) * penalty_1_1;
        pi[2,11] = (1 - slip_2_3);
        pi[3,11] = (1 - slip_3_2) * penalty_3_2;
        pi[4,11] = (1 - slip_4_1) * penalty_4_1;
        pi[5,11] = (1 - slip_5_1) * penalty_5_1;
        pi[6,11] = (1 - slip_6_2) * penalty_6_2;
        pi[7,11] = (1 - slip_7_1) * penalty_7_1;
        pi[8,11] = (1 - slip_8_3);
        pi[9,11] = (1 - slip_9_3);
        pi[10,11] = (1 - slip_10_3);
        pi[11,11] = (1 - slip_11_3);
        pi[12,11] = (1 - slip_12_1) * penalty_12_1;
        pi[13,11] = (1 - slip_13_4);
        pi[14,11] = (1 - slip_14_1) * penalty_14_1;
        pi[15,11] = (1 - slip_15_1) * penalty_15_1;
        pi[16,11] = (1 - slip_16_2) * penalty_16_2;
        pi[17,11] = (1 - slip_17_2) * penalty_17_2;
        pi[18,11] = (1 - slip_18_1) * penalty_18_1;
        pi[19,11] = (1 - slip_19_1) * penalty_19_1;
        pi[1,12] = (1 - slip_1_1);
        pi[2,12] = (1 - slip_2_3);
        pi[3,12] = (1 - slip_3_2);
        pi[4,12] = (1 - slip_4_1);
        pi[5,12] = (1 - slip_5_1);
        pi[6,12] = (1 - slip_6_2);
        pi[7,12] = (1 - slip_7_1);
        pi[8,12] = (1 - slip_8_3);
        pi[9,12] = (1 - slip_9_3);
        pi[10,12] = (1 - slip_10_3);
        pi[11,12] = (1 - slip_11_3);
        pi[12,12] = (1 - slip_12_1);
        pi[13,12] = (1 - slip_13_4) * penalty_13_4;
        pi[14,12] = (1 - slip_14_1);
        pi[15,12] = (1 - slip_15_1);
        pi[16,12] = (1 - slip_16_2);
        pi[17,12] = (1 - slip_17_2);
        pi[18,12] = (1 - slip_18_1);
        pi[19,12] = (1 - slip_19_1);
        pi[1,13] = (1 - slip_1_1);
        pi[2,13] = (1 - slip_2_3) * penalty_2_3;
        pi[3,13] = (1 - slip_3_2);
        pi[4,13] = (1 - slip_4_1);
        pi[5,13] = (1 - slip_5_1);
        pi[6,13] = (1 - slip_6_2);
        pi[7,13] = (1 - slip_7_1);
        pi[8,13] = (1 - slip_8_3) * penalty_8_3;
        pi[9,13] = (1 - slip_9_3) * penalty_9_3;
        pi[10,13] = (1 - slip_10_3) * penalty_10_3;
        pi[11,13] = (1 - slip_11_3) * penalty_11_3;
        pi[12,13] = (1 - slip_12_1);
        pi[13,13] = (1 - slip_13_4);
        pi[14,13] = (1 - slip_14_1);
        pi[15,13] = (1 - slip_15_1);
        pi[16,13] = (1 - slip_16_2);
        pi[17,13] = (1 - slip_17_2);
        pi[18,13] = (1 - slip_18_1);
        pi[19,13] = (1 - slip_19_1);
        pi[1,14] = (1 - slip_1_1);
        pi[2,14] = (1 - slip_2_3);
        pi[3,14] = (1 - slip_3_2) * penalty_3_2;
        pi[4,14] = (1 - slip_4_1);
        pi[5,14] = (1 - slip_5_1);
        pi[6,14] = (1 - slip_6_2) * penalty_6_2;
        pi[7,14] = (1 - slip_7_1);
        pi[8,14] = (1 - slip_8_3);
        pi[9,14] = (1 - slip_9_3);
        pi[10,14] = (1 - slip_10_3);
        pi[11,14] = (1 - slip_11_3);
        pi[12,14] = (1 - slip_12_1);
        pi[13,14] = (1 - slip_13_4);
        pi[14,14] = (1 - slip_14_1);
        pi[15,14] = (1 - slip_15_1);
        pi[16,14] = (1 - slip_16_2) * penalty_16_2;
        pi[17,14] = (1 - slip_17_2) * penalty_17_2;
        pi[18,14] = (1 - slip_18_1);
        pi[19,14] = (1 - slip_19_1);
        pi[1,15] = (1 - slip_1_1) * penalty_1_1;
        pi[2,15] = (1 - slip_2_3);
        pi[3,15] = (1 - slip_3_2);
        pi[4,15] = (1 - slip_4_1) * penalty_4_1;
        pi[5,15] = (1 - slip_5_1) * penalty_5_1;
        pi[6,15] = (1 - slip_6_2);
        pi[7,15] = (1 - slip_7_1) * penalty_7_1;
        pi[8,15] = (1 - slip_8_3);
        pi[9,15] = (1 - slip_9_3);
        pi[10,15] = (1 - slip_10_3);
        pi[11,15] = (1 - slip_11_3);
        pi[12,15] = (1 - slip_12_1) * penalty_12_1;
        pi[13,15] = (1 - slip_13_4);
        pi[14,15] = (1 - slip_14_1) * penalty_14_1;
        pi[15,15] = (1 - slip_15_1) * penalty_15_1;
        pi[16,15] = (1 - slip_16_2);
        pi[17,15] = (1 - slip_17_2);
        pi[18,15] = (1 - slip_18_1) * penalty_18_1;
        pi[19,15] = (1 - slip_19_1) * penalty_19_1;
        pi[1,16] = (1 - slip_1_1);
        pi[2,16] = (1 - slip_2_3);
        pi[3,16] = (1 - slip_3_2);
        pi[4,16] = (1 - slip_4_1);
        pi[5,16] = (1 - slip_5_1);
        pi[6,16] = (1 - slip_6_2);
        pi[7,16] = (1 - slip_7_1);
        pi[8,16] = (1 - slip_8_3);
        pi[9,16] = (1 - slip_9_3);
        pi[10,16] = (1 - slip_10_3);
        pi[11,16] = (1 - slip_11_3);
        pi[12,16] = (1 - slip_12_1);
        pi[13,16] = (1 - slip_13_4);
        pi[14,16] = (1 - slip_14_1);
        pi[15,16] = (1 - slip_15_1);
        pi[16,16] = (1 - slip_16_2);
        pi[17,16] = (1 - slip_17_2);
        pi[18,16] = (1 - slip_18_1);
        pi[19,16] = (1 - slip_19_1);
      }
      model {
      
        ////////////////////////////////// priors
        Vc ~ dirichlet(rep_vector(1, C));
        penalty_1_1 ~ beta(5, 25);
        slip_1_1 ~ beta(5, 25);
        penalty_2_3 ~ beta(5, 25);
        slip_2_3 ~ beta(5, 25);
        penalty_3_2 ~ beta(5, 25);
        slip_3_2 ~ beta(5, 25);
        penalty_4_1 ~ beta(5, 25);
        slip_4_1 ~ beta(5, 25);
        penalty_5_1 ~ beta(5, 25);
        slip_5_1 ~ beta(5, 25);
        penalty_6_2 ~ beta(5, 25);
        slip_6_2 ~ beta(5, 25);
        penalty_7_1 ~ beta(5, 25);
        slip_7_1 ~ beta(5, 25);
        penalty_8_3 ~ beta(5, 25);
        slip_8_3 ~ beta(5, 25);
        penalty_9_3 ~ beta(5, 25);
        slip_9_3 ~ beta(5, 25);
        penalty_10_3 ~ beta(5, 25);
        slip_10_3 ~ beta(5, 25);
        penalty_11_3 ~ beta(5, 25);
        slip_11_3 ~ beta(5, 25);
        penalty_12_1 ~ beta(5, 25);
        slip_12_1 ~ beta(5, 25);
        penalty_13_4 ~ beta(5, 25);
        slip_13_4 ~ beta(5, 25);
        penalty_14_1 ~ beta(5, 25);
        slip_14_1 ~ beta(5, 25);
        penalty_15_1 ~ beta(5, 25);
        slip_15_1 ~ beta(5, 25);
        penalty_16_2 ~ beta(5, 25);
        slip_16_2 ~ beta(5, 25);
        penalty_17_2 ~ beta(5, 25);
        slip_17_2 ~ beta(5, 25);
        penalty_18_1 ~ beta(5, 25);
        slip_18_1 ~ beta(5, 25);
        penalty_19_1 ~ beta(5, 25);
        slip_19_1 ~ beta(5, 25);
      
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

