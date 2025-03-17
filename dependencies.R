# dependencies.R
list.of.packages <- c("shiny", "quantmod", "dplyr", "lubridate", "plotly")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(shiny)
library(quantmod)
library(dplyr)
library(lubridate)
library(plotly)
