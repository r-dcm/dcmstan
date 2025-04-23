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
one_down_params <- function(x, item, possible_params = NULL) {
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

      if (!is.null(possible_params)) {
        att_combos <- intersect(
          paste("l", item, "_", level,
                sapply(att_combos, paste, collapse = ""),
                sep = ""),
          possible_params
        )
      } else {
        att_combos <- paste("l", item, "_", level,
                            sapply(att_combos, paste, collapse = ""),
                            sep = "")
      }

      att_comp[level] <- paste(att_combos,
                               sep = "", collapse = "+")
    }
    comps[[att]] <- paste(att_comp[which(att_comp != "")], collapse = "+")
  }

  paste(comps[vapply(comps, \(x) x != "", logical(1))], collapse = ",")
}
