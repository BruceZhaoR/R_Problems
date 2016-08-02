# R连接本地SQLite数据库

这里基本没有什么坑，唯一的坑就是数据读入到R中列名显示会乱码。其根本原因是R显示的时候没有自动转码，所以需要多一步操作。其根本原因就是Windows下中文的编码不是UTF-8的，所以有钱的赶紧换Mac吧。我用同事的MBP玩了一下MAC系统下面的R和RStudio，感觉挺不错。。。后悔买了台thinkpad。。

常见的用法github主页有介绍，我贴出地址<https://github.com/rstats-db/RSQLite/>，下面的主要是翻译与实际使用中的补充了。


## 简单说明

RSQLite这个包自带sqlite数据库的核心程序，可以建sqlite的数据库。通过`dbConnect`这个函数可以实现连接或者建一个本地的sqlite数据库。如果本地没有`my-db.sqlite`数据库，这个命令就新建这个数据库，如果有就直接连接上了。这里还提供系统临时数据库`mydb <- dbConnect(RSQLite::SQLite(), "")`(for an on-disk database), ` dbConnect(RSQLite::SQLite(), "file::memory")`内存中临时数据库。这里`:memory:`适合非Windows环境下用。

## 核心代码

```r
library(DBI)
library(RSQLite)

# 创建/连接数据库
con <- dbConnect(RSQLite::SQLite(), "my-db.sqlite")
on.exit(dbDisconnect(con)) #防止退出时忘记关闭连接
# unlink("my-db.sqlite") #删除数据库文件

# 查询、写入、导出
dbListTables(con)
dbWriteTable(con, "mtcars", mtcars)
dbRemoveTable(con,"company")
dbListFields(con, "mtcars")
dbReadTable(con, "mtcars")

# 高级查询
res <- dbSendQuery(con, "SELECT * FROM iris")

dbColumnInfo(res)
dbFetch(res,5)

#一定要记得clear，要不然会锁住数据库
dbClearResult(res)

# 更多

#建表语句
sqlCreateTable(ANSI(), "iris", iris[, 1:5])

#写入是更多的参数

dbWriteTable(con, "test", mtcars, overwrite =F, append=F, row.names=NA)

dbDisconnect(con)
```

## dplyr连接数据库

`src_sqlite`这种方式相对来说功能稍微少了一点，但是方便快捷,`create=T`还能建一个SQlite3 database。另外dplyr可以直接操作数据库，而不是将数据导入到内存里来再操作，其原理是将dplyr的语句转为sql直接到sqlite上面去执行，操作对象是`tbl_sqlit`这种格式。

```r
library(dplyr)
test <- readxl::read_excel("test.xlsx")

ds <- src_sqlite("D:\\sqlite-db\\test.db",create=FALSE)

db <- copy_to(ds,test,name="test") #写入数据库并且本地保留是tbl_sqlite格式
db <- tbl(ds,"test") #tbl_sqlite格式

# 读入到内存
tdb <- collect(db) #tbl_df/tibble格式
```

跟多例子和操作见教程<https://cran.r-project.org/web/packages/dplyr/vignettes/databases.html>

## 结语

忘了说，这里面唯一的坑就是如果你的表的列名为中文读入内存会出现乱码的情况，所以你需要多加一行命令: `names(tdb) <- iconv(names(tdb),from="UTF-8",to="UTF-8")`，这样就完美解决R连接SQLite数据库的问题了。

以上就是R连接SQLite数据的全部内容了，在实际操作中碰到问题请提交issue，我会及时解答。