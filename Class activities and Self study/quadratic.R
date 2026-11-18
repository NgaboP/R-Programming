#Quadratic Equation



read_coefficients<-function(){
  
  a<-as.numeric(readline("Enter a number:"))
  b<-as.numeric(readline("Enter b number:"))
  c<-as.numeric(readline("Enter c number:"))
  
  return(list(a,b,c))
}
coeff <- read_coefficients()

coeff

delta <- function(a,b,c){
  dlt <- b^2 - 4*a*c
  return(dlt)
}

delita <- delta(a,b,c)
delita
















i<- function(d) "a" + d
h <- function(c) i(c)
g <- function(b) h(b)
f <- function(a) g(a)

f(5)

