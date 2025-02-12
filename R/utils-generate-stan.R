#' Generate mastery profiles
#'
#' Given the number of attributes, generate all possible patterns of attribute
#' mastery.
#'
#' @param attributes Positive integer. The number of attributes being measured.
#'
#' @return A [tibble][tibble::tibble-package] with all possible attribute
#'   mastery profiles. Each row is a profile, and each column indicates whether
#'   the attribute in that column was mastered (1) or not mastered (0). Thus,
#'   the tibble will have `2^attributes` rows, and `attributes` columns.
#' @export
#'
#' @examples
#' create_profiles(3L)
#' create_profiles(5)
create_profiles <- function(attributes) {
  check_number_whole(attributes, min = 1)

  rep(list(c(0L, 1L)), times = attributes) |>
    stats::setNames(glue::glue("att{seq_len(attributes)}")) |>
    expand.grid() |>
    dplyr::rowwise() |>
    dplyr::mutate(total = sum(dplyr::c_across(dplyr::everything()))) |>
    dplyr::select("total", dplyr::everything()) |>
    dplyr::arrange(.data$total,
                   dplyr::desc(dplyr::across(dplyr::everything()))) |>
    dplyr::ungroup() |>
    dplyr::select(-"total") |>
    tibble::as_tibble()
}


#' Identify the lower level components of an LCDM parameter
#'
#' @param x A character string indicating the attributes measured by an item,
#'   separated by a double underscore (`__`).
#' @param item The item number.
#'
#' @returns A character string with the component parameters.
#' @noRd
#'
#' @examples
#' one_down_params("1__2", item = 4)
#' one_down_params("1__3__4", item = 11)
one_down_params <- function(x, item) {
  all_atts <- strsplit(x, split = "__")[[1]]
  if (length(all_atts) <= 1) return("")

  comps <- vector("list", length(all_atts))
  for (att in seq_along(all_atts)) {
    att_comp <- vector("character", length(all_atts) - 1)
    for (level in seq_along(att_comp)) {
      att_combos <- utils::combn(all_atts, m = level, simplify = FALSE)
      att_combos <- att_combos[vapply(att_combos,
                                      function(.x, att) {
                                        any(.x == att)
                                      },
                                      logical(1), att = all_atts[att])]

      att_comp[level] <- paste("l", item, "_", level,
                               sapply(att_combos, paste, collapse = ""),
                               sep = "", collapse = "+")
    }
    comps[[att]] <- paste(att_comp, collapse = "+")
  }

  paste(comps, collapse = ",")
}
one_down_params <- Vectorize(one_down_params, USE.NAMES = FALSE)
