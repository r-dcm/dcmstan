#' Checks the validity of the hierarchy
#'
#' @param x A character string containing the quoted attribute hierarchy.
#' @param allow_null Logical. Should a `NULL` value be accepted?
#' @param arg The name of the argument.
#' @param call The call stack.
#'
#' @returns A string.
#' @noRd
check_hierarchy <- function(
  x,
  allow_null = TRUE,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  if (is.null(x) && allow_null) {
    return(invisible(NULL))
  }

  check_string(x)

  g <- glue::glue(" graph { <x> } ", .open = "<", .close = ">")
  g <- dagitty::dagitty(g)

  if (nrow(dagitty::edges(g)) == 0) {
    return(invisible(NULL))
  }

  hierarchy <- glue::glue(" dag { <x> } ", .open = "<", .close = ">")
  hierarchy <- ggdag::tidy_dagitty(hierarchy)

  cycle_flag <- !dagitty::isAcyclic(g)

  bidirectional_flag <- hierarchy |>
    tibble::as_tibble() |>
    dplyr::filter(.data$direction == "<->")

  if (nrow(bidirectional_flag) > 0 || cycle_flag) {
    rdcmchecks::abort_bad_argument(
      arg = arg,
      must = "not be cyclical",
      call = call
    )
  }

  invisible(NULL)
}

#' @param attribute_names A vector of expected attributes.
#' @noRd
check_hierarchy_names <- function(
  x,
  attribute_names,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  check_string(x)
  check_character(attribute_names)

  g <- dagitty::dagitty(glue::glue("dag {{ {x} }}"))
  hier_names <- if (nrow(dagitty::edges(g)) == 0) {
    x
  } else {
    g |>
      ggdag::as_tidy_dagitty() |>
      tibble::as_tibble() |>
      dplyr::pull("name")
  }

  extr_hier <- setdiff(hier_names, attribute_names)
  miss_hier <- setdiff(attribute_names, hier_names)

  if (length(extr_hier)) {
    rdcmchecks::abort_bad_argument(
      arg = arg,
      must = "only include attributes in a hierarchy present in the Q-matrix",
      footer = cli::format_message(
        c(i = "Extra attributes: {.val {extr_hier}}")
      ),
      call = call
    )
  }

  if (length(miss_hier)) {
    rdcmchecks::abort_bad_argument(
      arg = arg,
      must = "include all attributes in a hierarchy present in the Q-matrix",
      footer = cli::format_message(
        c(i = "Missing attributes: {.val {miss_hier}}")
      ),
      call = call
    )
  }

  invisible(NULL)
}

