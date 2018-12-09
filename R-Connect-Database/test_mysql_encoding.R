conn <- dbConnect(RMySQL::MySQL(),
                 db="xxx",
                 host="localhost",
                 port=3306,
                 username="xxx",
                 password="xxx")

# dbSendQuery(conn, "set character set gb18030") # 解决中文编码问题
dbSendQuery(conn, "set character set utf8") # 解决中文编码问题

dbSendQuery(conn, "set character_set_server = utf8")
dbSendQuery(conn, "set character_set_connection = utf8")
dbSendQuery(conn, "set character_set_client = gb18030")
dbSendQuery(conn, "set character_set_client = utf8")
dbSendQuery(conn, "set character_set_server = gb18030")

dbSendQuery(conn, "set NAMES gbk")

dbGetQuery(conn,"select * from city_info limit 6") # 测试
dbGetQuery(conn,"select * from zhanghui_test limit 6") # 测试

dbGetQuery(conn,"show variables like 'character_set_%'")

                                  gb18030              
latin1 <- str_conv(dbget_origin$bureau_user_name,"Latin-1")
          gb18030
stri_conv("李英波",from = "latin1",to="utf8")

latin1
> latin1
[1] "ÀîÓ¢²¨"
> Encoding(latin1)
[1] "UTF-8"

utf8_str <- str_conv("李英波","gb18030")

stri_conv(utf8_str,from = "latin1",to="utf8")


dbWriteTable(conn,"zhanghui_test",df,row.names = FALSE, append = TRUE)
dbWriteTable(conn,"zhanghui_test",df_utf8,row.names = FALSE, append = TRUE)


dbDisconnect(conn)
