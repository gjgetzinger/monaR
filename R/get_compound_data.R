#' Extract chemical data from MONA queries
#'
#' @return A tibble with columns id, value
#' @export
#'
#' @examples
#' mona_getChem(example_id_query, var = 'inchi')
#' mona_getChem(example_id_query, var = 'inchiKey')
#' mona_getChem(example_id_query, var = 'external id')
#'
mona_getChem <- function(df, var) {
  UseMethod('mona_getChem')
}

#' @describeIn mona_getChem Get values from meta data from ID query
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
      d <- map(
        df$compound,
        .f = function(x) {
          xx <- as_tibble(x)
          if (var %in% colnames(xx)) {
            select_at(xx, var)
          } else {
            transmute(xx, !!var := NA)
          }
        }
      ) %>%
        setNames(nm = df$id) %>%
        bind_rows(.id = 'id')
    }

    if (var %in% c('names')) {
      d <- map(
        df$compound,
        .f = function(x) {
          as_tibble(x$names[[1]])
        }
      ) %>%
        setNames(nm = df$id) %>%
        bind_rows(.id = 'id')
    }

    if (var %in% c('SMILES',
                   'compound class',
                   'molecular formula')) {
     d <- map(df$compound, function(x) {
        as_tibble(x$metaData[[1]]) %>%
          filter_at(vars(name), any_vars(. == !!var))
      }) %>%
        setNames(nm = df$id) %>%
        bind_rows(.id = 'id') %>%
        group_by(id) %>%
        filter(!is.na(value)) %>%
        distinct(id, .keep_all = T) %>%
        pivot_wider(id)
    }

    if (var %in% c('external id', 'computed')) {
     d <- map(df$compound, function(x) {
        as_tibble(x$metaData[[1]]) %>%
          filter_at(vars(category), any_vars(. == !!var))
      }) %>%
        setNames(nm = df$id) %>%
        bind_rows(.id = 'id') %>%
        group_by(id) %>%
        pivot_wider(id, name)
    }
  return(d)
  }

#' @describeIn mona_getChem Extract meta data from spectrum queries
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
    d <- map(
      df$hit$compound,
      .f = function(x) {
        xx <- as_tibble(x)
        if (var %in% colnames(xx)) {
          select_at(xx, var)
        } else {
          transmute(xx, !!var := NA)
        }
      }
    ) %>%
      setNames(nm = df$hit$id) %>%
      bind_rows(.id = 'id')
  }

  if (var %in% c('names')) {
    d <- map(
      df$hit$compound,
      .f = function(x) {
        as_tibble(x$names[[1]])
      }
    ) %>%
      setNames(nm = df$hit$id) %>%
      bind_rows(.id = 'id')
  }

  if (var %in% c('SMILES',
                 'compound class',
                 'molecular formula')) {
    d <- map(df$hit$compound, function(x) {
      as_tibble(x$metaData[[1]]) %>%
        filter_at(vars(name), any_vars(. == !!var))
    }) %>%
      setNames(nm = df$hit$id) %>%
      bind_rows(.id = 'id') %>%
      group_by(id) %>%
      filter(!is.na(value)) %>%
      distinct(id, .keep_all = T) %>%
      pivot_wider(id)
  }

  if (var %in% c('external id', 'computed')) {
    d <- map(df$hit$compound, function(x) {
      as_tibble(x$metaData[[1]]) %>%
        filter_at(vars(category), any_vars(. == !!var))
    }) %>%
      setNames(nm = df$hit$id) %>%
      bind_rows(.id = 'id') %>%
      group_by(id) %>%
      pivot_wider(id, name)
  }
  return(d)
}
