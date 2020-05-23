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


types = list(
  hist = function(df, ...){
    ggplot(df) +
      geom_histogram(...)
  },
  box = function(df, ...){
    ggplot(df) +
      geom_boxplot(...)
  }
)

get_plot = function(plot_type, df, ...){
  my_plot = types[[plot_type]]
  if (is.function(my_plot)) {
    my_plot(df, ...)
  } else {
    print("Wrong plot_type")
  }
}

get_plot("hist", diamonds, aes(x = carat,fill = cut), binwidth = 0.1)
get_plot("box", df = mpg, aes(class, hwy))


