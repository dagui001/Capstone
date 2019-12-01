#Read in tables from csv files
test1<-read.table("data - Copy.csv",
           header=TRUE,
           sep=",",
           stringsAsFactors = FALSE)

test2<-read.csv("data - Copy - Copy.csv",
         stringsAsFactors = FALSE)


library(arules)
library(Matrix)
test1[1,2]
print(test1)
print(1)
length(test1)
attach(test1)
?attach()
#run apriori on the test data and inspect the rules
rules<-apriori(test2,parameter = list(minlen=2,supp=0.01,conf=0.8),appearance=list(rhs=c("Smoke_Detector=No","Smoke_Detector=Yes"),default="lhs"))
inspect(rules)
rules.sorted<-sort(rules,by="lift")
inspect(rules.sorted)

print(typeof(test2))

#boxplot to visualize relationships between different parameters
boxplot(Room_Area~Smoke_Detector,data=test2)
boxplot(test2[3][test2[4]=='  Office' & test2[1]=='No' & test2[2]=='  Office Building' & test2[5]==0]~Smoke_Detector[test2[4]=='  Office' & test2[1]=='No' & test2[2]=='  Office Building' & test2[5]==0],data=test2)
boxplot(test2[3][test2[4]=='  Office']~Smoke_Detector[test2[4]=='  Office'],data=test2)
boxplot(test2[3][test2[4]=='  Gym']~Smoke_Detector[test2[4]=='  Gym'],data=test2)
boxplot(test2[3][test2[4]=='  Mechanical Room']~Smoke_Detector[test2[4]=='  Mechanical Room'],data=test2)

#t test to test whether room area helped with the prediction of smoke detector
t.test(Room_Area~Smoke_Detector,data=test2,mu=0,alt="two.sided",conf=0.95,var.eq=T,paired=F)

var(test2[3][test2[5]==0])
var(test2[3][test2[5]==1])

var(test2[3][test2[4]=='  Office' & test2[5]==0])
var(test2[3][test2[4]=='  Office' & test2[2]=='   Office Building' test2[5]==0])
var(test2[3][test2[4]=='  Office' & test2[5]==1])

print(test2[3][test2[4]=='  Office' & test2[1]=='No' & test2[2]=='  Office Building' & test2[5]==1])

mean(test2[3][test2[4]=='  Office' & test2[5]==0])
mean(test2[3][test2[4]=='  Office' & test2[5]==1])
mean(test2[3][test2[5]==0])
mean(test2[3][test2[5]==1])

attach(test1)
class(Smoke_Detector)
TAB=table(Room_Area,Smoke_Detector)
print(TAB3)
TAB3=table(Room_Area[test1[4]=='  Corridor'],Smoke_Detector[test1[4]=='  Corridor'])

barplot(TAB, beside=T,legend=T)
barplot(TAB2, beside=T,legend=T)
barplot(TAB3,beside=T,legend=T)

#Chi Square test for testing
CHI=chisq.test(TAB,correct=T)
CHI3=chisq.test(TAB3,correct=T)
print(CHI3)
attributes(CHI)
CHI$expected

fisher.test(TAB, conf.int=T, conf.level=0.95)
print(CHI)

TAB2=table(Fire_Sprinkler,Smoke_Detector)
print(TAB2)

barplot(TAB2, beside=T,legend=T)

CHI2=chisq.test(TAB2,correct=T)
attributes(CHI2)
CHI2$expected
print(CHI2)
fisher.test(TAB2,conf.int=T,conf.level=0.99)
