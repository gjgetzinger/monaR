## usethis namespace: start
#' @importFrom tibble tibble
## usethis namespace: end
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
#' @format tibble with 178 rows and 13 variables
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
#' @format tibble with 9 rows and 2 variables
"example_spec_query"

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
NULL


#' @importFrom rlang .data
#' @importFrom stats aggregate
#' @importFrom stats setNames
#' @importFrom rlang :=
#' @importFrom dplyr id
#' @importFrom dplyr summarize
#' @importFrom dplyr count
#' @importFrom dplyr desc
#' @importFrom dplyr arrange
#' @importFrom dplyr mutate
#' @importFrom dplyr rename
#' @importFrom dplyr summarise
#' @importFrom purrr compact
#' @importFrom purrr map
#' @importFrom tidyr pivot_wider
#' @importFrom tidyr unite
#' @importFrom dplyr as_tibble
#' @importFrom dplyr left_join
#' @importFrom dplyr select
#' @importFrom dplyr transmute
#' @importFrom dplyr select_at
#' @importFrom dplyr bind_rows
#' @importFrom dplyr filter_at
#' @importFrom dplyr vars
#' @importFrom dplyr any_vars
#' @importFrom dplyr group_by
#' @importFrom dplyr filter
#' @importFrom dplyr distinct
#' @importFrom dplyr starts_with
#' @importFrom dplyr contains
#' @importFrom tibble enframe
#' @importFrom dplyr bind_cols
#' @importFrom dplyr mutate_at
#'
#'

utils::globalVariables(c("mz", "intensity", ".", "name", "value", "category", "unit"))
