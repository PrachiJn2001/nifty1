# ui.R
source("dependencies.R")

get_nifty50_companies <- function() {
  nifty50_symbols <- c(
    "RELIANCE.NS", "TCS.NS", "HDFCBANK.NS", "INFY.NS", "ICICIBANK.NS",
    "HINDUNILVR.NS", "LT.NS", "KOTAKBANK.NS", "BAJFINANCE.NS", "SBIN.NS",
    "BHARTIARTL.NS", "AXISBANK.NS", "ASIANPAINT.NS", "M&M.NS", "TITAN.NS",
    "ULTRACEMCO.NS", "NESTLEIND.NS", "HCLTECH.NS", "WIPRO.NS", "MARUTI.NS",
    "POWERGRID.NS", "NTPC.NS", "ADANIPORTS.NS", "JSWSTEEL.NS", "GRASIM.NS",
    "BAJAJFINSV.NS", "HDFCLIFE.NS", "ONGC.NS", "TECHM.NS", "LTIM.NS",
    "COALINDIA.NS", "SUNPHARMA.NS", "DIVISLAB.NS", "CIPLA.NS", "ADANIENT.NS",
    "HEROMOTOCO.NS", "EICHERMOT.NS", "APOLLOHOSP.NS", "BPCL.NS", "IOC.NS",
    "TATACONSUM.NS", "SBILIFE.NS", "SHREECEM.NS", "UPL.NS", "DRREDDY.NS",
    "INDUSINDBK.NS", "TATAMOTORS.NS", "HINDALCO.NS", "BAJAJAUTO.NS", "DMART.NS"
  )
  return(nifty50_symbols)
}

ui <- fluidPage(
  titlePanel("Nifty 50 Stock vs. Nifty Comparison"),
  sidebarLayout(
    sidebarPanel(
      selectInput("company", "Select Company:", choices = get_nifty50_companies()),
      dateInput("start_date", "Start Date:", value = Sys.Date() - 365),
      dateInput("end_date", "End Date:", value = Sys.Date()),
      actionButton("get_data", "Get Stock Data")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Stock vs. Nifty", plotlyOutput("stock_vs_nifty_plot")),
        tabPanel("Percentage Change", plotlyOutput("percentage_change_plot"))
      )
    )
  )
)
