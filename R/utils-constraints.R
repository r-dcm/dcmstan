
check_constraint_data <- function(
    constraints,
    pattern_identifier = NULL,
    attribute_identifier = "attribute",
    classification_identifier = "classification",
    call = rlang::caller_env()
) {

  if (!inherits(constraints, "data.frame")) {
    rdcmchecks::abort_bad_argument(
      arg = "constraints",
      must = "be a data frame",
      not = typeof(constraints),
      call = call
    )
  }
  if (nrow(constraints) == 0) {
    rdcmchecks::abort_bad_argument(
      arg = "constraints",
      must = "be a non-empty data frame",
      not = typeof(constraints),
      call = call
    )
  }
  if (!is.null(pattern_identifier) &&
      !pattern_identifier %in% names(constraints)) {
    rdcmchecks::abort_bad_argument(
      arg = "pattern_identifier",
      must = "be included in `constraints`",
      call = call
    )
  }
  if (!attribute_identifier %in% names(constraints)) {
    rdcmchecks::abort_bad_argument(
      arg = "attribute_identifier",
      must = "be included in `constraints`",
      call = call
    )
  }
  if (!classification_identifier %in% names(constraints)) {
    rdcmchecks::abort_bad_argument(
      arg = "classification_identifier",
      must = "be included in `constraints`",
      call = call
    )
  }

  if (!is.null(pattern_identifier)) {
    pattern_values <- dplyr::pull(constraints, {{ pattern_identifier }})
    if (!is.character(pattern_values) | anyNA(pattern_values)) {
      rdcmchecks::abort_bad_argument(
        arg = "pattern_identifier",
        must = "contain only character strings",
        call = call
      )
    }
    constraints <- constraints |>
      dplyr::mutate(dplyr::across({{ pattern_identifier }}, as.character))
  }

  attribute_values <- dplyr::pull(constraints, {{ attribute_identifier }})
  if (!is.character(attribute_values) | anyNA(attribute_values)) {
    rdcmchecks::abort_bad_argument(
      arg = "attribute_identifier",
      must = "contain only character strings",
      call = rlang::caller_env()
    )
  }
  constraints <- constraints |>
    dplyr::mutate(dplyr::across({{ attribute_identifier }}, as.character))

  classification_values <- dplyr::pull(constraints, {{ classification_identifier }})
  if (!is.integer(classification_values) | anyNA(classification_values)) {
    rdcmchecks::abort_bad_argument(
      arg = "classification_identifier",
      must = "contain only numeric values of 0 or 1 ",
      call = call
    )
  }
  constraints <- constraints |>
    dplyr::mutate(dplyr::across({{ classification_identifier }}, as.integer))

  constraints

}

check_threshold_data <- function(
    thresholds,
    classification_identifier = "classification",
    threshold_identifier = "threshold",
    call = rlang::caller_env()
) {

  if (!inherits(thresholds, "data.frame")) {
    rdcmchecks::abort_bad_argument(
      arg = "thresholds",
      must = "be a data frame",
      not = typeof(thresholds),
      call = call
    )
  }
  if (nrow(thresholds) == 0) {
    rdcmchecks::abort_bad_argument(
      arg = "thresholds",
      must = "be a non-empty data frame",
      not = typeof(constraints),
      call = call
    )
  }
  if (!classification_identifier %in% names(thresholds)) {
    rdcmchecks::abort_bad_argument(
      arg = "classification_identifier",
      must = "be included in `thresholds`",
      call = call
    )
  }
  if (!threshold_identifier %in% names(thresholds)) {
    rdcmchecks::abort_bad_argument(
      arg = "threshold_identifier",
      must = "be included in `thresholds`",
      call = call
    )
  }

  classification_values <- dplyr::pull(thresholds, {{ classification_identifier }})
  if (!is.integer(classification_values) | anyNA(classification_values)) {
    rdcmchecks::abort_bad_argument(
      arg = "classification_identifier",
      must = "contain only numeric values of 0 or 1 ",
      call = call
    )
  }
  thresholds <- dplyr::mutate(thresholds, dplyr::across({{ classification_identifier }}, as.integer))

  threshold_values <- dplyr::pull(thresholds, {{ threshold_identifier }})
  if (!is.numeric(threshold_values) | anyNA(threshold_values) |
      !all(dplyr::between(threshold_values, left = 0, right = 1))) {
    rdcmchecks::abort_bad_argument(
      arg = "threshold_identifier",
      must = "contain only numeric values between 0 and 1 ",
      call = call
    )
  }

  classification_count <- thresholds %>%
    dplyr::select({{ classification_identifier }}) %>%
    dplyr::summarize(n = dplyr::n(),
                     .by = {{ classification_identifier }})

  if (any(classification_count$n > 1)) {
    rdcmchecks::abort_bad_argument(
      arg = "thresholds",
      must = "contain only one threshold value per classification",
      call = call
    )
  }

  thresholds <- thresholds %>%
    dplyr::arrange({{ classification_identifier }})

  if (any(diff(thresholds$threshold) > 0)) {
    rdcmchecks::abort_bad_argument(
      arg = "thresholds",
      must = paste(
        "contain threshold values that are non-decreasing",
        "with increasing classification values"
        ),
      call = call
    )
  }

  thresholds
}

