## usethis namespace: start
#' @importFrom tibble tibble
## usethis namespace: end
NULL

#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @return nothing 
#' @examples 
#' 1:10 %>% print
NULL


#' @importFrom rlang .data
NULL

#' @importFrom rlang :=
NULL

#' Example mass spectrum for testing.
#'
#' An experimental mass spectrum for the compound Atrazine.
#'
#' @format A tibble with 15 rows and 2 variables:
#' \describe{
#'   \item{mz}{mass to charge values}
#'   \item{intensity}{absolute intensity}
#'   ...
#' }
#' @source splash10-00xr-1960000000-6cd3e48811e8b25a7c65
#'
"atrazine_ms2"

#' Example mona_query results
#'
#' An example result generated from mona_query('atrazine', 'name')
#'
#' @format tibble with 181 rows and 13 variables
#'
"example_id_query"

#' Example mona_querySpec results
#'
#' An example result generated from
#' mona_querySpec(
#'    spectrum = atrazine_ms2,
#'    minSimilarity = 800,
#'    precursorMZ = 216,
#'    precursorToleranceDa =1)
#'
#' @format tibble with 15 rows and 2 variables
"example_spec_query"




utils::globalVariables(
    c("mz", "intensity", ".", "name", "value", "category", "unit", "id"))
