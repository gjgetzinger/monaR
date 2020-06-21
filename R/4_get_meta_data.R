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
  UseMethod("mona_getMeta")
}

#' @describeIn mona_getMeta Get values from meta data from ID query
#' @export
#' @examples
#'
#' mona_getMeta(example_id_query, var = "category", value = "mass spectrometry")
#' mona_getMeta(example_id_query, var = "category", value = "focused ion")
#' mona_getMeta(example_id_query, var = "category", value = "chromatography")
#' mona_getMeta(example_id_query, var = "name", value = "ionization")
#' mona_getMeta(example_id_query, var = "name", value = "ms level")
#' mona_getMeta(example_id_query, var = "name", value = "mass error")
mona_getMeta.mona_id_query <-
  function(df,
           var = c("category", "name"),
           value = c(
             "mass spectrometry", "chromatography", 
             "focused ion", "accession", "date", "author", 
             "license","copyright", "publication","exact mass",
             "instrument","instrument type",
             "ms level","ionization","column","column temperature",
             "injection temperature","retention time", "precursor m/z",
             "precursor type", "mass accuracy", "mass error")
           ) {
    var <- match.arg(var, several.ok = FALSE)
    if (var == "category") {
      value <- match.arg(value, 
                         choices = c(
                           "mass spectrometry", "focused ion", "chromatography"
                           ),
                         several.ok = FALSE)
    } else {
      value <- match.arg(value, several.ok = FALSE)
    }

    d <- purrr::map(df$metaData, function(x) {
      dplyr::as_tibble(x) %>%
        dplyr::filter_at( .vars = dplyr::vars(!!var), 
                          .vars_predicate = dplyr::any_vars(. == !!value))
      }) %>%
      stats::setNames(nm = df$id) %>%
      dplyr::bind_rows(.id = "id") %>%
      tidyr::unite("name", name, unit, na.rm = TRUE) %>%
      dplyr::select(id, name, value) %>%
      stats::aggregate(value ~ id + name, ., paste0, collapse = ",") %>%
      dplyr::as_tibble() %>%
      tidyr::pivot_wider(id, name) %>%
      dplyr::mutate_at(
        .vars = dplyr::vars(dplyr::starts_with("mass"), 
                            dplyr::contains("exact mass"), 
                            dplyr::contains("resolution"), 
                            dplyr::contains("m/z")), as.numeric
        ) %>%
      dplyr::group_by(id)
    class(d) <- append("mona_meta", class(d))
    return(d)
  }

#' @describeIn mona_getMeta Extract meta data from spectrum query
#' @export
#' @examples
#' mona_getMeta(example_spec_query, var = "category", value = "mass
#' spectrometry") 
#' mona_getMeta(example_spec_query, var = "category", value =
#' "chromatography") 
#' mona_getMeta(example_spec_query, var = "name", value =
#' "mass error")
mona_getMeta.mona_spec_query <-
  function(df,
           var = c("category", "name","submitter","splash", "submitter", 
                   "library", "score"),
           value = c(
             "mass spectrometry", "chromatography", "focused ion", "accession", 
             "date", "author", "license", "copyright", "publication",
             "exact mass", "instrument", "instrument type", "ms level",
             "ionization", "column", "column temperature",
             "injection temperature", "retention time", "precursor m/z",
             "precursor type", "mass accuracy", "mass error")
           ) {
    var <- match.arg(var, several.ok = FALSE)
    if (var == "category") {
      value <- match.arg(value,
          choices = c("mass spectrometry", "focused ion", "chromatography"),
          several.ok = FALSE)
    } else {
      value <- match.arg(value, several.ok = FALSE)
    }
    if (var %in% c("submitter", "splash", "submitter", "library", "score")) {
      d <- dplyr::bind_cols(
          tibble::enframe(df$hit$id, name = NULL, value = "id"),
          dplyr::as_tibble(df$hit[, var])
        ) %>% dplyr::group_by(id)
    } else {
      d <- purrr::map(df$hit$metaData, function(x) {
        dplyr::as_tibble(x) %>%
          dplyr::filter_at(
            .vars = dplyr::vars(!!var),
            .vars_predicate = dplyr::any_vars(. == !!value)
          )
      }) %>%
        stats::setNames(nm = df$hit$id) %>% dplyr::bind_rows(.id = "id") %>%
        tidyr::unite("name", name, unit, na.rm = TRUE) %>%
        dplyr::select(id, name, value) %>%
        stats::aggregate(value ~ id + name, ., paste0, collapse = ",") %>%
        dplyr::as_tibble() %>% tidyr::pivot_wider(id, name) %>%
        dplyr::mutate_at(
          .vars = dplyr::vars(dplyr::starts_with("mass"),
                              dplyr::contains("exact mass"),
                              dplyr::contains("resolution"),
                              dplyr::contains("m/z")), as.numeric
        ) %>%
        dplyr::group_by(id)
    }
    class(d) <- append("mona_meta", class(d))
    return(d)
  }