clean_constraints <- function(
    constraints,
    missing,
    thresholds,
    pattern_identifier,
    attribute_identifier,
    classification_identifier,
    threshold_identifier,
    call = rlang::caller_env()
) {

  if (!is.null(pattern_identifier)) {
    check_string(pattern_identifier)
  }
  check_string(attribute_identifier)
  check_string(classification_identifier)
  check_string(threshold_identifier)

  constraints <- check_constraint_data(
    constraints = constraints,
    pattern_identifier = pattern_identifier,
    attribute_identifier = attribute_identifier,
    classification_identifier = classification_identifier
  )
  thresholds <- check_threshold_data(
    thresholds = thresholds,
    classification_identifier = classification_identifier,
    threshold_identifier = threshold_identifier
  )

  cnst_class_entries <- constraints |>
    dplyr::distinct(classification) |>
    dplyr::pull(classification)
  thrs_class_entries <- thresholds |>
    dplyr::distinct(classification) |>
    dplyr::pull(classification)

  extr_class <- setdiff(thrs_class_entries, cnst_class_entries)
  miss_class <- setdiff(cnst_class_entries, thrs_class_entries)

  if (length(extr_class)) {
    rdcmchecks::abort_bad_argument(
      arg = "thresholds",
      must = "only include classifications present in `constraints`",
      call = call
    )
  }
  if (length(miss_class)) {
    rdcmchecks::abort_bad_argument(
      arg = "thresholds",
      must = "include all classifications present in `constraints`",
      call = call
    )
  }

  constraints <- constraints |>
    dplyr::rename(
      att = dplyr::all_of(attribute_identifier),
      class = dplyr::all_of(classification_identifier)
    )
  if (!is.null(pattern_identifier)) {
    constraints <- constraints |>
      dplyr::rename(
        pattern = dplyr::all_of(pattern_identifier)
      )
  }
  thresholds <- thresholds |>
    dplyr::rename(
      class = dplyr::all_of(classification_identifier),
      tau = dplyr::all_of(threshold_identifier)
    )

  response_cols <- setdiff(names(constraints), c("att", "class", "pattern"))
  lookup <- constraints |>
    dplyr::rename(stan_pattern = dplyr::any_of("pattern")) |>
    dplyr::group_by(dplyr::across(dplyr::all_of(response_cols))) |>
    dplyr::mutate(stan_pattern = dplyr::cur_group_id(), .before = 1) |>
    dplyr::ungroup() |>
    dplyr::arrange(stan_pattern) |>
    dplyr::left_join(thresholds,
                     by = c("class"))

  patt_data <- lookup |>
    dplyr::select(pattern = stan_pattern, response_cols) %>%
    dplyr::distinct()

  patt_data <- rdcmchecks::check_data(patt_data, identifier = "pattern",
                                      missing = NA)

  patt_data <- patt_data %>%
    tidyr::pivot_longer(cols = -c(pattern),
                        names_to = "item", values_to = "score")

  cnst_data <- lookup |>
    dplyr::select(pattern = stan_pattern, att, class, tau)

  list(
    patterns = patt_data,
    constraints = cnst_data
  )

}



#' #' @param item_names A vector of expected items.
#' #' @noRd
#' check_constraint_names <- function(
#'     x,
#'     item_names,
#'     arg = rlang::caller_arg(x),
#'     call = rlang::caller_env()
#' ) {
#'   check_character(item_names)
#'   cnst_item_names <- names(x)
#'
#'   extr_item <- setdiff(cnst_item_names, item_names)
#'   miss_item <- setdiff(item_names, cnst_item_names)
#'
#'   if (length(extr_item)) {
#'     rdcmchecks::abort_bad_argument(
#'       arg = arg,
#'       must = "only include items in `constraints` arg present in the Q-matrix",
#'       footer = cli::format_message(
#'         c(i = "Extra items: {.val {extr_item}}")
#'       ),
#'       call = call
#'     )
#'   }
#'
#'   if (length(miss_item)) {
#'     rdcmchecks::abort_bad_argument(
#'       arg = arg,
#'       must = "include all item in `constraints` arg present in the Q-matrix",
#'       footer = cli::format_message(
#'         c(i = "Missing items: {.val {miss_item}}")
#'       ),
#'       call = call
#'     )
#'   }
#'
#'   invisible(NULL)
#' }
