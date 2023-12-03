
library(dplyr)
library(shiny)
library(shinyNextUI)
library(shiny.react)
library(typedjs)
library(echarts4r)
library(lubridate)
library(shinyWidgets)
library(mapboxer)
library(countup)
library(gmailr)
library(shinyalert)

source("componentes.R")
source("data.R")

gm_auth_configure(path = "key.json")
gm_auth(email = T, cache = ".secret")

mail <- "eljorgehdz@gmail.com"




