install.packages("dplyr")
library(dplyr)

data()
install.packages("nycflights13")
install.packages("tidyverse")
library(nycflights13)
?nycflights13

View(flights)
  

view(flights %>%
  group_by(month) %>%
  summarise(total_flights = n())
  
  
  
  
  
install.packages("ggplot2")


library(ggplot2)  

library(datasets)
table(mtcars$cyl)
