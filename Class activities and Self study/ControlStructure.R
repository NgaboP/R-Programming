x<- runif(20,0,100)
if (x>3){
  print("X is grater that 3")
  else
  {
    print("X is less or equal that 3")
  }
}

hist(x)

y = rnorm(100)
hist(y)
mean(y)



random_num <- runif(1,0,20)
if (random_num > 5)
{
  print("Number is greater than 5")
}else
{
  print("Number is less or equal to 5")
}


if (random_num >5)
{
  2
}else{
  5
}


for (i in 5) {
  print(x[i])
  
}

#while
#-------


count<-1
while(count<10){
  print(count)
  count<-count+1
}




#set.seed generate the same random number

p<-5
set.seed(1)
while(p>=3 && p<=10){
  coin<-rbinom(1,1,0.5)
  if (coin==1){
    p<-p+1
  }else{
    p<-p-1
  }
               
}

print(p)


#function
#---------

f<-function(x,y){
  result<-x^2+2*x*y-3
  return(result)
}
f(2,4)
