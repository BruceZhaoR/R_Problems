#' Fill NA with the last no-NA value
#'
#' @param data a data.frame or a vector
#' @param ... col names character vector or just bare name.
#'   see more: tidyselect::vars_select()
#' 
#' @return data.frame or a vector
#'
#' @examples
#' x <- c(1, NA, NA, 2, 3)
#' y <- c(NA, NA, 1, NA, 3)
#' xy <- data.frame(x,y)
#' fill_na(x)
#' fill_na(y)
#' fill_na(xy, x, y)
#' fill_na(xy, c("x","y"))
#' fill_na(xy, starts_with("x"))

fill_na <- function(data, ...) {
  UseMethod("fill_na")
}

#' @export
fill_na.default <- function(data, ...) {
  stopifnot(is.vector(data))
  a <- !is.na(data)
  data[which(a)[c(1, seq_along(which(a)))][cumsum(a) + 1]]
}

#' @export
fill_na.data.frame <- function(data, ...) {
  fill_cols <- unname(tidyselect::vars_select(names(data), ...))
  for (col in fill_cols) {
    data[[col]] <- fill_na(data[[col]])
  }
  data
}

#' @export
fill_na.grouped_df <- function(data, ...) {
  dplyr::do(data, fill_na(., ...)
}
