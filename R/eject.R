#' Eject function source to a file for manipulation
#' @description
#' Simple function that eject function from a namespace to a file, calling dump
#' @param x a string of function name or an object of class function
#' @param from where to search for x
#' @param to file path to dump x
#' @param ... ignore
#' @return invisible the name of x
#'
#' @export
eject <-
  function(x, from = parent.frame(), to,...){
    UseMethod('eject')
  }

#' @method eject default
#' @export
eject.default <-
  function(x, ...){
    cl <- paste0(class(x), collapse=', ')
    stop('No method implemented for object of class ', cl)
  }

#' @method eject function
#' @export
eject.function <-
  function(x, to, ...){
    xname <- deparse(substitute(x))
    # Remove namespace
    if (grepl('\\$|(\\:{2,3})|\\@', xname, perl=TRUE)){
      xname <- strsplit(xname, '\\$|(\\:{2,3})|\\@', perl=TRUE)[[1]]
      xns <- xname[[1]]
      xname <- xname[[2]]
    }

    # p <- capture.output(print(x))
    # p <- p[!grepl('^\\<(bytecode|environment)\\:', p, perl=TRUE)]
    # p <- c(paste0(xname, ' <- '), p)
    # writeLines(p, con=to)
    # suppressMessages(formatR::tidy_file(to, output=FALSE))
    eject(xname, to, envir=xns)
  }

#' @method eject character
#' @export
eject.character <-
  function(x, from, to, ...){
    dump(x, to, envir=from)
    invisible(x)
  }
