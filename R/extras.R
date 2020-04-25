#' Download the spectra identifier table from MONA
#'
#' @param update (T/F) should the file be downloaded
#'
#' @return Saves table as an R-object
#'
mona_identifiers <- function(update = F) {
  if (update) {
    temp <- tempfile()
    download.file(
      'https://mona.fiehnlab.ucdavis.edu/rest/downloads/static/MoNA-export-All_Spectra-identifier-table-ids.zip',
      temp
    )
    a <- unzip(zipfile = temp)
    mona_identifiers <-
      readr::read_csv(a, col_names = c('acession', 'splash', 'inchikey', 'smiles'))
    unlink(c(a, temp))
    usethis::use_data(mona_identifiers, overwrite = T)
  }
}
