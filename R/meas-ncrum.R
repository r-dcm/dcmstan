#' 'Stan' code for the NC-RUM model
#'
#' Create the `parameters` and `transformed parameters` blocks that are needed
#' for the NC-RUM model. The function also returns the code that defines the
#' prior distributions for each parameter, which is used in the `model` block.
#'
#' @param qmatrix A cleaned matrix (via [rdcmchecks::clean_qmatrix()]).
#' @param priors Priors for the model, specified through a combination of
#'   [default_dcm_priors()] and [prior()].
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @rdname ncrum
#' @noRd
meas_ncrum <- function(qmatrix, priors, att_names = NULL, hierarchy = NULL) {
  # parameters block -----
  all_params <- ncrum_parameters(qmatrix = qmatrix,
                                 rename_attributes = TRUE,
                                 rename_items = TRUE)

  params <- all_params |>
    dplyr::mutate(param = paste0("real<lower=0,upper=1> ", .data$coefficient,
                                 ";")) |>
    dplyr::pull(.data$param)

  parameters_block <- glue::glue(
    "  ////////////////////////////////// parameters",
    "  {glue::glue_collapse(params, sep = \"\n  \")}",
    .sep = "\n", .trim = FALSE
  )

  # transformed parameters block -----
  all_profiles <- create_profiles(ncol(qmatrix))

  profiles <- all_profiles |>
    tibble::rowid_to_column("profile_id") |>
    tidyr::pivot_longer(cols = -"profile_id", names_to = "att",
                        values_to = "meas") |>
    dplyr::mutate(att = as.numeric(sub("att", "", .data$att)))

  q <- qmatrix |>
    tibble::rowid_to_column("item_id") |>
    tidyr::pivot_longer(cols = -c("item_id"), names_to = "att_id",
                        values_to = "measured") |>
    dplyr::mutate(att_id = as.numeric(sub("att", "", .data$att_id)))

  pi_def <- tidyr::crossing(profiles |>
                              dplyr::select(-"meas"),
                            q |>
                              dplyr::select(-"measured"),
                            type = c("slip", "penalty")) |>
    dplyr::filter(.data$att == .data$att_id) |>
    dplyr::select("profile_id", "item_id", "att_id", "type") |>
    dplyr::left_join(profiles |>
                       dplyr::rename(att_id = "att", mastered = "meas"),
                     by = c("profile_id", "att_id")) |>
    dplyr::left_join(q, by = c("item_id", "att_id")) |>
    dplyr::arrange(.data$profile_id, .data$item_id, .data$att_id,
                   dplyr::desc(.data$type)) |>
    dplyr::filter(.data$measured == 1) |>
    dplyr::mutate(missing = .data$measured - .data$mastered) |>
    dplyr::left_join(all_params, by = c("item_id", "att_id", "type")) |>
    dplyr::mutate(param = dplyr::case_when(type == "slip" ~
                                             paste0("(1 - ", .data$coefficient,
                                                    ")"),
                                           missing == 0 & type == "penalty" ~
                                             NA_character_,
                                           TRUE ~ .data$coefficient)) |>
    dplyr::select("profile_id", "item_id", "param") |>
    dplyr::group_by(.data$profile_id, .data$item_id) |>
    dplyr::mutate(param_num = dplyr::row_number()) |>
    dplyr::ungroup() |>
    tidyr::pivot_wider(names_from = "param_num", values_from = "param") |>
    tidyr::unite(col = "param", -c("profile_id", "item_id"),
                 remove = TRUE, na.rm = TRUE, sep = " * ") |>
    dplyr::mutate(full_param = paste0("pi[", .data$item_id, ",",
                                      .data$profile_id, "] = ", .data$param,
                                      ";")) |>
    dplyr::pull(.data$full_param)


  transformed_parameters_block <- glue::glue(
    "  matrix[I,C] pi;",
    "",
    "  ////////////////////////////////// probability of correct response",
    "  {glue::glue_collapse(pi_def, sep = \"\n  \")}",
    .sep = "\n", .trim = FALSE
  )

  # priors -----
  prior_def <- ncrum_parameters(qmatrix = qmatrix) |>
    dplyr::left_join(prior_tibble(priors) |>
                       dplyr::select(-"coefficient"),
                     by = c("type")) |>
    dplyr::mutate(prior_def = glue::glue("{coefficient} ~ {prior};")) |>
    dplyr::pull("prior_def")

  # return -----
  return(list(parameters = parameters_block,
              transformed_parameters = transformed_parameters_block,
              priors = prior_def))
}
