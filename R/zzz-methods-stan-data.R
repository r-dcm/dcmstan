

# Create Stan code -------------------------------------------------------------
stan_data_code <- S7::new_generic("stan_data", c("meas", "strc"))

S7::method(stan_data_code, list(measurement, structural)) <-
  function(meas, strc) {
    data_block <- glue::glue(
      "data {{
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
      }}"
    )
  }

S7::method(stan_data_code, list(DINA, structural)) <- function(meas, strc) {
  data_block <- glue::glue(
    "data {{
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
    }}"
  )
}

S7::method(stan_data_code, list(DINO, structural)) <- function(meas, strc) {
  data_block <- glue::glue(
    "data {{
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
    }}"
  )
}


