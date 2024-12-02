lcdm_parameters <- function(qmatrix, identifier = NULL, max_interaction = Inf) {
  check_string(item_id, allow_null = TRUE)
  check_number_whole(max_interaction, min = 1, allow_infinite = TRUE)
  qmatrix <- rdcmchecks::check_qmatrix(qmatrix, identifier = identifier)

}
