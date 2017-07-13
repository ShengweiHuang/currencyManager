shinyServer(function(input, output, session) {
  # update table
  output$recordTable <- renderTable({
    d = c(toString(Sys.time()),
          toString(input$recordCurrencyType),
          toString(input$buySellSelect),
          toString(input$cashSpotSelect),
          toString(input$quantity),
          toString(input$price))
    ## read data
    fileName = "data.csv"
    dataTable = as.data.frame(read.csv(fileName, header = FALSE))
    ## add data
    if (!is.na(as.numeric(d[5])) && !is.na(as.numeric(d[6]))) {
      newData = toRecordData(d)
      dataTable = rbind(dataTable, newData)
      write.table(dataTable, file = fileName, col.names = FALSE, row.names = FALSE, sep = ",")
    }
    ## cal data
    totalPrice = as.data.frame(as.numeric(dataTable[,3]) * as.numeric(dataTable[,4]) + as.numeric(dataTable[,5]) * as.numeric(dataTable[,6]))
    dataTable = cbind(dataTable, totalPrice)
    ## cal profit
    sellPriceCol = c()
    profitCol = c()
    currencyData = getCurrencyData()
    for (i in 1:length(dataTable[,1])) { # for each record
      if (as.numeric(dataTable[i,3]) != 0) { # if record is buy
        if (dataTable[i,7] == "Cash"){
          sellRate = currencyData[which(currencyData[,1] == dataTable[i,2]),2]
        }
        else {
          sellRate = currencyData[which(currencyData[,1] == dataTable[i,2]),4]
        }
        profit = (as.numeric(sellRate) -  as.numeric(dataTable[i,4])) * as.numeric(dataTable[i,3])
      }
      else {
        sellRate = NA
        profit = NA
      }
      sellPriceCol = c(sellPriceCol, sellRate)
      profitCol = c(profitCol, profit)
    }
    dataTable = cbind(dataTable, sellPriceCol, profitCol)
    ## set col name
    colnames(dataTable) = cName
    return(dataTable)
  })
})

# convert data from input to record data format
toRecordData <- function(d){
  time = d[1]
  currencyType = d[2]
  buySellSelect = d[3]
  cashSpotSelect = d[4]
  quantity = d[5]
  price = d[6]
  result = c(time, currencyType)
  if (buySellSelect == "Buy") {
    result = c(result, quantity, price, 0, 0)
  }
  else {
    result = c(result, 0, 0, quantity, price)
  }
  result = c(result, cashSpotSelect)
  return(t(as.data.frame(result)))
}

getCurrencyData <- function() {
  url = "http://rate.bot.com.tw/xrt?Lang=en-US"
  d = as.data.frame(readHTMLTable(url, header = TRUE, stringsAsFactors = FALSE))
  d = d[,2:6]
  for (i in (1:length(d[,1]))) {
    d[i,1] = substr(d[i,1], which(strsplit(d[i,1], "")[[1]]=="(")[1] + 1, which(strsplit(d[i,1], "")[[1]]==")")[1] - 1) 
  }
  return (d)
}