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
    "  array[A] real<lower=0,upper=1> slip;",
    "  array[A] real<lower=0,upper=1> guess;",
    .sep = "\n", .trim = FALSE
  )

  # transformed parameters block -----
  all_profiles <- create_profiles(ncol(qmatrix))

  profiles <- all_profiles |>
    tibble::rowid_to_column("profile_id") |>
    tidyr::pivot_longer(cols = -"profile_id", names_to = "att",
                        values_to = "meas")

  profile_params <- tibble::tibble(profile_id = 1:nrow(all_profiles)) |>
    tidyr::crossing(att = colnames(qmatrix)) |>
    dplyr::left_join(profiles, by = c("profile_id", "att")) |>
    dplyr::mutate(att_num = as.numeric(substr(.data$att, 4, nchar(.data$att))),
                  param = dplyr::case_when(meas == 0 ~ paste0("guess[",
                                                              .data$att_num,
                                                              "]"),
                                           meas == 1 ~ paste0("slip[",
                                                              .data$att_num,
                                                              "]"))) |>
    dplyr::select("profile_id", "att", "param")

    # stats::model.matrix(stats::as.formula(paste0("~ .^",
    #                                              max(ncol(all_profiles),
    #                                                  2L))),
    #                     all_profiles) |>
    # tibble::as_tibble(.name_repair = model_matrix_name_repair) |>
    # tibble::rowid_to_column(var = "profile_id") |>
    # tidyr::pivot_longer(-"profile_id", names_to = "parameter",
    #                     values_to = "valid_for_profile")

  # meas_att <- stats::model.matrix(
  #   stats::as.formula(
  #     paste0("~ .^", max(ncol(all_profiles), 2L))
  #   ),
  #   all_profiles
  # ) |>
  #   tibble::as_tibble(.name_repair = model_matrix_name_repair) |>
  #   tibble::rowid_to_column(var = "profile_id") |>
  #   tidyr::pivot_longer(-"profile_id", names_to = "parameter",
  #                       values_to = "valid_for_profile") |>
  #   dplyr::distinct(.data$parameter) |>
  #   tidyr::crossing(item_id = seq_len(nrow(qmatrix))) |>
  #   dplyr::arrange(.data$item_id) |>
  #   dplyr::left_join(qmatrix |>
  #                      stats::setNames(glue::glue("att{1:ncol(qmatrix)}")) |>
  #                      tibble::rowid_to_column("item_id") |>
  #                      tidyr::pivot_longer(cols = -"item_id", names_to = "att",
  #                                          values_to = "meas") |>
  #                      dplyr::filter(.data$meas == 1) |>
  #                      dplyr::select(-"meas"),
  #                    by = "item_id", relationship = "many-to-many") |>
  #   dplyr::filter(.data$parameter == .data$att |
  #                   grepl(.data$att, .data$parameter)) |>
  #   dplyr::count(.data$item_id, .data$parameter) |>
  #   dplyr::mutate(num_atts = stringr::str_count(.data$parameter, "att")) |>
  #   dplyr::filter(.data$n == .data$num_atts) |>
  #   dplyr::select("item_id", "parameter")

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
    glue::glue_data("pi[{item_id},{profile_id}] = inv_logit({param});")

    # dplyr::left_join(
    #   dplyr::select(meas_params, "parameter", "param_name") |>
    #     dplyr::mutate(att_id = dplyr::case_when(
    #       .data$parameter == "intercept" ~
    #         paste0("att", stringr::str_remove(.data$param_name, "l_0")),
    #       grepl("l_1", .data$param_name) ~ .data$parameter,
    #       TRUE ~ NA_character_
    #     )),
    #   by = "att_id", multiple = "all", relationship = "many-to-many"
    # ) |>
    # dplyr::select(-"parameter") |>
    # dplyr::full_join(profile_params |>
    #                    dplyr::filter(.data$valid_for_profile == 1),
    #                  by = c("profile_id"),
    #                  relationship = "many-to-many") |>
    # dplyr::mutate(parameter = dplyr::case_when(.data$parameter == "intercept" ~
    #                                              .data$att_id,
    #                                            TRUE ~ .data$parameter)) |>
    # dplyr::semi_join(meas_att, by = c("item_id", "parameter")) |>
    # dplyr::mutate(parameter = dplyr::case_when(
    #   grepl("l_0", .data$param_name) ~ "intercept",
    #   TRUE ~ .data$parameter
    # )) |>
    # dplyr::anti_join(profile_params |>
    #                    dplyr::filter(.data$valid_for_profile == 0) |>
    #                    dplyr::select(-"valid_for_profile"),
    #                  by = c("profile_id", "parameter")) |>
    # dplyr::distinct() |>
    # dplyr::select("item_id", "profile_id", "parameter", "att_id") |>
    # dplyr::mutate(
    #   int_term = dplyr::case_when(
    #     grepl("\\_\\_", .data$parameter) ~
    #       stringr::str_remove_all(.data$parameter, "att"),
    #     TRUE ~ NA_character_
    #   ),
    #   int_term = dplyr::case_when(
    #     grepl("\\_\\_", .data$parameter) ~
    #       stringr::str_remove(.data$int_term, "\\_\\_"),
    #     TRUE ~ .data$int_term
    #   ),
    #   param_name = dplyr::case_when(
    #     .data$parameter == "intercept" ~
    #       paste0("l_0", stringr::str_remove(.data$att_id, "att")),
    #     grepl("\\_\\_", .data$parameter) ~
    #       paste0("l_2", .data$int_term),
    #     TRUE ~ paste0("l_1", stringr::str_remove(.data$parameter,
    #                                                      "att"))
    #   )
    # ) |>
    # dplyr::distinct(.data$item_id, .data$profile_id, .data$param_name) |>
    # dplyr::group_by(.data$item_id, .data$profile_id) |>
    # dplyr::summarize(meas_params = paste(unique(.data$param_name),
    #                                      collapse = "+"),
    #                  .groups = "drop") |>
    # dplyr::arrange(.data$item_id, .data$profile_id) |>
    # glue::glue_data("pi[{item_id},{profile_id}] = inv_logit({meas_params});")


  transformed_parameters_block <- glue::glue(
    "  matrix[I,C] pi;",
    "",
    "  ////////////////////////////////// probability of correct response",
    "  {glue::glue_collapse(pi_def, sep = \"\n  \")}",
    .sep = "\n", .trim = FALSE
  )

  # priors -----
  # item_priors <- meas_params |>
  #   dplyr::mutate(
  #     type = dplyr::case_when(.data$param_level == 0 ~ "intercept",
  #                             .data$param_level == 1 ~ "maineffect",
  #                             .data$param_level > 1 ~ "interaction")
  #   ) |>
  #   dplyr::left_join(prior_tibble(priors),
  #                    by = c("type", "param_name" = "coefficient"),
  #                    relationship = "one-to-one") |>
  #   dplyr::rename(coef_def = "prior") |>
  #   dplyr::left_join(prior_tibble(priors) |>
  #                      dplyr::filter(is.na(.data$coefficient)) |>
  #                      dplyr::select(-"coefficient"),
  #                    by = c("type"), relationship = "many-to-one") |>
  #   dplyr::rename(type_def = "prior") |>
  #   dplyr::mutate(
  #     prior = dplyr::case_when(!is.na(.data$coef_def) ~ .data$coef_def,
  #                              is.na(.data$coef_def) ~ .data$type_def),
  #     prior_def = glue::glue("{param_name} ~ {prior};")
  #   ) |>
  #   dplyr::arrange(.data$param_level, .data$param_name) |>
  #   dplyr::pull("prior_def")

  att_priors <- nida_parameters(qmatrix = qmatrix) |>
    dplyr::left_join(prior_tibble(priors), by = c("type", "coefficient")) |>
    dplyr::rename(coef_def = "prior") |>
    dplyr::left_join(prior_tibble(priors) |>
                       dplyr::filter(is.na(.data$coefficient)) |>
                       dplyr::select(-"coefficient"),
                     by = c("type")) |>
    dplyr::rename(type_def = "prior") |>
    dplyr::mutate(
      prior = dplyr::case_when(!is.na(.data$coef_def) ~ .data$coef_def,
                               is.na(.data$coef_def) ~ .data$type_def),
      prior_def = glue::glue("{coefficient} ~ {prior};")
    ) |>
    dplyr::pull("prior_def")

  # return -----
  return(list(parameters = parameters_block,
              transformed_parameters = transformed_parameters_block,
              priors = att_priors))
}
