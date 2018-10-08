library(httr)
library(jsonlite)

# gaode https://lbs.amap.com/api/webservice/guide/api/weatherinfo/ 

# 参数名             含义
#         key 请求服务权限标识 
#        city         城市编码 输入城市的adcode，adcode信息可参考城市编码表
#  extensions         气象类型 可选值：base/all base:返回实况天气all:返回预报天气
#      output         返回格式 可选值：JSON,XML 


gaode_wether_api <- function(adcode, live_or_forecast) {
  if(live_or_forecast == "live") {
    type <- "base"
  } else if (live_or_forecast == "forecast") {
    type <- "all"
  } else {
    stop("live_or_forecast shoulde be 'live' or 'forecast'")
  }
  
  query_params <- list(
    key = "4bd7f1ec6f3fc87ce264375340cf06c3",
    city = adcode, # 徐汇区
    extensions = type, #live
    output = "JSON")
  
  ua <- user_agent("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.102 Safari/537.36 Vivaldi/2.0.1309.29")
  
  url <- modify_url(url = "https://restapi.amap.com/v3/weather/weatherInfo",
                    query = query_params)
  resp <- GET(url, ua)
  
  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  
  weather_result <- jsonlite::fromJSON(
    content(resp, "text", encoding = "UTF-8"), simplifyVector = TRUE)
  
  if (status_code(resp) != 200) {
    stop(
      sprintf(
        "Gaode Weather API request failed [%s]\n%s\n<%s>", 
        status_code(resp),
        weather_result$status,
        weather_result$info
      ),
      call. = FALSE
    )
  }
  
  
  if(type == "base") {
    weather_info <- weather_result$lives
    return(weather_info)
    
  } else if (type == "all") {
    city_info <- data.frame(province = weather_result$forecasts$province,
                            city = weather_result$forecasts$city,
                            adcode = weather_result$forecasts$adcode,
                            reporttime = weather_result$forecasts$reporttime)
    
    weather_info <- weather_result$forecasts$casts[[1]]
    result <- cbind(city_info, weather_info)
    return(result)
  } else {
    return(NULL)
  }
  
}


for (i in 1:5) {
  tmp <- as.character(Sys.time())
  print(i)
  print(tmp)
# 结果写出
  file_name <- paste0("result/live-",gsub("\\W","-",tmp),".csv")
  live_result <- gaode_wether_api("310104", "live") #11:00;13:00;14:00
  write.csv(live_result, file_name,row.names = FALSE,fileEncoding = "UTF-8")
  
  file_name_cast <- paste0("result/forecast-",gsub("\\W","-",tmp),".csv")
  cast_result <- gaode_wether_api("310104", "forecast") # 8:00;11:00
  write.csv(cast_result,file_name_cast,row.names = FALSE,fileEncoding = "UTF-8")
  
# 1小时查询一次
  Sys.sleep(3600)
}


