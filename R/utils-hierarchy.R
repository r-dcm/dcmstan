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
