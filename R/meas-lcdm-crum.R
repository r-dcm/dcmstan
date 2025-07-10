#' 'Stan' code for the LCDM and C-RUM models
#'
#' Create the `parameters` and `transformed parameters` blocks that are needed
#' for the LCDM and C-RUM models. The function also returns the code that
#' defines the prior distributions for each parameter, which is used in the
#' `model` block.
#'
#' @param qmatrix A cleaned matrix (via [rdcmchecks::clean_qmatrix()]).
#' @param max_interaction The highest level interaction that should be included
#'   in the model. For the C-RUM, this is always 1 (i.e., main effects only).
#' @param priors Priors for the model, specified through a combination of
#'   [default_dcm_priors()] and [prior()].
#' @param att_names Vector of attribute names, as in the
#'   `qmatrix_meta$attribute_names` of a [DCM specification][dcm_specify()].
#' @param max_interaction The highest item-level interaction to include in the
#'   model.
#' @param hierarchy Optional. If present, the quoted attribute hierarchy. See
#'   \code{vignette("dagitty4semusers", package = "dagitty")} for a tutorial on
#'   how to draw the attribute hierarchy.
#'
#' @returns A list with three element: `parameters`, `transformed_parameters`,
#'   and `priors`.
#' @rdname lcdm-crum
#' @noRd
meas_lcdm <- function(qmatrix, priors, att_names = NULL, max_interaction = Inf,
                      hierarchy = NULL) {

  # parameters block -----
  all_params <- lcdm_parameters(qmatrix = qmatrix,
                                max_interaction = max_interaction,
                                att_names = att_names,
                                hierarchy = hierarchy,
                                rename_attributes = TRUE,
                                rename_items = TRUE)

  if (!is.null(hierarchy)) {
    type_hierarchy <- determine_hierarchy_type(hierarchy)

    att_dict <- att_names |>
      tibble::as_tibble() %>%
      dplyr::rename(new_name = value) |>
      dplyr::mutate(name = names(att_names))

    meas_all <- create_profiles(ncol(qmatrix))[2^ncol(qmatrix), ]
    all_poss_params <- lcdm_parameters(qmatrix = meas_all,
                                       max_interaction = max_interaction,
                                       att_names = att_names,
                                       hierarchy = NULL,
                                       rename_attributes = TRUE,
                                       rename_items = TRUE) |>
      dplyr::select("attributes", "coefficient")
    all_allowable_params <- lcdm_parameters(qmatrix = meas_all,
                                            max_interaction = max_interaction,
                                            att_names = att_names,
                                            hierarchy = hierarchy,
                                            rename_attributes = TRUE,
                                            rename_items = TRUE) |>
      dplyr::select("attributes", "coefficient")
    params_to_update <- all_poss_params |>
      dplyr::left_join(all_allowable_params |>
                         dplyr::mutate(allowable = TRUE),
                       by = c("attributes", "coefficient")) |>
      dplyr::filter(is.na(.data$allowable)) |>
      dplyr::mutate(new_att = NA)
    good_params <- all_poss_params |>
      dplyr::left_join(all_allowable_params |>
                         dplyr::mutate(allowable = TRUE),
                       by = c("attributes", "coefficient")) |>
      dplyr::filter(!is.na(.data$allowable))

    for (ii in seq_len(nrow(params_to_update))) {
      tmp_att <- params_to_update$attributes[ii]
      tmp_att <- strsplit(tmp_att, "__")[[1]]
      tmp_att <- paste0(tmp_att, collapse=".*")

      tmp_replacement <- good_params |>
        dplyr::filter(grepl(tmp_att, .data$attributes)) |>
        tidyr::separate(col = "coefficient",
                        into = c("item_param", "coefficient"), sep = "_")

      params_to_update$coefficient[ii] <- tmp_replacement$coefficient[1]
      params_to_update$allowable[ii] <- TRUE
      params_to_update$new_att[ii] <- tmp_replacement$attributes[1]
    }

    stan_att_dict <- all_poss_params |>
      dplyr::left_join(params_to_update |>
                         dplyr::rename("new_coef" = "coefficient") |>
                         dplyr::select(-"allowable"),
                       by = c("attributes")) |>
      tidyr::separate(col = "coefficient",
                      into = c("item_param", "coefficient"), sep = "_") |>
      dplyr::select(-"item_param") |>
      dplyr::mutate(coefficient = dplyr::case_when(is.na(.data$new_coef) ~
                                                     .data$coefficient,
                                                   !is.na(.data$new_coef) ~
                                                     .data$new_coef)) |>
      dplyr::select(-"new_coef")

    diverging_peers <- type_hierarchy |>
      dplyr::filter(.data$type == "diverging") |>
      dplyr::select("attribute", "children") |>
      tidyr::unnest("children") |>
      dplyr::group_by(.data$attribute) |>
      dplyr::mutate(child_num = dplyr::row_number()) |>
      dplyr::ungroup() |>
      dplyr::mutate(child_num = paste0("child",
                                       as.character(.data$child_num))) |>
      dplyr::left_join(att_dict, by = c("attribute" = "name")) |>
      dplyr::select(-"attribute") |>
      dplyr::rename(attribute = new_name) |>
      dplyr::left_join(att_dict, by = c("children" = "name")) |>
      dplyr::select(-"children") |>
      dplyr::rename(children = new_name) |>
      tidyr::pivot_wider(names_from = "child_num", values_from = "children")

    diverging_items <- tibble::tibble()

    if (nrow(diverging_peers) > 0) {
      for (nn in seq_len(nrow(diverging_peers))) {
        tmp_diverging <- diverging_peers[nn, ]

        tmp2 <- tmp_diverging |>
          dplyr::select(-"attribute") |>
          tidyr::pivot_longer(cols = dplyr::everything(),
                              names_to = "child_num", values_to = "att") |>
          dplyr::select(-"child_num")

        possible_items <- qmatrix |>
          tibble::rowid_to_column("item_id")

        for (pp in seq_len(nrow(tmp2))) {
          tmp_att <- tmp2$att[pp]

          possible_items <- possible_items |>
            dplyr::filter(!!sym(tmp_att) == 1)
        }

        possible_items <- possible_items |>
          dplyr::select("item_id") |>
          dplyr::mutate(diverging = TRUE)

        diverging_items <- bind_rows(diverging_items, possible_items)
      }
    }

    if (nrow(diverging_items) == 0) {
      diverging_items <- tibble::tibble(item_id = -9999, diverging = FALSE)
    }

    converging_peers <- type_hierarchy |>
      dplyr::filter(.data$type == "converging") |>
      dplyr::select("attribute", "parents") |>
      tidyr::unnest("parents") |>
      dplyr::group_by(.data$attribute) |>
      dplyr::mutate(parent_num = dplyr::row_number()) |>
      dplyr::ungroup() |>
      dplyr::mutate(parent_num = paste0("parent",
                                        as.character(.data$parent_num))) |>
      dplyr::left_join(att_dict, by = c("attribute" = "name")) |>
      dplyr::select(-"attribute") |>
      dplyr::rename(attribute = new_name) |>
      dplyr::left_join(att_dict, by = c("parents" = "name")) |>
      dplyr::select(-"parents") |>
      dplyr::rename(parent = new_name) |>
      tidyr::pivot_wider(names_from = "parent_num", values_from = "parent")

    converging_items <- tibble::tibble()

    if (nrow(converging_peers) > 0) {
      for (nn in seq_len(nrow(converging_peers))) {
        tmp_converging <- converging_peers[nn, ]

        tmp2 <- tmp_converging |>
          dplyr::select(-"attribute") |>
          tidyr::pivot_longer(cols = dplyr::everything(),
                              names_to = "parent_num", values_to = "att") |>
          dplyr::select(-"parent_num")

        possible_items <- qmatrix |>
          tibble::rowid_to_column("item_id")

        for (pp in seq_len(nrow(tmp2))) {
          tmp_att <- tmp2$att[pp]

          possible_items <- possible_items |>
            dplyr::filter(!!sym(tmp_att) == 1)
        }

        possible_items <- possible_items |>
          dplyr::select("item_id") |>
          dplyr::mutate(converging = TRUE)

        converging_items <- bind_rows(converging_items, possible_items)
      }
    }

    if (nrow(converging_items) == 0) {
      converging_items <- tibble::tibble(item_id = -9999, converging = FALSE)
    }
  } else {
    stan_att_dict <- tibble::tibble(attributes = "fake_att", coefficient = "0",
                                    new_att = NA)
    diverging_items <- tibble::tibble(item_id = -9999, diverging = FALSE)
    converging_items <- tibble::tibble(item_id = -9999, converging = FALSE)
  }

  meas_params <- all_params |>
    tidyr::separate(col = "coefficient", into = c("item_param", "old_coef"),
                    sep = "_") |>
    dplyr::left_join(stan_att_dict, by = c("attributes")) |>
    dplyr::mutate(coefficient = paste0("l", .data$item_id, "_",
                                       .data$coefficient),
                  attributes = dplyr::case_when(!is.na(.data$new_att) ~
                                                  .data$new_att,
                                                TRUE ~ .data$attributes)) |>
    dplyr::select("item_id", "type", "attributes", "coefficient") |>
    dplyr::mutate(parameter = dplyr::case_when(is.na(.data$attributes) ~
                                                 "intercept",
                                               TRUE ~ .data$attributes)) |>
    dplyr::select("item_id", "parameter", param_name = "coefficient") |>
    dplyr::mutate(
      param_level = dplyr::case_when(
        .data$parameter == "intercept" ~ 0,
        !grepl("__", .data$parameter) ~ 1,
        TRUE ~ sapply(gregexpr(pattern = "__", text = .data$parameter),
                      function(.x) length(attr(.x, "match.length"))) + 1
      ),
      atts = gsub("[^0-9|_]", "", .data$parameter),
      comp_atts = mapply(
        one_down_params, .data$atts, .data$item_id,
        MoreArgs = list(possible_params = all_params$coefficient)
      ),
      param_name = glue::glue("l{item_id}_{param_level}",
                              "{gsub(\"__\", \"\", atts)}")
    ) |>
    dplyr::filter(.data$param_level <= max_interaction) |>
    dplyr::left_join(diverging_items, by = "item_id") |>
    dplyr::mutate(diverging = dplyr::case_when(.data$param_level <= 1 ~ FALSE,
                                               is.na(.data$diverging) ~ FALSE,
                                               TRUE ~ .data$diverging)) |>
    dplyr::left_join(converging_items, by = "item_id") |>
    dplyr::mutate(converging = dplyr::case_when(.data$param_level <= 1 ~ FALSE,
                                                is.na(.data$converging) ~ FALSE,
                                                TRUE ~ .data$converging)) |>
    dplyr::mutate(constraint = dplyr::case_when(
        .data$param_level == 0 ~ glue::glue(""),
        .data$param_level == 1 ~ glue::glue("<lower=0>"),
        .data$param_level >= 2 & diverging ~
          glue::glue("<lower=-1 * min([{comp_atts}])>"),
        .data$param_level >= 2 & converging ~
          glue::glue("<lower=-1 * min([{comp_atts}])>"),
        .data$param_level >= 2 ~ glue::glue("<lower=0>")
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
  interactions <- meas_params |>
    dplyr::filter(.data$param_level >= 2) |>
    dplyr::arrange(.data$item_id, .data$param_name) |>
    dplyr::pull(.data$param_def)

  interaction_stan <- if (length(interactions) > 0) {
    glue::glue(
      "",
      "",
      "  ////////////////////////////////// item interactions",
      "  {glue::glue_collapse(interactions, sep = \"\n  \")}",
      .sep = "\n", .trim = FALSE
    )
  } else {
    ""
  }

  parameters_block <- glue::glue(
    "  ////////////////////////////////// item intercepts",
    "  {glue::glue_collapse(intercepts, sep = \"\n  \")}",
    "",
    "  ////////////////////////////////// item main effects",
    "  {glue::glue_collapse(main_effects, sep = \"\n  \")}{interaction_stan}",
    .sep = "\n", .trim = FALSE
  )

  # transformed parameters block -----
  all_profiles <- if (is.null(hierarchy)) {
    create_profiles(ncol(qmatrix))
  } else {
    create_profiles(hdcm(hierarchy = hierarchy),
                    attributes = att_names)
  }

  profile_params <-
    stats::model.matrix(stats::as.formula(paste0("~ .^",
                                                 max(ncol(all_profiles),
                                                     2L))),
                        all_profiles) |>
    tibble::as_tibble(.name_repair = model_matrix_name_repair) |>
    tibble::rowid_to_column(var = "profile_id") |>
    tidyr::pivot_longer(-"profile_id", names_to = "parameter",
                        values_to = "valid_for_profile")

  pi_def <- tidyr::expand_grid(item_id = unique(meas_params$item_id),
                               profile_id = seq_len(nrow(all_profiles))) |>
    dplyr::left_join(dplyr::select(meas_params, "item_id", "parameter",
                                   "param_name"),
                     by = "item_id",
                     multiple = "all", relationship = "many-to-many") |>
    dplyr::left_join(profile_params, by = c("profile_id", "parameter"),
                     relationship = "many-to-one") |>
    dplyr::filter(.data$valid_for_profile == 1) |>
    dplyr::group_by(.data$item_id, .data$profile_id) |>
    dplyr::arrange(.data$item_id, .data$profile_id, .data$param_name) |>
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
                              .data$param_level == 1 ~ "maineffect",
                              .data$param_level > 1 ~ "interaction")
    ) |>
    dplyr::arrange(.data$item_id, .data$param_name) |>
    dplyr::left_join(prior_tibble(priors),
                     by = c("type", "param_name" = "coefficient"),
                     relationship = "one-to-one") |>
    dplyr::rename(coef_def = "prior") |>
    dplyr::left_join(prior_tibble(priors) |>
                       dplyr::filter(is.na(.data$coefficient)) |>
                       dplyr::select(-"coefficient"),
                     by = c("type"), relationship = "many-to-one") |>
    dplyr::rename(type_def = "prior") |>
    dplyr::mutate(
      prior = dplyr::case_when(!is.na(.data$coef_def) ~ .data$coef_def,
                               .data$type == "interaction" &
                                 .data$constraint == "<lower=0>" ~
                                 "lognormal(0, 1)",
                               is.na(.data$coef_def) ~ .data$type_def),
      prior_def = glue::glue("{param_name} ~ {prior};")
    ) |>
    dplyr::pull("prior_def")

  # return -----
  return(list(parameters = parameters_block,
              transformed_parameters = transformed_parameters_block,
              priors = item_priors))
}

#' @rdname lcdm-crum
#' @noRd
meas_crum <- function(qmatrix, priors, att_names = NULL, hierarchy = NULL) {
  meas_lcdm(qmatrix, max_interaction = 1L, priors = priors,
            hierarchy = hierarchy, att_names = att_names)
}
