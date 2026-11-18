library(datasets)
data1 <- datasets::cars
head(data1)
summary(data1)
str(data1)
names(data1)
x <- c(0.5,0.6)
age <-c(20,35,29)
summary(age)
mean(age)

####Let’s create a data frame
#---------------------------

studentID<-c(1,2,3,4,5)
math_score<-c(12,17,10,9,NA)
gender<-c("M","F","M","M","F")
it_score<-c(13,18,11,10,19)

scoredata <- data.frame(studentID,gender,math_score,it_score)
scoredata


View(scoredata)   ## Returns Table
library(dplyr: