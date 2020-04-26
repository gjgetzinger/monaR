#' Extract elements from a tibble returned by mona_query
#'
#' @param df A tibble returned by mona_query or mona_querySpectrum
#' @param what Which element to extract
#' @return
#' @export
#'
mona_extract <- function(df, what){
  UseMethod("mona_extract")
}

#' @describeIn mona_extract Extract identifiers from ID queries
mona_extract.mona_id_query <-
  function(df,
           what = c(
             "compound",
             "id",
             "dateCreated",
             "lastUpdated",
             "lastCurated",
             "metaData",
             "score",
             "spectrum",
             "tags",
             "library"
           )) {
    what <- match.arg(what, several.ok = F)
    x <- alply(df, .margins = 1, .fun = function(d) {
      map_dfc(magrittr::extract(d, what), function(y) {
        switch(
          class(y),
          list = map_dfr(y, as_tibble),
          character = tibble::enframe(y, name = NULL),
          numeric = tibble::enframe(y, name = NULL)
        )
      })
    }, .dims = F)
    return(x)
  }

#' @describeIn mona_extract Extract identifiers from spectrum queries
mona_extract.mona_spec_query <- function(df, what){}

