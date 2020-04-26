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

#' Data pronouns for tidy evaluation
#'
#' @name .data
#' @rdname .data
#' @keywords internal
#' @export
#' @importFrom rlang .data
#'
NULL


utils::globalVariables(c("mz", "intensity", "."))
