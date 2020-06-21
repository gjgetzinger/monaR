#' print method for id query
#' 
#' @param x 	an object used to select a method.
#' @param ...  further arguments passed to or from other methods.
#' 
#' @export
#' @return Prints tibble info from an ID query
#' @examples
#' print(example_id_query)
print.mona_id_query <- function(x, ...) {
  att <- attributes(x)
  cat("MoNA query by structure/molecule identifier:\n")
  invisible(purrr::map(names(formals(mona_query)), function(a) {
    if (a %in% names(att)) {
      cat(a, ":", att[[a]], "\n")
    }
  }))
  cat("Results:\n")
  dplyr::glimpse(x)
  invisible(x)
}

#' print method for spec query
#' 
#' @param x 	an object used to select a method.
#' @param ...  further arguments passed to or from other methods.
#' 
#' @export
#' @return Prints tibble info from a spectrum query 
#' @examples
#' print(example_spec_query)
print.mona_spec_query <- function(x, ...) {
  att <- attributes(x)
  att <- att[names(att) != "query"]
  cat("MoNA query by mass spectrum:\n")
  invisible(purrr::map(names(formals(mona_querySpec)), function(a) {
    if (a %in% names(att)) {
      if (a == "spectrum") {
        cat(a, "\n")
        dplyr::glimpse(mona_parseSpec(att[[a]]))
      } else {
        cat(a, ":", att[[a]], "\n")
      }
    }
  }))
  cat("Results:\n")
  dplyr::glimpse(x)
  invisible(x)
}

#' print method for meta data
#'
#' @param x 	an object used to select a method.
#' @param ...  further arguments passed to or from other methods.
#'
#' @export
#' @return Prints tibble info from a meta data query
#' @examples 
#' print(mona_getMeta(example_id_query, 'category', 'mass spectrometry'))
print.mona_meta <- function(x, ...) {
  dplyr::glimpse(x)
  invisible(x)
}