#' Determines the type of hierarchy
#'
#' @param x A character string containing the quoted attribute hierarchy.
#' @param qmatrix A Q-matrix specifying which attributes are measured by which
#'   items.
#'
#' @returns A string.
#' @noRd
determine_hierarchy_type <- function(x, qmatrix, allow_null = TRUE) {
  if (is.null(x) && allow_null) {
    return(invisible(NULL))
  }

  check_string(x)

  g <- glue::glue(" graph { <x> } ", .open = "<", .close = ">")
  g <- dagitty::dagitty(g)

  if (nrow(dagitty::edges(g)) == 0) {
    return(invisible(NULL))
  }

  hierarchy <- glue::glue(" dag { <x> } ", .open = "<", .close = ">")
  hierarchy <- ggdag::tidy_dagitty(hierarchy)

  atts <- qmatrix |>
    colnames()

  hier_type <- tibble::tibble()

  for (ii in atts) {
    tmp_att <- ii

    successor_att <- hierarchy |>
      tibble::as_tibble() |>
      dplyr::filter(!is.na(.data$direction)) |>
      dplyr::filter(.data$to == tmp_att)

    predecessor_att <- hierarchy |>
      tibble::as_tibble() |>
      dplyr::filter(!is.na(.data$direction)) |>
      dplyr::filter(.data$name == tmp_att)

    if (nrow(successor_att) > 0) {
      pred_att <- successor_att |>
        dplyr::pull(.data$name)

      pred_peer_att <- c()

      for (jj in pred_att) {
        tmp_pred_peer_att <- hierarchy |>
          tibble::as_tibble() |>
          dplyr::filter(!is.na(.data$direction)) |>
          dplyr::filter(.data$name == jj) |>
          dplyr::filter(.data$to != tmp_att)

        if (nrow(tmp_pred_peer_att) > 0) {
          tmp_pred_peer_att <- tmp_pred_peer_att |>
            dplyr::pull(.data$to)
        } else {
          tmp_pred_peer_att <- NA_character_
        }

        pred_peer_att <- c(pred_peer_att, tmp_pred_peer_att)
        if (all(is.na(pred_peer_att))) pred_peer_att <- NA_character_
      }
    } else {
      pred_peer_att <- NA_character_
    }

    if (nrow(predecessor_att) > 0) {
      succ_att <- predecessor_att |>
        dplyr::pull(.data$to)

      succ_peer_att <- c()

      for (jj in succ_att) {
        tmp_succ_peer_att <- hierarchy |>
          tibble::as_tibble() |>
          dplyr::filter(!is.na(.data$direction)) |>
          dplyr::filter(.data$to == jj) |>
          dplyr::filter(.data$name != tmp_att)

        if (nrow(tmp_succ_peer_att) > 0) {
          tmp_succ_peer_att <- tmp_succ_peer_att |>
            dplyr::pull(.data$name)
        } else {
          tmp_succ_peer_att <- NA_character_
        }

        succ_peer_att <- c(succ_peer_att, tmp_succ_peer_att)
        if (all(is.na(succ_peer_att))) succ_peer_att <- NA_character_
      }
    } else {
      succ_peer_att <- NA_character_
    }

    if (nrow(successor_att) > 1 && nrow(predecessor_att) > 1) {
      tmp_type <- "complex"
    } else if (nrow(successor_att) > 1) {
      tmp_type <- "converging"
    } else if (nrow(predecessor_att) > 1) {
      tmp_type <- "diverging"
    } else if (nrow(successor_att) == 1 && nrow(predecessor_att) == 1) {
      tmp_type <- "linear"
    } else if (nrow(successor_att) == 0 && nrow(predecessor_att) >= 1) {
      tmp_type <- "origin"
    } else if (nrow(successor_att) >= 1 && nrow(predecessor_att) == 0) {
      tmp_type <- "end"
    } else {
      tmp_type <- "non-hierarchical"
    }

    if (nrow(predecessor_att) > 0) {
      child_atts <- predecessor_att |>
        dplyr::pull(.data$to)
    } else {
      child_atts <- NA_character_
    }

    if (nrow(successor_att) > 0) {
      parent_atts <- successor_att |>
        dplyr::pull(.data$name)
    } else {
      parent_atts <- NA_character_
    }

    tmp_hier <- tibble::tibble(
      attribute = tmp_att,
      type = tmp_type,
      converging_peers = list(succ_peer_att),
      diverging_peers = list(pred_peer_att),
      parents = list(parent_atts),
      children = list(child_atts)
    )

    hier_type <- dplyr::bind_rows(hier_type, tmp_hier)
  }

  return(hier_type)
}

