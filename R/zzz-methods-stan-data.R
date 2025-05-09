#' Create a list of data objects for 'Stan'
#'
#' When using 'Stan' to estimate a model, data objects must be passed as a list,
#' where the name each object corresponds to the name of a variable in the
#' `data` block of the 'Stan' code. `stan_data()` creates the list of data
#' objects needed to estimate the model, consistent with the `data` block
#' generated by [stan_code()].
#'
#' @param x An object (e.g., a [model specification][dcm_specify()]) to create
#'   a data list for.
#' @param ... Additional arguments passed to methods. See details.
#'
#' @return A list of data objects.
#' @export
#'
#' @examples
#' qmatrix <- data.frame(
#'   att1 = sample(0:1, size = 5, replace = TRUE),
#'   att2 = sample(0:1, size = 5, replace = TRUE)
#' )
#' data <- data.frame(
#'   item_1 = sample(0:1, size = 20, replace = TRUE),
#'   item_2 = sample(0:1, size = 20, replace = TRUE),
#'   item_3 = sample(0:1, size = 20, replace = TRUE),
#'   item_4 = sample(0:1, size = 20, replace = TRUE),
#'   item_5 = sample(0:1, size = 20, replace = TRUE)
#' )
#'
#' model_spec <- dcm_specify(qmatrix = qmatrix,
#'                           measurement_model = lcdm(),
#'                           structural_model = unconstrained())
#'
#' stan_data(model_spec, data = data)
stan_data <- S7::new_generic("stan_data", "x")


# dcm_specification method -----------------------------------------------------
#' @details
#' Arguments for [model specification][dcm_specify()] method:
#' * `data`: The response data. A data frame with 1 row per respondent and 1
#'   column per item. May optionally include an additional column of item
#'   identifiers. If an identifier is included, this should be specified with
#'   `identifier`. All cells for the remaining item columns should be either 0
#'   (incorrect response) or 1 (correct response).
#' * `missing`: An expression specifying how missing values in `data` are
#'   encoded (e.g., `NA`, `"."`, `-99`). The default is `NA`.
#' * `identifier`: Optional. If present, the quoted name of the column in
#'   `data` that contains respondent identifiers.
#' @name stan_data
S7::method(stan_data, dcm_specification) <- function(x, ..., data,
                                                     missing = NA,
                                                     identifier = NULL) {
  # check function inputs ------------------------------------------------------
  check_string(identifier, allow_null = TRUE)
  clean_data <- rdcmchecks::clean_data(
    data, identifier = identifier, missing = missing,
    cleaned_qmatrix = list(
      clean_qmatrix = x@qmatrix,
      attribute_names = x@qmatrix_meta$attribute_names,
      item_identifier = x@qmatrix_meta$item_identifier,
      item_names = x@qmatrix_meta$item_names
    ),
    arg_qmatrix = "x"
  )

  # default data list ----------------------------------------------------------
  ragged_array <- clean_data$clean_data |>
    tibble::rowid_to_column() |>
    dplyr::group_by(.data$resp_id) |>
    dplyr::summarize(start = min(.data$rowid),
                     num = dplyr::n()) |>
    dplyr::arrange(.data$resp_id)

  profiles <- create_profiles(x@structural_model,
                              attributes = x@qmatrix_meta$attribute_names)

  stan_data <- list(
    I = nrow(x@qmatrix),
    R = length(clean_data$respondent_names),
    N = nrow(clean_data$clean_data),
    C = nrow(profiles),
    ii = as.numeric(clean_data$clean_data$item_id),
    rr = as.numeric(clean_data$clean_data$resp_id),
    y = clean_data$clean_data$score,
    start = ragged_array$start,
    num = ragged_array$num
  )

  # extra data elements --------------------------------------------------------
  extra_meas <- extra_data(x@measurement_model, dcm_spec = x)
  extra_strc <- extra_data(x@structural_model, dcm_spec = x)

  # return data ----------------------------------------------------------------
  c(stan_data, extra_meas, extra_strc)
}

