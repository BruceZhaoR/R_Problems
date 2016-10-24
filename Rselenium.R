library(RSelenium)
# checkForServer() 
startServer() 
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4444, browserName = "firefox", platform = "LINUX") 
remDr$open() 
remDr$deleteAllCookies()
remDr$navigate('https://login.taobao.com/member/login.jhtml')

eles<-remDr$findElement(using='xpath',"//*[@id='J_Quick2Static']")
eles$clickElement()

eles<-remDr$findElement(using='name','TPL_username')
eles$sendKeysToElement(list("your name"))

eles<-remDr$findElement(using='name','TPL_password')
eles$sendKeysToElement(list("your password"))


eles<-remDr$findElement(using='xpath',"//*[@id='J_SubmitStatic']")
eles$clickElement()

cookies<-remDr$getAllCookies()

#find what you've bought
remDr$navigate('https://buyertrade.taobao.com/trade/itemlist/list_bought_items.htm')
goods<-remDr$findElements(using="xpath","//div[@class='index-mod__order-container___1ur4-']")

#first item
goods[[1]]$findChildElement(using='xpath',"div/table/tbody[2]/tr/td[1]/div/div[2]/p[1]/a[1]/span[2]")->tmp
tmp$getElementText()

#status 
goods[[1]]$findChildElement(using='xpath',"div/table/tbody[2]/tr/td[6]/div/p/span")->tmp
tmp$getElementText()

#price
goods[[1]]$findChildElement(using='xpath',"div/table/tbody[2]/tr/td[5]/div/div[1]/p")->tmp
tmp$getElementText()


library(RSelenium)                               
# checkForServer() 
startServer() 
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4444, browserName = "firefox", platform = "LINUX") 
remDr$open() 
remDr$deleteAllCookies()
remDr$navigate('http://www.taobao.com')

eles<-remDr$findElement(using='class name',"search-combobox-input")
eles$sendKeysToElement(list("k420",key='enter'))

eles<-remDr$findElement(using='id','mainsrp-itemlist')
goods<-eles$findChildElements(using='xpath','div/div/div/div')

goods[[1]]$clickElement()

remDr$getWindowHandles()->t1
remDr$switchToWindow(t1[[1]][2])
remDr$getTitle()

eles<-remDr$findElements(using='xpath','//a[@href="#J_Reviews"]')
eles[[1]]$clickElement()
reviews<-remDr$findElements(using='class name','tm-rate-fulltxt')
reviews[[1]]$getElementText()

pages<-remDr$findElements(using='xpath','//a[@data-page="2"]')
pages[[1]]$clickElement()
reviews<-remDr$findElements(using='class name','tm-rate-fulltxt')
reviews[[1]]$getElementText()

