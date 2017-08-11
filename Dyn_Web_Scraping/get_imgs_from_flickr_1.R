# 运行要求：下载selenium和phantomjs

# use phantomjs webdriver ------------------------------------------------
# download here: http://phantomjs.org/download.html
# add  `E:\ProgramFiles\phantomjs-2.1.1-windows\bin` 加到环境变量（Environment Variable）
# 在cmd中测试： `phantomjs -v` 返回版本信息2.1.1则配置成功

# start-selenium ----------------------------------------------------------
# jar download here: http://selenium-release.storage.googleapis.com/index.html?path=3.3/
# 在cmd中 启动 selenium server：
# java -jar path/to/selenium-server-standalone-3.3.0.jar

# Reference Resource
# https://johndharrison.github.io/seleniumPipes/vignettes/basicOperation.html

# 打开Rstudio，设定一下工作路径

# load-packages -----------------------------------------------------------

library(seleniumPipes)
library(rvest)

remDr <- remoteDr(browserName = "phantomjs")
remDr

# 最大化浏览器
remDr %>% maximizeWindow()

# 搜索的网址
root_url = "https://www.flickr.com"

# 搜索的图片内容
query_text = "sea" #必填

# 以下选填
# 色系, 可多选用英文逗号分隔
# color_codes = "6,7" # 0-9,acde
# style，可多选
# styles = "depthoffield,minimalism" # "blackandwhite" "minimalism" "Cpattern"
# 更多参数去网站看看，然后在这边设置

# 设定抓取前一个月的照片，
now = Sys.Date()
end_date = as.double(as.POSIXct(now))

elements <- list(
    text = query_text,
    color_codes = NULL,
    styles = NULL,
    min_taken_date = end_date - 30*24*3600*(2),
    max_taken_date = end_date - 30*24*3600*(2-1),
    dimension_search_mode = "min",
    height = "1024",
    width = "1024",
    view_all = NULL
  )

# 获得最终的查询链接
query_url <- modify_url(root_url,path = "search", query = elements)
query_url
# 抓取前先验证一下链接有没有问题

# 提取图片缩略图链接
web_elem <- remDr %>% go(query_url) %>%
  findElements("css", "a.overlay")   
img_url <- lapply(web_elem,getElementAttribute,attribute="href")

# 获得图片所有链接，默认下载原图片，调整`/sizes/l/`或者`sizes/m`
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

if (!dir.exists("imgs")) dir.create("imgs")

# 批量下载到 `./imgs`文件夹下
apply(data.frame(last_img_url,img_names), 1,
      FUN = function(x){
        print(sprintf("downloading:%s", x[1]))
        download.file(url = x[1],
                      destfile = sprintf("imgs/%s",x[2]),
                      method = "curl")
      }
)

# 删除session
remDr %>% deleteSession
# remDr %>% newSession

# cmd里面命令行`ctrl+c` 关闭selenium jar
