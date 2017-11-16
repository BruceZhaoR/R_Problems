## MySQL基本命令

### 连接服务器

```sql
mysql -h host_ip -u 用户名 -p 回车输入密码

mysql -h 192.168.1.1 -u root -p root

show databases;
use 库名;
show tables;
```

### 修改密码

进入相应bin目录

```sql
mysqladmin -uroot -p旧密码 password 新密码

mysqladmin -uroot -proot password my-new-pw
```

### 增加新用户

root用户连接MySQL

```sql
GRANT ALL PRIVILEGES ON *.* TO user1@`%` IDENTIFIED BY 'user-pw';

GRANT SELECT,,ALTER,UPDATE ON *.* TO user1@`192.168.1.2` IDENTIFIED BY 'user-pw'; # 限定特定的权限和登陆地点访问数据库
```

### 建表语句

```sql
DROP TABLE IF EXISTS `test`;
CREATE TABLE 


```

### 查询导出/插入


