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



#' Generate constrained mastery profiles for hierarchical measurement model
#'
#' Given an attribute hierarchy, generate the consistent patterns of attribute
#' mastery.
#'
#' @param attributes Positive integer. The number of attributes being measured.
#' @param hierarchy A tibble specifying the attribute hierarchy (via
#'   [ggdag::tidy_dagitty()]).
#' @param att_labels A tibble mapping the generic attribute names to the
#'   attribute names from the user-specified Q-matrix.
#'
#'
#' @return A [tibble][tibble::tibble-package] with all possible attribute
#'   mastery profiles. Each row is a profile, and each column indicates whether
#'   the attribute in that column was mastered (1) or not mastered (0). Thus,
#'   the tibble will have `2^attributes` rows, and `attributes` columns.
#' @export
#'
#' @examples
#' create_hierarchical_profiles(3, ggdag::tidy_dagitty(" dag { x -> y -> z } "),
#'                              att_labels = tibble::tibble(att = c("att1",
#'                                                                  "att2",
#'                                                                  "att3"),
#'                                                          att_label =c("A1",
#'                                                                       "A2",
#'                                                                       "A3")))
#' create_hierarchical_profiles(4,
#'                              ggdag::tidy_dagitty(" dag {x -> y -> z -> a} "),
#'                              att_labels = tibble::tibble(att = c("att1",
#'                                                                  "att2",
#'                                                                  "att3",
#'                                                                  "att4"),
#'                                                          att_label =c("A1",
#'                                                                       "A2",
#'                                                                       "A3",
#'                                                                       "A4")))
create_hierarchical_profiles <- function(attributes, hierarchy, att_labels) {
  check_number_whole(attributes, min = 1)

  all_profiles <- create_profiles(attributes)

  hierarchy <- hierarchy |>
    tibble::as_tibble() |>
    dplyr::select("name", "direction", "to") |>
    dplyr::left_join(att_labels, by = c("name" = "att_label")) |>
    dplyr::select(name = "att", "direction", "to") |>
    dplyr::left_join(att_labels, by = c("to" = "att_label")) |>
    dplyr::select("name", "direction", to = "att") |>
    dplyr::filter(!is.na(.data$direction))

  for (jj in seq_len(nrow(hierarchy))) {
    all_profiles <- all_profiles |>
      dplyr::filter(!!rlang::sym(hierarchy$name[jj]) >=
                      !!rlang::sym(hierarchy$to[jj]))
  }

  return(all_profiles)
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
