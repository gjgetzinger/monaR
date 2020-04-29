#' Query MONA API by a mass spectrum
#'
#' @param spectrum A spectrum as either a dataframe with variables mz,intensity or a space deliminated stinrg of mz:inensity pairs.
#' @param minSimilarity Minimum spectral similarity for searching
#' @param precursorMZ The precursor ion m/z
#' @param precursorToleranceDa Search tolerance in dalton
#' @param precursorTolerancePPM Search tolerance in ppm
#'
#' @return a tibble containing query results
#' @export
#'
mona_querySpec <-
  function(spectrum = NULL,
           minSimilarity = NULL,
           precursorMZ = NULL,
           precursorToleranceDa = NULL,
           precursorTolerancePPM = NULL) {
    stopifnot(!is.null(spectrum))
    url <-
      'https://mona.fiehnlab.ucdavis.edu/rest/similarity/search'

    spectrum <- mona_parseSpec(spectrum)

    query <- list(spectrum = spectrum)

    if (!is.null(minSimilarity)) {
      query['minSimiliarity'] <- minSimilarity
    }
    if (!is.null(precursorMZ)) {
      query['precursorMZ'] <- precursorMZ
    }

    if (!is.null(precursorTolerancePPM)) {
      query['precursorTolerancePPM'] <- precursorTolerancePPM
    }

    if (!is.null(precursorToleranceDa) &
        is.null(precursorTolerancePPM)) {
      # only use Da if ppm not provided
      query['precursorToleranceDa'] <- precursorToleranceDa
    }

    query <- jsonlite::toJSON(query, auto_unbox = T)

    resp <-
      httr::POST(
        url,
        body = query,
        httr::accept_json(),
        httr::content_type_json(),
        httr::timeout(getOption('timeout'))
      )

    httr::stop_for_status(resp)

    if (resp$status_code == 200) {
      cont <- httr::content(resp, "text")
      parsed <- dplyr::as_tibble(jsonlite::fromJSON(cont))
    } else {
      parsed <- NA
    }

    attributes(parsed) <-
      append(attributes(parsed),
             list(
               query = query,
               spectrum = spectrum,
               minSimilarity = minSimilarity,
               precursorMZ = precursorMZ,
               precursorToleranceDa = precursorToleranceDa,
               precursorTolerancePPM = precursorTolerancePPM
             ))
    class(parsed) <- append('mona_spec_query', class(parsed))
    return(parsed)
  }

