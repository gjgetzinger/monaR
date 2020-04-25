#' Query Mass Bank of North America API
#'
#' Submit a query to MONA API (https://mona.fiehnlab.ucdavis.edu) by text
#' string, molecular formula or (partial) InChI Key.
#'
#' @param query The query string
#' @param from The query type (text, name, InChIKey or molform)
#' @param mass_tol_Da Mass tolerance in Daltons for searching my molecular
#'   weight.
#' @param ionization The ionization mode (positive, negative, both)
#' @param ms_level Which order of MS should be searched (all, MS1, MS2, MS3,
#'   MS4).
#' @param source_introduction Which instrument platforms should be considered
#'   (all, LC-MS, GC-MS, CE-MS)
#'
#' @return A tibble containing the search results or NA if no matches.
#' @export
#'
mona_query <-
  function(query,
           from = c('text', 'name', 'InChIKey', 'molform', 'mass'),
           mass_tol_Da = 0.1,
           ionization = c('positive', 'negative'),
           ms_level = c("MS1", "MS2", "MS3", "MS4"),
           source_introduction = c("LC-MS", "GC-MS", "CE-MS")
           ) {
    # from <- match.arg(from, c('text', 'name', 'InChIKey', 'molform', 'mass'), several.ok = F)
    # ionization <- match.arg(ionization,c('positive', 'negative'), several.ok = T)
    # ms_level <- match.arg(ms_level,c("MS1", "MS2", "MS3", "MS4"), several.ok = T)
    # source_introduction <- match.arg(source_introduction, c("LC-MS", "GC-MS", "CE-MS"), several.ok = T)
    from <- match.arg(from, several.ok = F)
    ionization <- match.arg(ionization, several.ok = T)
    ms_level <- match.arg(ms_level, several.ok = T)
    source_introduction <- match.arg(source_introduction, several.ok = T)

    stopifnot(c(length(query) == 1, length(from) == 1))

    if (from == 'InChIKey') {
      stopifnot(nchar(query) %in% c(14, 27))
      if (nchar(query) == 14) {
        from <- 'partial_inchikey'
      }
    }

    if (from == 'mass') {
      mass_range <- query + c(-1, 1) * mass_tol_Da
    }

    base_url <-
      'https://mona.fiehnlab.ucdavis.edu/rest/spectra/search'

    if (tolower(from) %in% c('mass', 'inchikey', 'partial_inchikey', 'molform')) {
      base_url <- paste0(base_url, "?query=compound.metaData=q='name==")
    }

    fmt <- switch(
      tolower(from),
      text = '?text=%s',
      name = "?query=compound.names=q='name=like=\"%s\"'",
      mass = "\"total exact mass\" and value >= %f and value <= %f'",
      inchikey = "\"InChIKey\" and value==\"%s\"'",
      partial_inchikey = "\"InChIKey\" and value=match=\".*%s.*\"'",
      molform = "\"molecular formula\" and value=match=\".*%s.*\"'"
    )

    url <-
      paste0(base_url, ifelse(
        from == 'mass',
        sprintf(fmt, mass_range[1], mass_range[2]),
        sprintf(fmt, query)
      ))

    tags <- list()
    # add ionization to query
    tags['ionization'] <- paste0('(', paste(
      sapply(ionization, sprintf, fmt = "metaData=q='name==\"ionization mode\" and value==\"%s\"'"),
      collapse = ' or '
    ), ')')

    # add ms level
    tags['ms_level'] <- paste0('(', paste(
      sapply(ms_level, sprintf, fmt = "metaData=q='name==\"ms level\" and value==\"%s\"'"),
      collapse = ' or '
    ), ')')

    # add source introduction
    tags['source_introduction'] <- paste0('(', paste(
      sapply(source_introduction, sprintf, fmt = "tags.text==\"%s\""),
      collapse = ' or '
    ), ')')

    if (length(tags) > 0) {
      url <- paste(c(url, tags), collapse = ' and ')
    }

    url <- utils::URLencode(url)

    resp <- httr::GET(url = url, httr::timeout(getOption('timeout')))

    httr::stop_for_status(resp)

    if (resp$status_code == 200) {
      cont <- httr::content(resp, "text")
      parsed <- dplyr::as_tibble(jsonlite::fromJSON(cont))
    } else {
      parsed <- NA
    }
    attributes(parsed) <-
      append(
        attributes(parsed),
        list(
          query = query,
          from = from,
          tags = tags,
          url = utils::URLdecode(url),
          resp = resp
        )
      )
    return(parsed)
  }

#' Query MONA by a mass spectrum
#'
#' @param spectrum A spectrum as either a dataframe with variables mz,intensity or a space deliminated stinrg of mz:inensity pairs.
#' @param minSimilarity Minimum spectral similarity for searching
#' @param precursorMZ The precursor ion m/z
#' @param precursorToleranceDa Search tolerance in dalton
#' @param precursorTolerancePPM Search tolerance in ppm
#'
#' @return A tibble containing the search results of NA if an error occured.
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
               url = utils::URLdecode(url),
               resp = resp
             ))
    return(parsed)
  }

#' Interchange between mass spectrum formats for MONA queries and results
#'
#' @param spec A spectrum as either a character string of space deliminated
#'   mz:intensity pairs or a dataframe with variables mz and intensity
#'
#' @return Provided a spectrum as a string returns a tibble and vice versa.
#' @export
#'
mona_parseSpec <- function(spec) {
  UseMethod("mona_parseSpec")
}

#' @describeIn mona_parseSpec Method for character strings
mona_parseSpec.character <- function(spec) {
  spec %>%
    stringr::str_split(.data, '[:space:]') %>%
    unlist %>%
    stringr::str_split(.data, ":") %>%
    do.call('rbind', .data) %>%
    matrix(.data, ncol = 2, dimnames = list(c(), c("mz", "intensity"))) %>%
    dplyr::as_tibble() %>%
    dplyr::mutate_all(as.numeric)
}

#' @describeIn mona_parseSpec Method for data frames
mona_parseSpec.data.frame <- function(spec) {
  stopifnot('mz' %in% names(spec) &
              ('intensity' %in% names(spec) | 'into' %in% names(spec)))
  dplyr::as_tibble(spec) %>%
    dplyr::rename_all(list( ~ gsub('into', 'intensity', .))) %>%
    dplyr::select(`mz`, `intensity`) %>%
    dplyr::mutate_all(as.numeric) %>%
    apply(.data,
          MARGIN = 1,
          FUN = paste0,
          collapse = ":") %>%
    paste0(.data, collapse = ' ')
}

#' @describeIn mona_parseSpec Method for matrix
mona_parseSpec.matrix <- function(spec) {
  stopifnot(ncol(spec) == 2)
  dplyr::tibble(spec) %>%
    apply(.data,
          MARGIN = 1,
          FUN = paste0,
          collapse = ":") %>%
    paste0(.data, collapse = ' ')
}

#' @describeIn mona_parseSpec Method for Spectrum2 objects from MSnbase
mona_parseSpec.Spectrum2 <- function(spec) {
  stopifnot(c("mz", "intensity") %in% names(attributes(spec)))
  dplyr::tibble(mz = spec@mz, intensity = spec@intensity) %>%
    apply(.data,
          MARGIN = 1,
          FUN = paste0,
          collapse = ":") %>%
    paste0(.data, collapse = ' ')
}

