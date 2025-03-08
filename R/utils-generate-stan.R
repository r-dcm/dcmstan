#' Identify the lower level components of an LCDM parameter
#'
#' @param x A character string indicating the attributes measured by an item,
#'   seperated by a double underscore (`__`).
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
