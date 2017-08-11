
# 百度，模拟点击搜索

remDr %>% deleteSession()
remDr %>% newSession()
remDr %>% maximizeWindow()

root_url <- "https://baidu.com"
query_text <- "selenium + phantomhs 爬虫"


remDr %>% go(url = root_url)
remDr %>% getCurrentUrl()
remDr %>% getTitle()

# get search box
search_input <- remDr %>% findElement("id", 'kw')

# get the search button
search_btn <- remDr %>% findElement("id", "su")

# send text to query box
search_input %>% elementSendKeys(query_text)

# click the search button
search_btn %>% elementClick()

remDr %>% getTitle()
remDr %>% getCurrentUrl()

# clear the query box
# search_input %>% elementClear

# view result 第一页返回10个结果
result_elem <- remDr %>% findElements("css","h3.t > a")
result_text <- unlist(lapply(result_web_elem,getElementText))
result_link <- unlist(lapply(result_web_elem,
                             getElementAttribute,
                             attribute = "href"))

result_page_1 <- data.frame(result_title = result_text,
                            result_link  = result_link,
                            stringsAsFactors = FALSE)

# 2-10页按钮
nxt_page_btns <- remDr %>% findElements("css","#page > a") 

nxt_page_btns[[1]] %>% getElementAttribute("href")
  

nxt_page_btns[[1]] %>% elementClick()
remDr %>% getTitle()
remDr %>% getCurrentUrl()

result_elem_page2 <- remDr %>% findElements("css","h3.t > a")
result_text_page2 <- unlist(lapply(result_elem_page2,getElementText))
result_link_page2 <- unlist(lapply(result_elem_page2,
                             getElementAttribute,
                             attribute = "href"))

result_page_2 <- data.frame(result_title = result_text_page2,
                            result_link  = result_link_page2,
                            stringsAsFactors = FALSE)

# 网页快照
web_snap <- remDr %>% getPageSource()

write_html(web_snap,"web_snap.html")


# close browser
remDr %>% deleteSession
