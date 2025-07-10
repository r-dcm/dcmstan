#' Checks the validity of the hierarchy
#'
#' @param x A character string containing the quoted attribute hierarchy.
#'
#' @returns A string.
#' @noRd
check_hierarchy <- function(x, allow_null = TRUE,
                            arg = rlang::caller_arg(x),
                            call = rlang::caller_env()) {
  if (is.null(x) && allow_null) return(invisible(NULL))

  check_string(x)

  g <- glue::glue(" graph { <x> } ", .open = "<", .close = ">")
  g <- dagitty::dagitty(g)

  if (nrow(dagitty::edges(g)) == 0) return(invisible(NULL))

  hierarchy <- glue::glue(" dag { <x> } ", .open = "<", .close = ">")
  hierarchy <- ggdag::tidy_dagitty(hierarchy)

  cycle_flag <- !dagitty::isAcyclic(g)

  bidirectional_flag <- hierarchy |>
    tibble::as_tibble() |>
    dplyr::filter(.data$direction == "<->")

  if (nrow(bidirectional_flag) > 0 || cycle_flag) {
    rdcmchecks::abort_bad_argument(arg = arg,
                                   must = "not be cyclical",
                                   call = call)
  }

  invisible(NULL)
}

check_hierarchy_names <- function(x, attribute_names,
                                  arg = rlang::caller_arg(x),
                                  call = rlang::caller_env()) {
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
#'
#' @returns A string.
#' @noRd
determine_hierarchy_type <- function(x, allow_null = TRUE) {
  if (is.null(x) && allow_null) return(invisible(NULL))

  check_string(x)

  g <- glue::glue(" graph { <x> } ", .open = "<", .close = ">")
  g <- dagitty::dagitty(g)

  if (nrow(dagitty::edges(g)) == 0) return(invisible(NULL))

  hierarchy <- glue::glue(" dag { <x> } ", .open = "<", .close = ">")
  hierarchy <- ggdag::tidy_dagitty(hierarchy)

  atts <- hierarchy |>
    tibble::as_tibble() |>
    dplyr::distinct(.data$name) |>
    dplyr::pull()

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

    tmp_hier <- tibble::tibble(attribute = tmp_att,
                               type = tmp_type,
                               converging_peers = list(succ_peer_att),
                               diverging_peers = list(pred_peer_att),
                               parents = list(parent_atts),
                               children = list(child_atts))

    hier_type <- dplyr::bind_rows(hier_type, tmp_hier)
  }

  return(hier_type)
}
