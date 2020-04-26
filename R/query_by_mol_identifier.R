#' Query Mass Bank of North America API by molecule identifier
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
