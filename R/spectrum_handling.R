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
  stringr::str_split(spec, '[:space:]') %>%
    unlist %>%
    stringr::str_split(., ":") %>%
    do.call('rbind', .) %>%
    matrix(., ncol = 2, dimnames = list(c(), c("mz", "intensity"))) %>%
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


