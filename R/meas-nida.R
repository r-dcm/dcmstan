#' 'Stan' code for the NIDA model
#'
#' Create the `parameters` and `transformed parameters` blocks that are needed
#' for the NIDA model. The function also returns the code that defines the
#' prior distributions for each parameter, which is used in the `model` block.
#'
#' @param qmatrix A cleaned matrix (via [rdcmchecks::clean_qmatrix()]).
#' @param priors Priors for the model, specified through a combination of
#'   [default_dcm_priors()] and [prior()].
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @rdname nida
#' @noRd
meas_nida <- function(qmatrix, priors) {
  # parameters block -----
  parameters_block <- glue::glue(
    "  ////////////////////////////////// attribute parameters",
    "  array[to_int(log2(C))] real<lower=0,upper=1> slip;",
    "  array[to_int(log2(C))] real<lower=0,upper=1> guess;",
    .sep = "\n", .trim = FALSE
  )

  # transformed parameters block -----
  all_profiles <- create_profiles(ncol(qmatrix))

  profiles <- all_profiles |>
    tibble::rowid_to_column("profile_id") |>
    tidyr::pivot_longer(cols = -"profile_id", names_to = "att",
                        values_to = "meas")

  profile_params <- tibble::tibble(profile_id = seq_len(nrow(all_profiles))) |>
    tidyr::crossing(att = colnames(qmatrix)) |>
    dplyr::left_join(profiles, by = c("profile_id", "att")) |>
    dplyr::mutate(att_num = as.numeric(substr(.data$att, 4, nchar(.data$att))),
                  param = dplyr::case_when(meas == 0 ~ paste0("guess[",
                                                              .data$att_num,
                                                              "]"),
                                           meas == 1 ~ paste0("(1 - slip[",
                                                              .data$att_num,
                                                              "])"))) |>
    dplyr::select("profile_id", "att", "param")

  pi_def <- tidyr::expand_grid(item_id = seq_len(nrow(qmatrix)),
                               profile_id = seq_len(nrow(all_profiles))) |>
    dplyr::left_join(qmatrix |>
                       stats::setNames(glue::glue("att{1:ncol(qmatrix)}")) |>
                       tibble::rowid_to_column("item_id") |>
                       tidyr::pivot_longer(cols = -c("item_id"),
                                           names_to = "att_id",
                                           values_to = "valid") |>
                       dplyr::filter(.data$valid == 1L) |>
                       dplyr::select(-"valid"),
                     by = "item_id", relationship = "many-to-many") |>
    dplyr::left_join(profile_params, by = c("profile_id", "att_id" = "att")) |>
    tidyr::pivot_wider(names_from = "att_id", values_from = "param") |>
    tidyr::unite(col = "param", -c("item_id", "profile_id"), sep = "*",
                 remove = TRUE, na.rm = TRUE) |>
    glue::glue_data("pi[{item_id},{profile_id}] = {param};")

  transformed_parameters_block <- glue::glue(
    "  matrix[I,C] pi;",
    "",
    "  ////////////////////////////////// probability of correct response",
    "  {glue::glue_collapse(pi_def, sep = \"\n  \")}",
    .sep = "\n", .trim = FALSE
  )

  # priors -----
  att_priors <- nida_parameters(qmatrix = qmatrix) |>
    dplyr::left_join(dcmstan:::prior_tibble(priors) %>%
                       dplyr::select(-"coefficient"),
                     by = c("type")) |>
    dplyr::mutate(prior_def = glue::glue("{coefficient} ~ {prior};")) |>
    dplyr::pull("prior_def")

  # return -----
  return(list(parameters = parameters_block,
              transformed_parameters = transformed_parameters_block,
              priors = att_priors))
}
