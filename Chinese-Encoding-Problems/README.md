# 说明

Windows下，中文乱码啊啊啊。。。

## useful articles

<https://kevinushey.github.io/blog/2018/02/21/string-encoding-and-r/>

``` r
icuSetCollate(locale = "zh_Hans_CN")
a <- "中国人"
b <- enc2utf8(a)

# stri_enc_mark(a)
# stri_enc_mark(b)

pryr::bits(a)
#> [1] "11010110 11010000 10111001 11111010 11001000 11001011"
pryr::bits(b)
#> [1] "11100100 10111000 10101101 11100101 10011011 10111101 11100100 10111010 10111010"

charToRaw(a)
#> [1] d6 d0 b9 fa c8 cb
xx <- iconv(b, from = "UTF-8", to = "GBK")
# xx <- stri_encode(b,from ="UTF-8", to = "GBK")
charToRaw(xx)
#> [1] d6 d0 b9 fa c8 cb

charToRaw(b)
#> [1] e4 b8 ad e5 9b bd e4 ba ba
# b_xx <- stri_encode(a, from = "GBK",to = "UTF-8")
b_xx <- iconv(a, from = "GBK",to = "UTF-8")
charToRaw(b_xx)
#> [1] e4 b8 ad e5 9b bd e4 ba ba

# stri_encode(b_xx, from = "UTF-8", to = "GBK")

rawToChar(charToRaw(a))
#> [1] "中国人"

# encoding garbled
rawToChar(charToRaw(b))
#> [1] "涓浗浜\xba"

utf8ToInt(a)
#> [1] NA
utf8ToInt(b)
#> [1] 20013 22269 20154

intToUtf8(utf8ToInt(b))
#> [1] "中国人"
```

Created on 2018-09-11 by the [reprex package](http://reprex.tidyverse.org) (v0.2.0).
