#' 'Stan' code for the NIDO model
#'
#' Create the `parameters` and `transformed parameters` blocks that are needed
#' for the NIDO model. The function also returns the code that defines the
#' prior distributions for each parameter, which is used in the `model` block.
#'
#' @param qmatrix A cleaned matrix (via [rdcmchecks::clean_qmatrix()]).
#' @param priors Priors for the model, specified through a combination of
#'   [default_dcm_priors()] and [prior()].
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @rdname nido
#' @noRd
meas_nido <- function(qmatrix, priors) {
  # parameters block -----
  all_params <- nido_parameters(qmatrix = qmatrix)

  meas_params <- all_params |>
    dplyr::mutate(parameter = .data$type) |>
    dplyr::select("att_id", "parameter", param_name = "coefficient") |>
    dplyr::mutate(
      param_level = dplyr::case_when(
        .data$parameter == "intercept" ~ 0,
        .data$parameter == "maineffect" ~ 1),
      constraint = dplyr::case_when(
        .data$param_level == 0 ~ glue::glue(""),
        .data$param_level == 1 ~ glue::glue("<lower=0>")
      ),
      param_def = dplyr::case_when(
        .data$param_level == 0 ~ glue::glue("real {param_name};"),
        .data$param_level >= 1 ~ glue::glue("real{constraint} {param_name};")
      )
    )

  intercepts <- meas_params |>
    dplyr::filter(.data$param_level == 0) |>
    dplyr::pull(.data$param_def)
  main_effects <- meas_params |>
    dplyr::filter(.data$param_level == 1) |>
    dplyr::pull(.data$param_def)

  parameters_block <- glue::glue(
    "  ////////////////////////////////// item intercepts",
    "  {glue::glue_collapse(intercepts, sep = \"\n  \")}",
    "",
    "  ////////////////////////////////// item main effects",
    "  {glue::glue_collapse(main_effects, sep = \"\n  \")}",
    .sep = "\n", .trim = FALSE
  )

  # transformed parameters block -----
  all_profiles <- create_profiles(attributes = ncol(qmatrix))

  profile_params <-
    stats::model.matrix(stats::as.formula(paste0("~ .^",
                                                 max(ncol(all_profiles),
                                                     2L))),
                        all_profiles) |>
    tibble::as_tibble(.name_repair = model_matrix_name_repair) |>
    tibble::rowid_to_column(var = "profile_id") |>
    tidyr::pivot_longer(-"profile_id", names_to = "parameter",
                        values_to = "valid_for_profile")

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
    dplyr::left_join(dplyr::select(meas_params |>
                                     dplyr::mutate(att_id = stringr::str_c(
                                       "att", as.character(.data$att_id)
                                     )),
                                   "att_id", "parameter", "param_name"),
                     by = "att_id",
                     multiple = "all", relationship = "many-to-many") |>
    dplyr::mutate(parameter = dplyr::case_when(.data$parameter == "maineffect" ~
                                                 .data$att_id,
                                               TRUE ~ .data$parameter)) |>
    dplyr::left_join(profile_params, by = c("profile_id", "parameter"),
                     relationship = "many-to-one") |>
    dplyr::filter(.data$valid_for_profile == 1) |>
    dplyr::group_by(.data$item_id, .data$profile_id) |>
    dplyr::summarize(meas_params = paste(unique(.data$param_name),
                                         collapse = "+"),
                     .groups = "drop") |>
    glue::glue_data("pi[{item_id},{profile_id}] = inv_logit({meas_params});")

  transformed_parameters_block <- glue::glue(
    "  matrix[I,C] pi;",
    "",
    "  ////////////////////////////////// probability of correct response",
    "  {glue::glue_collapse(pi_def, sep = \"\n  \")}",
    .sep = "\n", .trim = FALSE
  )

  # priors -----
  item_priors <- meas_params |>
    dplyr::mutate(
      type = dplyr::case_when(.data$param_level == 0 ~ "intercept",
                              .data$param_level == 1 ~ "maineffect")
    ) |>
    dplyr::left_join(prior_tibble(priors),
                     by = c("type"),
                     relationship = "many-to-many") |>
    dplyr::mutate(
      prior_def = glue::glue("{param_name} ~ {prior};")
    ) |>
    dplyr::pull("prior_def")

  # return -----
  return(list(parameters = parameters_block,
              transformed_parameters = transformed_parameters_block,
              priors = item_priors))
}

