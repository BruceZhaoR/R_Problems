## R链接MySQL数据库补充

### 编码问题

编码与在何种操作系统上使用R有关系，

- 如果是在Windows系统是使用R，那么需要 `dbSendQuery(conn, "set character set gb18030")`;

- 如果在Linux系统中，默认的编码是UTF-8，那么需要`dbSendQuery(conn, "set character set utf8")`。

然后用`dbGetQuery(conn,"select * from test")`就能正常显示中文字符了。

**注意：** 如果是使用dplyr包的话，从数据库读出来的字符必须转为UTF-8编码的，所以还需要进行下面的转换

```R
test_enc <- dbGetQuery(conn,"select * test")
Enconding(test_enc$test)

# 一次性全部变成UTF-8编码
# linux是从UTF-8变成UTF-8
test1 <- test_enc %>% mutate_all(funs(str_conv(.,encoding = "UTF-8")))

# Windows是从gb18030变成UTF-8
# test1 <- test_enc %>% mutate_all(funs(str_conv(.,encoding = "gb18030")))

Encoding(test1$test)
```
### 插入数据库的优化处理

小赵发现用默认的`dbWriteTables`函数会将字符串类型设为`text`，这可能会拖慢后续的数据库查询操作。通过研究`dplyr::copy_to`函数，发现其对数据库的类型进行了优化，所有就借鉴过来了。详情请见：<https://github.com/tidyverse/dbplyr/blob/master/R/db-mysql.r#L35-L59> 

```R
# 借鉴的函数，用于优化字段类型
create_data_type <- function(fields) {
  char_type <- function(x) {
    n <- 2 * max(nchar(as.character(x), "chars"), 0L, na.rm = TRUE)
    if (n <= 65535) {
      paste0("varchar(", n, ")")
    } else {
      "mediumtext"
    }
  }
  
  data_type <- function(x) {
    switch(
      class(x)[1],
      logical =   "boolean",
      integer =   "integer",
      numeric =   "double",
      factor =    char_type(x),
      character = char_type(x),
      Date =      "date",
      POSIXct =   "datetime",
      stop("Unknown class ", paste(class(x), collapse = "/"), call. = FALSE)
    )
  }
  vapply(fields, data_type, character(1))
}

# 在数据库中设计一个表
dbExecute(conn,
          sqlCreateTable(
            conn,
            "my-table",
            creat_data_type(test_df),
            row.names = FALSE
          ))

# 将test_df写入数据库中
dbWriteTable(conn,"my-table",test_df,row.names=FALSE,append = TRUE)

```

`dplyr`连接数据库本质是将数据写到本地csv，然后通过sql语句上传到数据。加上`character set utf-8`或许能够解决中文乱码问题。

dplyr::build_sql()

load data local infile 'path/to/file_name.csv'  into table my_table character set utf8;

dplyr::build_sql()
<https://github.com/tidyverse/dbplyr/blob/master/R/db-mysql.r#L93>

