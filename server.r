shinyServer(function(input, output, session) {
  # update table
  output$recordTable <- renderTable({
    d = c(toString(input$id),
          toString(Sys.time()),
          toString(input$recordCurrencyType),
          toString(input$buySellSelect),
          toString(input$cashSpotSelect),
          toString(input$quantity),
          toString(input$price))
    print(d)
    fileName = paste("./", d[1], ".csv", sep = "")
    ## read data
    if (file.exists(fileName)) {
      dataTable = as.data.frame(read.csv(fileName, header = FALSE))
    }
    else if (input$addRecord == "No") { # if no user record and don't want to add a new record
      dataTable = t(as.data.frame(c(0,0,0,0,0,0,0)))
      colnames(dataTable) = cName[1:7]
      return(dataTable)
    }
    else { # add new user and data
      dataTable = t(as.data.frame(c(0,0,0,0,0,0,0)))
    }
    ## add data
    if (input$addRecord == "Yes") {
      if (d[1] != "" && !is.na(as.numeric(d[6])) && !is.na(as.numeric(d[7]))) {
        newData = toRecordData(d)
        #colnames(newData) = c()
        dataTable = rbind(dataTable, newData)
        write.table(dataTable, file = fileName, col.names = FALSE, row.names = FALSE, sep = ",")
      }
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
  time = d[2]
  currencyType = d[3]
  buySellSelect = d[4]
  cashSpotSelect = d[5]
  quantity = d[6]
  price = d[7]
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