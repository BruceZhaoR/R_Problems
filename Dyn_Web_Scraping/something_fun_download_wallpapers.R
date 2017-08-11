
# 请先研究 get_imgs_from_flickr_1.R

# Use Selenium and Phantomjs scarp dynamic website in R 
# 循环抓取3个月的照片作为桌面背景图
# 默认一次抓取24张图片

# 默认已启动Selenium Server和Phantomjs----------------------------------------
remDr %>% newSession()
remDr %>% maximizeWindow()

# 搜索参数
root_url = "https://www.flickr.com"

# 查询标签，支持中英文 e.g.風景
query_tags = "landscape" # 必填

# 风格为景深
# styles = "depthoffield"

# 截止时间
now = Sys.Date()
end_date = as.double(as.POSIXct(now))

months = 1:3

for(i in months) {
  
  start_date <- end_date - 30*24*3600*(i)
  stop_date <- end_date - 30*24*3600*(i-1)
  
  print(sprintf("begin download from  %s to %s" ,
                as.POSIXct(start_date,origin = "1970-01-01"),
                as.POSIXct(stop_date,origin = "1970-01-01"))
        )
  
  elements <- list(
    tags = query_tags,
    media = "photos",
    orientation = "landscape,Cpanorama",
    dimension_search_mode = "min",
    height = "1080",
    width = "1920",
    color_codes = NULL,
    styles = NULL,
    min_taken_date = start_date,
    max_taken_date = stop_date,
    sort = "relevance",
    view_all = "0"
  )
  
  query_url <- modify_url(root_url, path = "search", query = elements)
  
  remDr %>% go(query_url)
  Sys.sleep(1) # 让phantomjs浏览器加载1s
  
  web_elem <- remDr %>% findElements("css", "a.overlay")
  img_url <- lapply(web_elem, getElementAttribute, attribute = "href")
  
  last_img_url <- unlist(lapply(img_url, function(x) {
      paste0(x, "sizes/k/") %>%
      read_html() %>%
      html_node(css = "#allsizes-photo img") %>%
      html_attr("src")
      }
    )
  )
  
  img_names <- unlist(lapply(last_img_url, function(x) {
    tail(strsplit(x, split = "/")[[1]], n = 1)
  }))
  
  if (!dir.exists("imgs")) dir.create("imgs")
  
  apply(data.frame(last_img_url, img_names), 1,
        FUN = function(x) {
          print(sprintf("downloading:%s", x[1]))
          download.file(
            url = x[1],
            destfile = sprintf("imgs/%s", x[2]),
            method = "curl")
        }
  )
}

# 下载完毕后删除session，关闭selenium server
remDr %>% deleteSession
# cmd中 `ctrl + c` 关闭 selenium server.
