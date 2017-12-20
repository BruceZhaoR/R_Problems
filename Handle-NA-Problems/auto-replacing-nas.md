# 智能填充NA

英文描述：replacing-nas-with-latest-non-na-value，来源：http://stackoverflow.com/questions/7735647/replacing-nas-with-latest-non-na-value .

## 解决办法一：tidyr::fill

```r
> df <- data.frame(Month = 1:6, Year = c(2000,NA,NA,3000,NA,NA))
> df
  Month Year
1     1 2000
2     2   NA
3     3   NA
4     4 3000
5     5   NA
6     6   NA

> tidyr::fill(df,Year)
  Month Year
1     1 2000
2     2 2000
3     3 2000
4     4 3000
5     5 3000
6     6 3000

> df$Year <- c(NA,2000,NA,NA,3000,NA)
> df
  Month Year
1     1   NA
2     2 2000
3     3   NA
4     4   NA
5     5 3000
6     6   NA

> tidyr::fill(df,Year)
  Month Year
1     1   NA
2     2 2000
3     3 2000
4     4 2000
5     5 3000
6     6 3000

```

## 解决办法二：自己写函数

```r

> replace_na_with_last<-function(x,a=!is.na(x)){
     x[which(a)[c(1,1:sum(a))][cumsum(a)+1]]
  }


> replace_na_with_last(c(1,NA,NA,NA,3,4,5,NA,5,5,5,NA,NA,NA))

[1] 1 1 1 1 3 4 5 5 5 5 5 5 5 5

> replace_na_with_last(c(NA,"aa",NA,"ccc",NA))

[1] "aa"  "aa"  "aa"  "ccc" "ccc"

```

这个是目前最为高效，最聪明的函数，其主要思想是运用了向量索引和逻辑值累计求和特点，将NA的索引替换为非NA值的索引

函数解读：两个参数，x是包含NA的向量，a是不为NA的的逻辑向量。

```r
> which(a)
[1]  1  5  6  7  9 10 11

> which(a)[c(1,1:sum(a))] #考虑到第一个值为NA的情况。
[1]  1  1  5  6  7  9 10 11

> cumsum(a)
 [1] 1 1 1 1 2 3 4 4 5 6 7 7 7 7

> cumsum(a) + 1
 [1] 2 2 2 2 3 4 5 5 6 7 8 8 8 8

# c(1  1  5  6  7  9 10 11)[c(2 2 2 2 3 4 5 5 6 7 8 8 8 8)]
 
> which(a)[c(1,1:sum(a))][cumsum(a)+1]  #考虑到第一个值为NA的情况。
 [1]  1  1  1  1  5  6  7  7  9 10 11 11 11 11

 
 1, NA,NA,NA,3, 4, 5, NA,5, 5, 5,NA,NA,NA
 1  1  1  1  5  6  7  7  9 10 11 11 11 11 #索引替换
 
> x[ which(a)[c(1,1:sum(a))][cumsum(a)+1] ]
 [1] 1 1 1 1 3 4 5 5 5 5 5 5 5 5 # 最终结果

# 去掉第一个值
# x= c(NA,NA,NA,3,4,5,NA,5,5,5,NA,NA,NA)
# 
# which(a) 应为 4,5,6,8,9,10
# 第一次变换索引结果 4,4,5,6,7,8,9,10
# 
# cumsum(a)+ 1 为        1,1,1,2,3,4,4,5,6,7,7,7,7，运用到第一次变换的索引上去
# 得到第二次变换索引结果 4,4,4,4,5,6,6,7,8,8,8,8,8
# 
# 那么对x运用第二次变换索引的结果 就是
# c(NA,NA,NA,3,4,5,NA,5,5,5,NA,NA,NA)[c(4,4,4,4,5,6,6,7,8,8,8,8,8)]
#   3  3  3  3 4 5 5  5 5 5  5  5  5

```

## 结语

最后不得不说想出这个方法的人真尼玛牛逼啊！！！ 转了不知道几道弯，我理解了好半天，但是想明白后思路还是清楚的，就是将NA的索引变成智能的非NA值的索引。 已经写成函数，请见 [fill_na.R](fill_na.R).
