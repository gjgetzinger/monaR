#' Extract values from meta data records retrieved from MONA queries
#'
#' @param df Query result
#' @param var variable to select/filter by
#' @param value value to return
#'
#' @return a tibble
#'
#' @export
#'
mona_getMeta <- function(df, var, value) {
  UseMethod('mona_getMeta')
}

#' @describeIn mona_getMeta Get values from meta data from ID query
#' @export
#' @examples

#' mona_getMeta(example_id_query, var = 'category', value = 'mass spectrometry')
#' mona_getMeta(example_id_query, var = 'category', value = 'focused ion')
#' mona_getMeta(example_id_query, var = 'category', value = 'chromatography')
#' mona_getMeta(example_id_query, var = 'name', value = 'ionization')
#' mona_getMeta(example_id_query, var = 'name', value = 'ms level')
#' mona_getMeta(example_id_query, var = 'name', value = 'mass error')
#'
mona_getMeta.mona_id_query <-
  function(df,
           var = c('category', 'name'),
           value = c(
             "mass spectrometry",
             "chromatography",
             "focused ion",
             "accession",
             "date",
             "author",
             "license",
             "copyright",
             "publication",
             "exact mass",
             "instrument",
             "instrument type",
             "ms level",
             "ionization",
             "column",
             "column temperature",
             "injection temperature",
             "retention time",
             "precursor m/z",
             "precursor type",
             "mass accuracy",
             "mass error"
           )) {
    var <- match.arg(var, several.ok = F)
    if (var == 'category') {
      value <-
        match.arg(
          value,
          choices = c('mass spectrometry', 'focused ion', 'chromatography'),
          several.ok = F
        )
    } else {
      value <- match.arg(value, several.ok = F)
    }

    map(df$metaData, function(x) {
      as_tibble(x) %>%
        filter_at(vars(!!var), any_vars(. == !!value))
    }) %>%
      setNames(nm = df$id) %>%
      bind_rows(.id = 'id') %>%
      unite("name", name, unit, na.rm = T) %>%
      select(id, name, value) %>%
      aggregate(value ~ id + name, ., paste0, collapse = ',') %>%
      as_tibble() %>%
      pivot_wider(id, name) %>%
      mutate_at(.vars = vars(
        starts_with("mass"),
        contains('exact mass'),
        contains('resolution'),
        contains('m/z')
      ),
      as.numeric) %>%
      group_by(id)
  }

#' @describeIn mona_getMeta Extract meta data from spectrum query
#' @export
#' @examples
#' mona_getMeta(example_spec_query, var = 'category', value = 'mass spectrometry')
#' mona_getMeta(example_spec_query, var = 'category', value = 'chromatography')
#' mona_getMeta(example_spec_query, var = 'name', value = 'mass error')
#'
mona_getMeta.mona_spec_query <-
  function(df,
           var = c('category',
                   'name',
                   'submitter',
                   'splash',
                   'submitter',
                   'library',
                   'score'),
           value = c(
             "mass spectrometry",
             "chromatography",
             "focused ion",
             "accession",
             "date",
             "author",
             "license",
             "copyright",
             "publication",
             "exact mass",
             "instrument",
             "instrument type",
             "ms level",
             "ionization",
             "column",
             "column temperature",
             "injection temperature",
             "retention time",
             "precursor m/z",
             "precursor type",
             "mass accuracy",
             "mass error"
           )) {
    var <- match.arg(var, several.ok = F)
    if (var == 'category') {
      value <-
        match.arg(
          value,
          choices = c('mass spectrometry', 'focused ion', 'chromatography'),
          several.ok = F
        )
    } else {
      value <- match.arg(value, several.ok = F)
    }

    if (var %in% c('submitter', 'splash', 'submitter', 'library', 'score')) {
      bind_cols(enframe(df$hit$id, name = NULL, value = 'id'),
                as_tibble(df$hit[, var])) %>%
        group_by(id)
    } else {
      map(df$hit$metaData, function(x) {
        as_tibble(x) %>%
          filter_at(vars(!!var), any_vars(. == !!value))
      }) %>%
        setNames(nm = df$hit$id) %>%
        bind_rows(.id = 'id') %>%
        unite("name", name, unit, na.rm = T) %>%
        select(id, name, value) %>%
        aggregate(value ~ id + name, ., paste0, collapse = ',') %>%
        as_tibble() %>%
        pivot_wider(id, name) %>%
        mutate_at(.vars = vars(
          starts_with("mass"),
          contains('exact mass'),
          contains('resolution'),
          contains('m/z')
        ),
        as.numeric) %>%
        group_by(id)
    }
  }
