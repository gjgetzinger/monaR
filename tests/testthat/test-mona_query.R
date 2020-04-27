test_that("Querying MONA by name works", {
  expect_true(
    'MXWJVTOOROXGIU-UHFFFAOYSA-N' %in% sapply(mona_query(query = 'Atrazine', from = "name")$compound, function(x) {
      x[['inchiKey']]
    }, simplify = T)
  )
})

test_that("Querying MONA by InChI Key works", {
  expect_true(
    'MXWJVTOOROXGIU-UHFFFAOYSA-N' %in% sapply(mona_query(query = 'MXWJVTOOROXGIU-UHFFFAOYSA-N', from = "InChIKey")$compound, function(x) {
      x[['inchiKey']]
    }, simplify = T)
  )
})

test_that("Querying MONA by partial InChI Key works", {
  expect_true(
    'MXWJVTOOROXGIU-UHFFFAOYSA-N' %in% sapply(mona_query(query = 'MXWJVTOOROXGIU', from = "InChIKey")$compound, function(x) {
      x[['inchiKey']]
    }, simplify = T)
  )
})

test_that("Querying MONA by molecular formula works", {
  expect_true(
    'MXWJVTOOROXGIU-UHFFFAOYSA-N' %in% sapply(mona_query(query = 'C8H14ClN5', from = "molform")$compound, function(x) {
      x[['inchiKey']]
    }, simplify = T)
  )
})

test_that("Querying MONA by mass works", {
  expect_true(
    'MXWJVTOOROXGIU-UHFFFAOYSA-N' %in% sapply(mona_query(query = 216, mass_tol_Da = 1, from = "mass")$compound, function(x) {
      x[['inchiKey']]
    }, simplify = T)
  )
})
