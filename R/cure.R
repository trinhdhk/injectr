#' Recover an infected function inside a namespace
#' @param x character or a function object
#' @param ns where to search for x
#' @return the infected x
#' @export
cure <- function(x,...){
  UseMethod('cure')
}

#' @method cure character
#' @export
cure.character <- function(x, ns){
  if (is.character(ns)) ns <- asNamespace(ns)
  xfun <- get(x, ns)
  xorg <- attr(xfun, '.orig')
  if (is.null(xorg)) stop('This function is not curable! Set curable = TRUE when infecting it. You can still recover it by restarting R session.')
  xinf <- xfun
  assignInNamespace(x, xorg, ns=ns)
  invisible(xinf)
}

#' @method cure function
#' @export
cure.function <- function(x){
  xname <- deparse(substitute(x))
  # Remove namespace
  if (grepl('\\$|(\\:{2,3})|\\@', xname, perl=TRUE)){
    xname <- strsplit(xname, '\\$|(\\:{2,3})|\\@', perl=TRUE)[[1]]
    xns <- xname[[1]]
    xname <- xname[[2]]
  }

  cure(xname, xns)
}
