library(dplyr)
library(gdata)
dta = read.xls("2019-04-11 Stock Labels.xlsx",header=F,sheet = 2)

#tt = rep(dta$V1,times = dta$V2)
dta = na.exclude(dta)
tt1 = data.frame(V1=integer(),V2=integer())
for(i in 1:dim(dta)[1]){
  sam=dta[i,]
  times=c(dta$V2[i])
  tt = as.data.frame(lapply(sam,rep,times))
  tt1 = rbind(tt1,tt)
}
  View(tt1)
write.csv(tt1, "stocks-repeat.csv")
