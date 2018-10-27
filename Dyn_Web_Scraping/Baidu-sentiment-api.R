library(tidyverse)
library(httr)
library(jsonlite)

# https://ai.baidu.com/docs#/NLP-API/f6dc4440
get_sentiment <- function(str, type = c("tag","sentiment")) {
  tag_url <- "https://aip.baidubce.com/rpc/2.0/nlp/v2/comment_tag"
  sentiment_url <- "https://aip.baidubce.com/rpc/2.0/nlp/v1/sentiment_classify"
  access_token<- "24.ad5f62fb83630156c1ebd1285d6c05f7.2592000.1529983527.282335-11304466"
  url_tmp <- match.arg(type)
  
  if (url_tmp == "tag") {
    post_url <- modify_url(tag_url,
                           query = list(
                             # charset = "UTF-8",
                             access_token = access_token
                           ))
    to_raw <- function(str) {
      str <- stringi::stri_sub(str, 1, length = (10240 / 4))
      tmp_str <- paste0('{"text": \"',str,'\","type": 10}')
      stringi::stri_conv(utf8::as_utf8(tmp_str),"UTF-8","GBK",to_raw = TRUE)[[1]]
    }
  } else if (url_tmp == "sentiment") {
    post_url <- modify_url(sentiment_url,
                           query = list(
                             # charset = "UTF-8",
                             access_token = access_token
                           ))
    to_raw <- function(str) {
      str <- stringi::stri_sub(str, 1, length = (2048 / 4))
      tmp_str <- paste0('{"text": \"',str,'\"}')
      stringi::stri_conv(utf8::as_utf8(tmp_str),"UTF-8","GBK",to_raw = TRUE)[[1]]
    }
  } else {
    stop("incorrect type!")
  }
  
  if (nchar(str) < 3 | is.na(str)) {
    print("str lenth is less than 3 ")
    return(tibble())
  }
  raw_char <- to_raw(str)
  test_josn <- content(
    POST(post_url,
         body = raw_char,
         content_type_json()),
    encoding = "GBK",
    "text")
    
  ff <- function(x) {
    tmp <- try(fromJSON(x))
    if (class(tmp) == "try-error") {
      print("Json parse error")
      return(tibble())
    } else if (!is.null(tmp$error_code)) {
      print("api error")
      return(tibble())
    } else {
      print("done")
      return(as_tibble(tmp$items))
    }
  } 
    
    ff(test_josn)
}

test_str <- "个人觉得福克斯好，外观漂亮年轻，动力和操控性都不错"
get_sentiment(test_str,"sen")
test_str <- "我唉"
get_sentiment(test_str,"tag")
