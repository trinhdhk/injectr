#' Inject a function into a package namespace
#' @param x the function value, can be a file
#' @param name the name of the inject object
#' @param target <character(1)> the target namespace so that the function will operate on
#' @param infect whether to assign itself into that namespace. if FALSE, infect is similar to `environment(x) <- asNamespace(target)`.
#' After the infection, users can call x by `target:::name`. Very effective when you are modifying a method.
#' @param curable whether to keep a copy of the original function if x is overwriting an existing method
#' @return x, invisibly if infect=TRUE
#' @export
inject <- function(x, name = deparse(substitutex(x)),  target, infect = TRUE, curable = FALSE,  ...){
  UseMethod('inject')
}

#' @method inject character
#' @export
inject.character <- function(x, name = basename(x), target, infect = TRUE, curable = FALSE){
  name <- strsplit(name, ".", fixed=TRUE)[[1]][[1]]
  xx <- new.env()
  source(x, echo=FALSE, local = xx)
  for (xname in ls(envir=xx)){
    inject(xx[[xname]], xname, target, infect)
  }
}

#' @method inject function
#' @export
inject.function <- function(x, name = deparse(substitutex(x)), target, infect = TRUE, curable = FALSE){
  if (is.character(target)) target <- asNamespace(target)
  environment(x) <- target

  if (!infect) return(x)


  is_new_object <- !exists(name, target)
  if (!is_new_object){
    if (curable) attr(x, '.orig') <- get(name, envir=target)
    unlockBinding(name, target) # R is doubly careful with base package so this is to enforce for base
  }

  rlang::env_unlock(target)
  assign(name, x, envir=target)
  rlang::env_lock(target)
  invisible(x)
}
