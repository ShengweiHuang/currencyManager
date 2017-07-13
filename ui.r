shinyUI(fluidPage(
  titlePanel("personal currency trade record"),
  sidebarLayout(
    sidebarPanel(
      ## input record
      selectInput("recordCurrencyType", "Choose a currency type:",
                  choices = currencyType),
      selectInput("buySellSelect", "Buy or sell:",
                  choices = buySell),
      selectInput("cashSpotSelect", "Cash or spot:",
                  choices = cashSpot),
      textInput("quantity", "Quantity", value=""),
      textInput("price", "Price", value=""),
      ## end
      submitButton("submit") # submit data
    ),
    mainPanel(
      tableOutput("recordTable")
    )
  )
))