# generated quantities method --------------------------------------------------
#' @details
#' Arguments for [generated quantities][generated_quantities()] method:
#' * `dcm_spec`: A cleaned data object, as returned by
#'   [rdcmchecks::clean_data()].
#' * `data`: The response data. A data frame with 1 row per respondent and 1
#'   column per item. May optionally include an additional column of item
#'   identifiers. If an identifier is included, this should be specified with
#'   `identifier`. All cells for the remaining item columns should be either 0
#'   (incorrect response) or 1 (correct response).
#' * `missing`: An expression specifying how missing values in `data` are
#'   encoded (e.g., `NA`, `"."`, `-99`). The default is `NA`.
#' * `identifier`: Optional. If present, the quoted name of the column in
#'   `data` that contains respondent identifiers.
#' @name stan_data
S7::method(stan_data, quantities) <- function(x, ..., dcm_spec, data,
                                              missing = NA, identifier = NULL) {
  # check function inputs ------------------------------------------------------
  check_string(identifier, allow_null = TRUE)
  clean_data <- rdcmchecks::clean_data(
    data, identifier = identifier, missing = missing,
    cleaned_qmatrix = list(
      clean_qmatrix = dcm_spec@qmatrix,
      attribute_names = dcm_spec@qmatrix_meta$attribute_names,
      item_identifier = dcm_spec@qmatrix_meta$item_identifier,
      item_names = dcm_spec@qmatrix_meta$item_names
    ),
    arg_qmatrix = "x"
  )

  # default data list ----------------------------------------------------------
  ragged_array <- clean_data$clean_data |>
    tibble::rowid_to_column() |>
    dplyr::group_by(.data$resp_id) |>
    dplyr::summarize(start = min(.data$rowid),
                     num = dplyr::n()) |>
    dplyr::arrange(.data$resp_id)

  profiles <- create_profiles(
    dcm_spec@structural_model,
    attributes = dcm_spec@qmatrix_meta$attribute_names
  )

  stan_data <- list(
    I = nrow(dcm_spec@qmatrix),
    R = length(clean_data$respondent_names),
    N = nrow(clean_data$clean_data),
    C = nrow(profiles),
    A = ncol(dcm_spec@qmatrix),
    ii = as.numeric(clean_data$clean_data$item_id),
    rr = as.numeric(clean_data$clean_data$resp_id),
    y = clean_data$clean_data$score,
    start = ragged_array$start,
    num = ragged_array$num,
    Alpha = as.matrix(profiles)
  )

  # return data ----------------------------------------------------------------
  stan_data
}

# Extra data elements ----------------------------------------------------------
extra_data <- S7::new_generic("extra_data", "x", function(x, dcm_spec, ...) {
  S7::S7_dispatch()
})

S7::method(extra_data, S7::class_any) <- function(x, dcm_spec) NULL

S7::method(extra_data, DINA) <- function(x, dcm_spec) {
  profiles <- create_profiles(
    dcm_spec@structural_model,
    attributes = dcm_spec@qmatrix_meta$attribute_names
  )

  xi <- matrix(0, nrow = nrow(dcm_spec@qmatrix), ncol = nrow(profiles))
  for (i in seq_len(nrow(dcm_spec@qmatrix))) {
    for (c in seq_len(nrow(profiles))) {
      xi[i, c] <- prod(profiles[c, ] ^ dcm_spec@qmatrix[i, ])
    }
  }

  list(Xi = xi)
}

S7::method(extra_data, DINO) <- function(x, dcm_spec) {
  profiles <- create_profiles(
    dcm_spec@structural_model,
    attributes = dcm_spec@qmatrix_meta$attribute_names
  )

  xi <- matrix(0, nrow = nrow(dcm_spec@qmatrix), ncol = nrow(profiles))
  for (i in seq_len(nrow(dcm_spec@qmatrix))) {
    for (c in seq_len(nrow(profiles))) {
      xi[i, c] <- 1 - prod((1 - profiles[c, ]) ^ dcm_spec@qmatrix[i, ])
    }
  }

  list(Xi = xi)
}

S7::method(extra_data, INDEPENDENT) <- function(x, dcm_spec) {
  profiles <- create_profiles(
    dcm_spec@structural_model,
    attributes = dcm_spec@qmatrix_meta$attribute_names
  )

  list(A = length(dcm_spec@qmatrix_meta$attribute_names),
       Alpha = as.matrix(profiles))
}
