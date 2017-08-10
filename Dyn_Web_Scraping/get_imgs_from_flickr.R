# Reference Resource
# https://johndharrison.github.io/seleniumPipes/vignettes/basicOperation.html

# load-packages -----------------------------------------------------------

library(seleniumPipes)
library(rvest)
library(httr)


# start-selenium ----------------------------------------------------------
# jar download here: http://selenium-release.storage.googleapis.com/index.html?path=3.3/
# in cmd
# java -jar path/to/selenium-server-standalone-3.3.0.jar

# use phantomjs webdriver ------------------------------------------------
# download here: http://phantomjs.org/download.html
# add  `E:\ProgramFiles\phantomjs-2.1.1-windows\bin` 加到环境变量（Environment Variable）

remDr <- remoteDr(browserName = "phantomjs")
remDr

# 最大化浏览器
remDr %>% maximizeWindow()

# 搜索参数
root_url = "https://www.flickr.com"

year = "2016"
month = "06"
day = "01"
start_date = as.double(as.POSIXct(paste(year,month,day,sep = "-")))
query_text = "sea"

elements <- list(
  text = query_text,
  color_codes = "5,6", #color_codes = "7" # 0-9,acde
  styles = "depthoffield", # "blackandwhite" "minimalism" "Cpattern"
  min_taken_date = start_date,
  view_all = "1"
)

# 获得最终的查询链接
query_url <- modify_url(root_url,path = "search", query = elements)

# 提取图片缩略图链接
web_elem <- remDr %>% go(query_url) %>%
  findElements("css", "a.overlay") 
  
img_url <- lapply(web_elem,getElementAttribute,attribute="href")

# 获得图片所有链接
last_img_url <- unlist(lapply(img_url, function(x) {
  paste0(x, "sizes/o/") %>%
    read_html() %>%
    html_node(css = "#allsizes-photo img") %>%
    html_attr("src")
}))
# 图片命名
img_names <- unlist(lapply(last_img_url, function(x) {
  tail(strsplit(x, split = "/")[[1]], n = 1)
}))

# 批量下载到 `./imgs`文件夹下
apply(data.frame(last_img_url,img_names), 1,
      FUN = function(x){
        download.file(url = x[1],
                      destfile = sprintf("imgs/%s",x[2]),
                      method = "curl")
      }
)

# 删除session
remDr %>% deleteSession
# remDr %>% newSession

# 命令行`ctrl+c` 关闭selenium jar