#' Update parameter constraints when there is an attribute hierarchy
#'
#' @param meas_params A tibble containing the measurement parameters for the
#'   model.
#' @param hierarchy If present, the quoted attribute hierarchy. See
#'   \code{vignette("dagitty4semusers", package = "dagitty")} for a tutorial on
#'   how to draw the attribute hierarchy.
#' @param qmatrix A Q-matrix specifying which attributes are measured by which
#'   items.
#' @param att_names Vector of attribute names, as in the
#'   `qmatrix_meta$attribute_names` of a [DCM specification][dcm_specify()].
#'
#' @returns An updated `meas_params` object.
#' @noRd
update_constraints <- function(meas_params, hierarchy, qmatrix, att_names) {
  att_dict <- att_names |>
    tibble::as_tibble() |>
    dplyr::rename("new_name" = "value") |>
    dplyr::mutate(name = names(att_names))

  type_hierarchy <- determine_hierarchy_type(hierarchy, qmatrix)

  diverging_peers <- type_hierarchy |>
    dplyr::filter(.data$type == "diverging") |>
    dplyr::select("attribute", "children") |>
    tidyr::unnest("children") |>
    dplyr::group_by(.data$attribute) |>
    dplyr::mutate(child_num = dplyr::row_number()) |>
    dplyr::ungroup() |>
    dplyr::mutate(child_num = paste0("child", as.character(.data$child_num))) |>
    dplyr::left_join(att_dict, by = c("attribute" = "name")) |>
    dplyr::select(-"attribute") |>
    dplyr::rename("attribute" = "new_name") |>
    dplyr::left_join(att_dict, by = c("children" = "name")) |>
    dplyr::select(-"children") |>
    dplyr::rename("children" = "new_name") |>
    tidyr::pivot_wider(names_from = "child_num", values_from = "children")

  diverging_items <- tibble::tibble()

  if (nrow(diverging_peers) > 0) {
    for (nn in seq_len(nrow(diverging_peers))) {
      tmp_diverging <- diverging_peers[nn, ]

      tmp2 <- tmp_diverging |>
        dplyr::select(-"attribute") |>
        tidyr::pivot_longer(
          cols = dplyr::everything(),
          names_to = "child_num",
          values_to = "att"
        ) |>
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

      diverging_items <- dplyr::bind_rows(diverging_items, possible_items)
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
    dplyr::mutate(
      parent_num = paste0("parent", as.character(.data$parent_num))
    ) |>
    dplyr::left_join(att_dict, by = c("attribute" = "name")) |>
    dplyr::select(-"attribute") |>
    dplyr::rename("attribute" = "new_name") |>
    dplyr::left_join(att_dict, by = c("parents" = "name")) |>
    dplyr::select(-"parents") |>
    dplyr::rename("parent" = "new_name") |>
    tidyr::pivot_wider(names_from = "parent_num", values_from = "parent")

  converging_items <- tibble::tibble()

  if (nrow(converging_peers) > 0) {
    for (nn in seq_len(nrow(converging_peers))) {
      tmp_converging <- converging_peers[nn, ]

      tmp2 <- tmp_converging |>
        dplyr::select(-"attribute") |>
        tidyr::pivot_longer(
          cols = dplyr::everything(),
          names_to = "parent_num",
          values_to = "att"
        ) |>
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

      converging_items <- dplyr::bind_rows(converging_items, possible_items)
    }
  }

  if (nrow(converging_items) == 0) {
    converging_items <- tibble::tibble(item_id = -9999, converging = FALSE)
  }

  meas_params |>
    dplyr::left_join(diverging_items, by = "item_id") |>
    dplyr::mutate(
      diverging = dplyr::case_when(
        .data$param_level <= 1 ~ FALSE,
        is.na(.data$diverging) ~ FALSE,
        TRUE ~ .data$diverging
      )
    ) |>
    dplyr::left_join(converging_items, by = "item_id") |>
    dplyr::mutate(
      converging = dplyr::case_when(
        .data$param_level <= 1 ~ FALSE,
        is.na(.data$converging) ~ FALSE,
        TRUE ~ .data$converging
      )
    ) |>
    dplyr::mutate(
      constraint = dplyr::case_when(
        .data$param_level >= 2 ~ glue::glue("<lower=0>"),
        TRUE ~ .data$constraint
      ),
      param_def = glue::glue("real{constraint} {param_name};")
    ) |>
    dplyr::select(-"diverging", -"converging")
}
