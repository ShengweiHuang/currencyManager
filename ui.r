shinyUI(fluidPage(
  titlePanel("personal currency trade record"),
  sidebarLayout(
    sidebarPanel(
      ## personal record
      helpText("Find Personal Record"),
      textInput("id", "input your id", value=""), # input record id
      ## ask add record
      selectInput("addRecord", "Add a Record?", # input type and tag
                  choices = yn), # default value
      ## end
      ## input record
      selectInput("recordCurrencyType", "Choose a currency type:", # input type and tag
                  choices = currencyType), # default value
      selectInput("buySellSelect", "Buy or sell:", # input type and tag
                  choices = buySell), # default value
      selectInput("cashSpotSelect", "Cash or spot:", # input type and tag
                  choices = cashSpot), # default value
      textInput("quantity", "Quantity", value=""), # input quantity
      textInput("price", "Price", value=""), # input quantity
      ## end
      submitButton("submit") # submit data
      #label = "Submit", inputId = "submit"
    ),
    mainPanel(
      conditionalPanel(
        condition = "input.id != ''",
        tableOutput("recordTable")
      )
    )
  )
))