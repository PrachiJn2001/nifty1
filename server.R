# server.R
source("dependencies.R")
source("ui.R")

server <- function(input, output) {
  stock_data <- eventReactive(input$get_data, {
    req(input$company, input$start_date, input$end_date)
    tryCatch({
      getSymbols(input$company, from = input$start_date, to = input$end_date, auto.assign = FALSE)
    }, error = function(e) {
      showNotification(paste("Error fetching data:", e$message), type = "error")
      return(NULL)
    })
  })

  nifty_data <- eventReactive(input$get_data, {
    req(input$start_date, input$end_date)
    tryCatch({
      getSymbols("^NSEI", from = input$start_date, to = input$end_date, auto.assign = FALSE)
    }, error = function(e) {
      showNotification(paste("Error fetching Nifty data:", e$message), type = "error")
      return(NULL)
    })
  })

  output$stock_vs_nifty_plot <- renderPlotly({
    stock <- stock_data()
    nifty <- nifty_data()

    if (!is.null(stock) && !is.null(nifty)) {
      stock_close <- data.frame(Date = index(stock), Close = coredata(stock[, "Close"]))
      nifty_close <- data.frame(Date = index(nifty), Close = coredata(nifty[, "NSEI.Close"]))

      p <- plot_ly(stock_close, x = ~Date, y = ~Close, type = 'scatter', mode = 'lines', name = input$company, yaxis = "y2", line = list(color = 'blue')) %>%
        add_trace(data = nifty_close, x = ~Date, y = ~Close, type = 'scatter', mode = 'lines', name = "Nifty 50", yaxis = "y1", line = list(color = 'red')) %>%
        layout(
          yaxis = list(title = "Nifty 50 Close Price"),
          yaxis2 = list(title = paste(input$company, "Close Price"), overlaying = "y", side = "right"),
          title = paste(input$company, "vs. Nifty 50 Close Price")
        )
      p
    } else {
      plotly_empty()
    }
  })

  output$percentage_change_plot <- renderPlotly({
    stock <- stock_data()
    nifty <- nifty_data()

    if (!is.null(stock) && !is.null(nifty)) {
      stock_returns <- dailyReturn(stock[, "Close"]) * 100
      nifty_returns <- dailyReturn(nifty[, "NSEI.Close"]) * 100

      stock_returns_df <- data.frame(Date = index(stock_returns), Returns = coredata(stock_returns))
      nifty_returns_df <- data.frame(Date = index(nifty_returns), Returns = coredata(nifty_returns))

      p <- plot_ly(stock_returns_df, x = ~Date, y = ~Returns, type = 'scatter', mode = 'lines', name = input$company, line = list(color = 'blue')) %>%
        add_trace(data = nifty_returns_df, x = ~Date, y = ~Returns, type = 'scatter', mode = 'lines', name = "Nifty 50", line = list(color = 'red')) %>%
        layout(
          yaxis = list(title = "Daily Returns (%)"),
          title = "Daily Returns Comparison"
        )
      p
    } else {
      plotly_empty()
    }
  })
}
