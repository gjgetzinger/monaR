test_that("Spectral similarity search works", {
  expect_true(
    'MXWJVTOOROXGIU-UHFFFAOYSA-N' %in% sapply(mona_querySpec(spectrum = atrazine_ms2)$hit$compound, function(x){x[['inchiKey']]})
  )
})
