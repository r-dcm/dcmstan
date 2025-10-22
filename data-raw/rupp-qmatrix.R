# This small example Q-matrix is used throughout Chapter 6 (The Statistical
# Structure of Core DCMs) and Chapter 7 (The LCDM Framework) of Rupp et al.
# (2010) to demonstrate the different parameters that are included in each DCM
# subtype.

# nolint start: indentation_linter
rupp_math <- tibble::tribble(
  ~items,   ~addition, ~subtraction, ~multiplication, ~division,
  "Item 1",         1,            1,               0,         0,
  "Item 2",         0,            0,               0,         1,
  "Item 3",         0,            1,               1,         0,
  "Item 4",         1,            0,               0,         0
)

rupp_gri <- tibble::tribble(
  ~item, ~attribute1, ~attribute2, ~attribute3, ~attribute4,
  "GRI1",          1,           0,           0,           0,
  "GRI2",          0,           1,           1,           0,
  "GRI3",          0,           0,           0,           1,
  "GRI4",          0,           1,           1,           1
)

rupp_profiles <- tibble::tribble(
  ~id, ~rupp_id, ~att1, ~att2, ~att3, ~att4,
   1L,        1L,     0,     0,     0,     0,
   2L,        9L,     1,     0,     0,     0,
   3L,        5L,     0,     1,     0,     0,
   4L,        3L,     0,     0,     1,     0,
   5L,        2L,     0,     0,     0,     1,
   6L,       13L,     1,     1,     0,     0,
   7L,       11L,     1,     0,     1,     0,
   8L,       10L,     1,     0,     0,     1,
   9L,        7L,     0,     1,     1,     0,
  10L,       6L,     0,     1,     0,     1,
  11L,       4L,     0,     0,     1,     1,
  12L,      15L,     1,     1,     1,     0,
  13L,      14L,     1,     1,     0,     1,
  14L,      12L,     1,     0,     1,     1,
  15L,       8L,     0,     1,     1,     1,
  16L,      16L,     1,     1,     1,     1
)
# nolint end

usethis::use_data(
  rupp_math,
  rupp_gri,
  rupp_profiles,
  internal = TRUE,
  overwrite = TRUE
)
