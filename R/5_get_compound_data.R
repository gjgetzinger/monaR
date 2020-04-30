#' Extract chemical data from MONA queries
#'
#' @param df A tibble returned by a MoNA query
#' @param var The variable to return from the meta data
#'
#' @return a tibble containing extracted chemical data
#' @export
#'
mona_getChem <- function(df, var) {
  UseMethod('mona_getChem')
}

#' @describeIn mona_getChem Get values from meta data from ID query
#' @export
#' @examples
#' mona_getChem(example_id_query, var = 'inchi')
#' mona_getChem(example_id_query, var = 'inchiKey')
#' mona_getChem(example_id_query, var = 'external id')
#'
mona_getChem.mona_id_query <-
  function(df,
           var = c(
             'inchi',
             'inchiKey',
             'molFile',
             'names',
             'SMILES',
             'compound class',
             'molecular formula',
             'external id',
             'computed'
           )) {
    var <- match.arg(var, several.ok = F)

    if (var %in% c('inchi', 'inchiKey', 'molFile')) {
      d <- purrr::map(
        df$compound,
        .f = function(x) {
          xx <- dplyr::as_tibble(x)
          if (var %in% colnames(xx)) {
            dplyr::select_at(xx, var)
          } else {
            dplyr::transmute(xx, !!var := NA)
          }
        }
      ) %>%
        stats::setNames(nm = df$id) %>%
        dplyr::bind_rows(.id = 'id')
    }

    if (var %in% c('names')) {
      d <- purrr::map(
        df$compound,
        .f = function(x) {
          dplyr::as_tibble(x$names[[1]])
        }
      ) %>%
        stats::setNames(nm = df$id) %>%
        dplyr::bind_rows(.id = 'id')
    }

    if (var %in% c('SMILES',
                   'compound class',
                   'molecular formula')) {
      d <- purrr::map(df$compound, function(x) {
        dplyr::as_tibble(x$metaData[[1]]) %>%
          dplyr::filter_at(
            .vars = dplyr::vars(name),
            .vars_predicate = dplyr::any_vars(. == !!var)
          )
      }) %>%
        stats::setNames(nm = df$id) %>%
        dplyr::bind_rows(.id = 'id') %>%
        dplyr::group_by(id) %>%
        dplyr::filter(!is.na(value)) %>%
        dplyr::distinct(id, .keep_all = T) %>%
        tidyr::pivot_wider(id)
    }

    if (var %in% c('external id', 'computed')) {
      d <- purrr::map(df$compound, function(x) {
        dplyr::as_tibble(x$metaData[[1]]) %>%
          dplyr::filter_at(dplyr::vars(category), dplyr::any_vars(. == !!var))
      }) %>%
        stats::setNames(nm = df$id) %>%
        dplyr::bind_rows(.id = 'id') %>%
        dplyr::group_by(id) %>%
        tidyr::pivot_wider(id, name)
    }
    class(d) <- append('mona_meta', class(d))
    return(d)
  }

#' @describeIn mona_getChem Extract meta data from spectrum queries
#' @export
#'
mona_getChem.mona_spec_query <-  function(df,
                                          var = c(
                                            'inchi',
                                            'inchiKey',
                                            'molFile',
                                            'names',
                                            'SMILES',
                                            'compound class',
                                            'molecular formula',
                                            'external id',
                                            'computed'
                                          )) {
  var <- match.arg(var, several.ok = F)

  if (var %in% c('inchi', 'inchiKey', 'molFile')) {
    d <- purrr::map(
      df$hit$compound,
      .f = function(x) {
        xx <- dplyr::as_tibble(x)
        if (var %in% colnames(xx)) {
          dplyr::select_at(xx, var)
        } else {
          dplyr::transmute(xx, !!var := NA)
        }
      }
    ) %>%
      stats::setNames(nm = df$hit$id) %>%
      dplyr::bind_rows(.id = 'id')
  }

  if (var %in% c('names')) {
    d <- purrr::map(
      df$hit$compound,
      .f = function(x) {
        dplyr::as_tibble(x$names[[1]])
      }
    ) %>%
      stats::setNames(nm = df$hit$id) %>%
      dplyr::bind_rows(.id = 'id')
  }

  if (var %in% c('SMILES',
                 'compound class',
                 'molecular formula')) {
    d <- purrr::map(df$hit$compound, function(x) {
      dplyr::as_tibble(x$metaData[[1]]) %>%
        dplyr::filter_at(
          .vars = dplyr::vars(name),
          .vars_predicate = dplyr::any_vars(. == !!var)
        )
    }) %>%
      stats::setNames(nm = df$hit$id) %>%
      dplyr::bind_rows(.id = 'id') %>%
      dplyr::group_by(id) %>%
      dplyr::filter(!is.na(value)) %>%
      dplyr::distinct(id, .keep_all = T) %>%
      tidyr::pivot_wider(id)
  }

  if (var %in% c('external id', 'computed')) {
    d <- purrr::map(df$hit$compound, function(x) {
      dplyr::as_tibble(x$metaData[[1]]) %>%
        dplyr::filter_at(dplyr::vars(category), dplyr::any_vars(. == !!var))
    }) %>%
      stats::setNames(nm = df$hit$id) %>%
      dplyr::bind_rows(.id = 'id') %>%
      dplyr::group_by(id) %>%
      tidyr::pivot_wider(id, name)
  }
  class(d) <- append('mona_meta', class(d))
  return(d)
}
