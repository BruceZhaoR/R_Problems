library(httr)
library(rvest)

# http://stockdata.stock.hexun.com/2008/lr.aspx?stockid=000001&accountdate=2012.12.31


get_hexun <- function(stock_id, account_data){

  agent <- user_agent("Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.97 Safari/537.36 Vivaldi/1.94.1008.40")
  accept <- accept("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
  charset <- add_headers("Accept-Language"= "zh-CN,zh;q=0.9",
                         "Accept-Charset"="gb2312,utf-8;q=0.9,*;q=0.3")
  
  my_cookies <- set_cookies("ASP.NET_SessionId" = "ub25dckdo3fq0ltuvs0x4tmg",
                            "__jsluid"="d8aaf000242a0ec8de6fcbcbb5982d99")
  
  test_url <- modify_url("http://stockdata.stock.hexun.com", path = "2008/lr.aspx",
                         query = list(stockid = stock_id,
                                      accountdate= account_data)
  )
  
GET(test_url, agent, accept, charset, my_cookies) %>% 
  read_html(encoding = "gb2312") %>%
  html_node(css = "#zaiyaocontent > table") %>%
  html_table()
}

ids <- c("000001","000002")
accountdate= "2012.12.31"

result <- list()
for(i in seq_along(ids)) {
  result[[i]] <- get_hexun(ids[[i]], accountdate)
  #休眠1秒，免得搞崩了别人网站
  Sys.sleep(1)
}

result



