#' Interchange between mass spectrum formats for MONA queries and results
#'
#' @param spec A spectrum as either a character string of space deliminated
#'   mz:intensity pairs or a dataframe with variables mz and intensity
#'
#' @return Provided a spectrum as a string returns a tibble and vice versa.
#' @export
#' @examples 
#' chr_spec <- mona_parseSpec(atrazine_ms2) # tibble to ":" sep character
#' tib_spec <- mona_parseSpec(chr_spec) # character to tibble
#' 
mona_parseSpec <- function(spec) {
  UseMethod("mona_parseSpec")
}

#' @describeIn mona_parseSpec Method for character strings
#' @export
mona_parseSpec.character <- function(spec) {
  a <- stringr::str_split(spec, "[:space:]") %>%
    unlist() %>%
    stringr::str_split(., ":") %>%
    do.call("rbind", .) %>%
    matrix(., ncol = 2, dimnames = list(c(), c("mz", "intensity"))) %>%
    dplyr::as_tibble() %>%
    dplyr::mutate_all(as.numeric)
  class(a) <- append(class(a), "mass_spectrum")
  return(a)
}

#' @describeIn mona_parseSpec Method for data frames
#' @export
mona_parseSpec.data.frame <- function(spec) {
  stopifnot("mz" %in% names(spec) &
    ("intensity" %in% names(spec) |
      "into" %in% names(spec)))
  dplyr::as_tibble(spec) %>%
    dplyr::rename_all(list(~ gsub("into", "intensity", .))) %>%
    dplyr::select(`mz`, `intensity`) %>%
    dplyr::mutate_all(as.numeric) %>%
    apply(.data,
      MARGIN = 1,
      FUN = paste0,
      collapse = ":"
    ) %>%
    paste0(.data, collapse = " ")
}

#' @describeIn mona_parseSpec Method for matrix
#' @export
mona_parseSpec.matrix <- function(spec) {
  stopifnot(ncol(spec) == 2)
  dplyr::tibble(spec) %>%
    apply(.data,
      MARGIN = 1,
      FUN = paste0,
      collapse = ":"
    ) %>%
    paste0(.data, collapse = " ")
}

#' @describeIn mona_parseSpec Method for Spectrum2 objects from MSnbase
#' @export
mona_parseSpec.Spectrum2 <- function(spec) {
  stopifnot(c("mz", "intensity") %in% names(attributes(spec)))
  dplyr::tibble(mz = spec@mz, intensity = spec@intensity) %>%
    apply(.data,
      MARGIN = 1,
      FUN = paste0,
      collapse = ":"
    ) %>%
    paste0(.data, collapse = " ")
}


#' Extract spectra from MONA query results
#'
#' @param df A tibble generated by a mona_query or mona_querySpec call
#' @param ann T/F should annotations be merged with the spectra
#'
#' @return A list of spectra named with the spectrum id
#' @export
#'
mona_getSpec <- function(df, ann = FALSE) {
  UseMethod("mona_getSpec")
}

#' @describeIn mona_getSpec Extract spectrum from ID query
#' @export
#' @examples
#' mona_getSpec(dplyr::slice(example_id_query, 1))
#' mona_getSpec(dplyr::slice(example_id_query, 150), ann = TRUE)
mona_getSpec.mona_id_query <- function(df, ann = FALSE) {
  spec <-
    stats::setNames(purrr::map(df$spectrum, mona_parseSpec), df$id)
  if (ann) {
    d <- stats::setNames(lapply(seq_along(spec), function(x) {
      if (is.null(df$annotations[[x]]) |
        length(df$annotations[[x]]) == 0) {
        spec[[x]]
      } else {
        dplyr::left_join(
          spec[[x]],
          dplyr::as_tibble(df$annotations[[x]]) %>%
            dplyr::mutate(mz = value) %>%
            dplyr::select(-value),
          by = "mz"
        )
      }
    }), names(spec))
  } else {
    d <- spec
  }
  class(d) <- append("mona_meta", class(d))
  return(d)
}

#' @describeIn mona_getSpec Extract spectra from spectrum query
#' @export
#' @examples
#' mona_getSpec(dplyr::slice(example_spec_query, 1))
#' mona_getSpec(
#'   dplyr::filter(example_spec_query, example_spec_query$hit$id == "SM841401")
#' )
#' mona_getSpec(
#'   dplyr::filter(example_spec_query, example_spec_query$score > 0.8)
#' )
#' mona_getSpec(dplyr::slice(example_spec_query, 1), ann = TRUE)
mona_getSpec.mona_spec_query <- function(df, ann = FALSE) {
  spec <-
    stats::setNames(purrr::map(df$hit$spectrum, mona_parseSpec), df$hit$id)
  if (ann) {
    d <- stats::setNames(lapply(seq_along(spec), function(x) {
      if (is.null(df$hit$annotations[[x]])) {
        spec[[x]]
      } else {
        dplyr::left_join(
          spec[[x]],
          dplyr::as_tibble(df$hit$annotations[[x]]) %>%
            dplyr::mutate(mz = value) %>%
            dplyr::select(-value),
          by = "mz"
        )
      }
    }), names(spec))
  } else {
    d <- spec
  }
  class(d) <- append("mona_meta", class(d))
  return(d)
}
