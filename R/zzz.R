#' Pipe operator
#'
#' See `magrittr::[\%>\%][magrittr::pipe]` for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @return The result of calling `rhs(lhs)`.
NULL

#' @importFrom graphics hist
#' @importFrom stats sd
#' @importFrom stats var
#' @importFrom stats na.omit
#' @importFrom stats t.test
#' @importFrom stats wilcox.test
#' @importFrom stats runif
#' @importFrom stats rnorm
#' @importFrom utils write.table
#' @importFrom graphics axis
#' @importFrom graphics points
#' @importFrom graphics segments
#' @importFrom graphics layout
#' @importFrom grDevices hcl.colors

# globalVariables -----
globalVariables(c(".", "window"))

# progress section -----
.onLoad <- function(libname, pkgname) {
  terra::terraOptions(progress=0)
}
