#' ---
#' title: "rlang tidy eval"
#' author: "Bruce Zhao"
#' date: "`r format(Sys.Date())`"
#' output: github_document
#' ---


library(ggplot2)
get_plot <- function(plot_type, df, ...){
  
  my_hist <- function(df, ...){
    ggplot(df) +
      geom_histogram(...)
  }
  
  my_box <- function(df, ...){
    ggplot(df) +
      geom_boxplot(...)
  }
  
  my_fun <- rlang::eval_tidy(rlang::sym(plot_type))
  # browser()
  my_fun(df, ...)

}

get_plot("my_hist", diamonds, aes(x = carat,fill = cut), binwidth = 0.01)
get_plot("my_box", df = mpg, aes(class, hwy))

