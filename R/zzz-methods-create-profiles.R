#' Generate mastery profiles
#'
#' Given the number of attributes or model specification, generate all possible
#' patterns of attribute mastery.
#'
#' @param x Positive integer. The number of attributes being measured.
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
create_profiles <- S7::new_generic("create_profiles", "x")


# general methods --------------------------------------------------------------
S7::method(create_profiles, S7::class_numeric) <- function(x) {
  check_number_whole(x, min = 1)

  rep(list(c(0L, 1L)), times = x) |>
    stats::setNames(glue::glue("att{seq_len(x)}")) |>
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

S7::method(create_profiles, dcm_specification) <- function(x) {
  create_profiles(x@structural,
                  attributes = length(x@qmatrix_meta$attribute_names))
}

S7::method(create_profiles, structural) <- function(x, attributes) {
 create_profiles(attributes)
}


# specific structural models ---------------------------------------------------
