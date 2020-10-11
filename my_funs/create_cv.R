# 手写 多重交叉验证，cross-validation

library(tibble)

create_folds <- function(data, v){
  #nrow of the df
  n <- nrow(data)
  #sample 
  folds <- sample(rep(1:v, length.out = n))
  idx <- seq_len(n)
  
  indices <- split(idx, folds)
  unname(indices)
  
  vfold_complement <- function (ind, n) 
  {
    list(train = setdiff(1:n, ind), test = ind)
  }
  
  indices <- lapply(indices, vfold_complement, n = n)
  
  data_list <- lapply(indices, function(x){
    tibble::tibble(train = list(Sonar[x$train,,drop = FALSE]),
                  test = list(Sonar[x$test,,drop=FALSE]))
    })
  
  result_df <- do.call("rbind",data_list)
  
  id <- paste0("Fold",gsub(" ","0",format(1:v)))
  
  result_df$id <- id
  
  return(result_df)

}

# data(Sonar, package = 'mlbench')
# create_folds(Sonar,5)

create_multi_folds <- function(data,v,repeats = 1){
  
  if (repeats == 1) {
    split_objs <- create_folds(data = data, v = v)
  }
  
  for (i in 1:repeats) {
    tmp <- create_folds(data = data, v = v)
    tmp$id2 <- tmp$id
    tmp$id <- paste0("Repeat",gsub(" ","0",format(1:repeats)))[i]
    split_objs <- if (i == 1) 
      tmp
    else rbind(split_objs, tmp)
  }
  
  return(split_objs)
}


# create_multi_folds(Sonar,10,repeats = 3)


