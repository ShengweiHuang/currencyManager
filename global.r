library(shiny)
library(plotly)
library(RCurl)

currencyType = c("USD", "CAD", "JPY", "HKD", "GBP", "AUD", "SGD", "CHF")
buySell = c("Buy", "Sell")
cashSpot = c("Cash", "Spot")
cName = c("time","貨幣別","買進量","買進價","賣出量","賣出價","交易形式","總價格","出售匯率","獲利")