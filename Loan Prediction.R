install.packages("mlr")
require(mlr)
install.packages("ggplot2")
require(ggplot2)
install.packages("plyr")
require(plyr)
install.packages("rattle")
require(rattle)
install.packages("rpart")
require(rpart)
install.packages("car")
require(car)

#Load Data
train = read.csv("Train.csv", na.strings = c("", " ", NA))
test = read.csv("Test.csv", na.strings = c("", " ", NA))

#Summarize Data
summarizeColumns(train)

#Visualization 
#Univariate Plotting
barplot(table(train$Loan_Status))
prop.table(table(train$Loan_Status)) * 100

par(mfrow = c(1,2))
barplot(table(train$Gender), main = "Train Set")
barplot(table(test$Gender), main = "Test Set")
prop.table(table(train$Gender))
prop.table(table(test$Gender))

par(mfrow = c(1,2))
barplot(table(train$Married), main = "Train Set")
barplot(table(test$Married), main = "Test Set")
prop.table(table(train$Married))
prop.table(table(test$Married))

levels(train$Dependents)
par(mfrow = c(1,2))
barplot(table(train$Dependents), main = "Train Set")
barplot(table(test$Dependents), main = "Test Set")

levels(train$Education)
par(mfrow = c(1,2))
barplot(table(train$Education), main = "Train Set")
barplot(table(test$Education), main = "Test Set")

levels(train$Self_Employed)
par(mfrow = c(1,2))
barplot(table(train$Self_Employed), main = "Train Set")
barplot(table(test$Self_Employed), main = "Test Set")

par(mfrow = c(1,2))
boxplot(train$ApplicantIncome, train$CoapplicantIncome, names = c("App Income", "Coapp Income"), main = "Train Set")
boxplot(test$ApplicantIncome, test$CoapplicantIncome, names = c("App Income", "Coapp Income"), main = "Test Set")

par(mfrow = c(1,2))
boxplot(train$LoanAmount, main = "Train Set")
boxplot(test$LoanAmount, main = "Test Set")

par(mfrow = c(1,2))
hist(train$Loan_Amount_Term, main = "Train Set")
hist(test$Loan_Amount_Term, main = "Test Set")

summary(train$Loan_Amount_Term)
summary(test$Loan_Amount_Term)

par(mfrow = c(1,2))
barplot(table(train$Credit_History), main = " Train Set")
barplot(table(test$Credit_History), main = " Test Set")

par(mfrow = c(1,2))
barplot(table(train$Property_Area), main = "Train Set")
barplot(table(test$Property_Area), main = "Test Set")

#Multivariate Plotting
#Loan status by Gender
ggplot(train, aes(x = Loan_Status)) + geom_bar() + facet_grid(.~Gender) + ggtitle("Loan Status by Gender of Applicant")
#Loan status by Marital status
ggplot(train, aes(x = Loan_Status)) + geom_bar() + facet_grid(.~Married) + ggtitle("Loan Status by Marital Status of Applicant")
#Loan status by Dependants
ggplot(train, aes(x = Loan_Status)) + geom_bar() + facet_grid(.~Dependents) + ggtitle("Loan Status by Number of Dependents of Applicant")
#Loan status by Education
ggplot(train, aes(x = Loan_Status)) + geom_bar() + facet_grid(.~Education) + ggtitle("Loan Status by Education of Dependents of Applicant")
#Loan Status by Employment
print(ggplot(train, aes(x=Loan_Status))+geom_bar()+facet_grid(.~Self_Employed)+ggtitle("Loan Status by Employment status of Applicant"))
#Loan Status by Terms of Loan
print(ggplot(train, aes(x=Loan_Status))+geom_bar()+facet_grid(.~Loan_Amount_Term)+ggtitle("Loan Status by Terms  of Loan"))
#Loan Status by Credit History
print(ggplot(train, aes(x=Loan_Status))+geom_bar()+facet_grid(.~Credit_History)+ggtitle("Loan Status by Credit History of Applicant"))
#Loan Status by Property Area
print(ggplot(train, aes(x=Loan_Status))+geom_bar()+facet_grid(.~Property_Area)+ggtitle("Loan Status by property area"))
#Loan Status by Applicant income
ggplot(train, aes(x=Loan_Status,y=ApplicantIncome))+geom_boxplot()+ggtitle("Loan Status by Applicant income")
#Loan Status by Coapplicant income
ggplot(train, aes(x=Loan_Status,y=CoapplicantIncome))+geom_boxplot()+ggtitle("Loan Status by Coapplicant Income")
#Loan Status by Loan Amount
ggplot(train, aes(x=Loan_Status,y=LoanAmount))+geom_boxplot()+ggtitle("Loan Status by Loan Amount")

#Tidying the Data
allData = rbind(train[,2:12], test[,2:12])
ggplot(data=allData[allData$ApplicantIncome<20000,],aes(ApplicantIncome,fill=Married))+geom_bar(position="dodge")+facet_grid(Gender~.)
ggplot(data=allData[allData$ApplicantIncome<20000,],aes(CoapplicantIncome,fill=Married))+geom_bar(position="dodge")+facet_grid(Gender~.)

allDataMuted<-mutate(allData,TotalIncome=ApplicantIncome+CoapplicantIncome)
ggplot(data=allDataMuted,aes(TotalIncome,fill=Married))+geom_bar(position="dodge")+facet_grid(Gender~.)

allDataMuted$Married[is.na(allDataMuted$Married) & allDataMuted$CoapplicantIncome == 0] = "No"
allDataMuted$Married[is.na(allDataMuted$Married)] = "Yes"
allDataMuted[is.na(allDataMuted$Gender) & is.na(allDataMuted$Dependents), ]
allDataMuted$Gender[is.na(allDataMuted$Gender) & is.na(allDataMuted$Dependents)] = "Male"
ggplot(allDataMuted, aes(x = Dependents, fill = Gender), ) + geom_bar() +facet_grid(.~Married)

alldata2$Dependents[is.na(alldata2$Dependents) & alldata2$Married=="No"]<- "0"

mm <- allDataMuted[(allDataMuted$Gender=="Male" & allDataMuted$Married=="Yes"),c(3,6:9,11)]
mmtrain<-mm[!is.na(mm$Dependents),]
mmtest<- mm[is.na(mm$Dependents),]

depFit <- rpart(data=mmtrain,Dependents~.,xval=3)
fancyRpartPlot(depFit)
p<-predict(depFit,mmtrain,type="class")
acc=sum(p==mmtrain[,1])/length(p)
acc

allDataMuted$Dependents[is.na(allDataMuted$Dependents) & allDataMuted$Gender=="Male" & allDataMuted$Married == "Yes"]<- predict(depFit,newdata=mmtest,type="class")
gtrain<-allDataMuted[!is.na(allDataMuted$Gender),1:7]
gtest<-allDataMuted[is.na(allDataMuted$Gender),1:7]
genFit<-rpart(data=gtrain,Gender~.,xval=3)
fancyRpartPlot(genFit)
p<-predict(genFit,gtrain,type="class")
acc<-sum(p==gtrain[,1])/length(p)


allDataMuted$Gender[is.na(allDataMuted$Gender)]<-predict(genFit,gtest,type="class")
allDataMuted$Self_Employed[is.na(allData$Self_Employed)] = "No"

allDataMuted$Credit_History<-recode(allDataMuted$Credit_History,"NA=2")
ltrain<-allDataMuted[!is.na(allDataMuted$LoanAmount) & allDataMuted$LoanAmount<500,c(1:8,10)]
ltest <- allDataMuted[is.na(allDataMuted$LoanAmount),c(1:8,10)]
loanFit <- glm(data=ltrain,LoanAmount~.,na.action=na.exclude)
allDataMuted$LoanAmount[is.na(allDataMuted$LoanAmount)] = predict(loanFit,newdata=ltest)

allDataMuted$Loan_Amount_Term <- as.factor(allDataMuted$Loan_Amount_Term)
print(ggplot(data=allDataMuted,aes(x=Loan_Amount_Term))+geom_bar())

allDataMuted$Loan_Amount_Term[is.na(allDataMuted$Loan_Amount_Term)] = "360"
allDataMuted$Loan_Amount_Term = recode(allDataMuted$Loan_Amount_Term,"'350'='360';'6'='60'")

numDependents <- recode(allDataMuted$Dependents,"'3+'='3' ")
numDependents <- as.numeric(as.character(numDependents))
allDataMuted$FamilySize <- ifelse((allDataMuted$CoapplicantIncome>0 |allDataMuted$Married=="Y"),numDependents+2,numDependents+1)
allDataMuted$IncomePC <- allDataMuted$TotalIncome/allDataMuted$FamilySize

allDataMuted$LoanAmountByTotInc <- allDataMuted$LoanAmount/allDataMuted$TotalIncome
allDataMuted$LoanAmountPC <- allDataMuted$LoanAmount/allDataMuted$IncomePC

allDataMuted$Loan_Amount_Term <- as.numeric(as.character(allDataMuted$Loan_Amount_Term))
allDataMuted$LoanPerMonth <- allDataMuted$LoanAmount/allDataMuted$Loan_Amount_Term

allDataMuted$LoanPerMOnthByTotInc  <- allDataMuted$LoanPerMonth/allDataMuted$TotalIncome
allDataMuted$LoanPerMonthPC <- allDataMuted$LoanPerMonth/allDataMuted$LoanAmountPC

#make loan term variable factor again
allDataMuted$Loan_Amount_Term <- as.factor(allDataMuted$Loan_Amount_Term)

bins<-cut(allDataMuted$ApplicantIncome,breaks=20)
barplot(table(bins),main="Applicant Income")

logbins<-cut(ifelse(allDataMuted$ApplicantIncome<2.72,0,log(allDataMuted$ApplicantIncome)),breaks=20)
barplot(table(logbins),main="Log of Applicant Income")

allDataMuted$LogApplicantIncome <- ifelse(allDataMuted$ApplicantIncome<2.72,0,log(allDataMuted$ApplicantIncome))
allDataMuted$LogCoapplicantIncome <- ifelse(allDataMuted$CoapplicantIncome<2.72,0,log(allDataMuted$CoapplicantIncome))
summary(allDataMuted$LoanAmount)

allDataMuted$LogLoanAmount <- log(allDataMuted$LoanAmount)
summary(allDataMuted$TotalIncome)

allDataMuted$IncomePC <- log(allDataMuted$IncomePC)
summary(allDataMuted$LoanAmountByTotInc)

summary(allDataMuted$LoanAmountPC)

allDataMuted$LogLoanAmountPC <- log(1000*allDataMuted$LoanAmountPC)
summary(allDataMuted$LoanPerMonth)

allDataMuted$LogLoanPerMOnth <- log(allDataMuted$LoanPerMonth)
summary(allDataMuted$LoanPerMOnthByTotInc)

summary(allDataMuted$LoanPerMonthPC)

allDataMuted$LogLoanPerMOnthPC <- log(allDataMuted$LoanPerMonthPC)

nums <- sapply(allDataMuted,class)=="numeric"
numvars <- allDataMuted[,nums]
m<-cor(numvars)
v<-as.vector(m) 
id1<- rep(rownames(m),17)
id2<-as.vector(sapply(rownames(m),function(x)rep(x,17)))
d<-data.frame(v,id1,id2)
d<-d[d$v>0.8 & d$v<1,]
d

d<-d[c(1:5,8),]
d

allDataMuted<-allDataMuted[,!(names(allDataMuted) %in% d$id1)]

#Training and Predicting Loan Status
newtrain <- cbind(Loan_Status=train$Loan_Status,allDataMuted[1:614,])

#bogus Loan status for test set
Loan_Status <- as.factor(sample(c("N","Y"),replace=TRUE,size=dim(test)[1]))
newtest <- cbind(Loan_Status,allDataMuted[615:981,])

#create task
trainTask <- makeClassifTask(data = newtrain,target = "Loan_Status")
testTask <- makeClassifTask(data = newtest, target = "Loan_Status")

#normalize the variables
trainTask <- normalizeFeatures(trainTask,method = "standardize")
testTask <- normalizeFeatures(testTask,method = "standardize")

tree <- makeLearner("classif.rpart", predict.type = "response")

#set 3 fold cross validation
set_cv <- makeResampleDesc("CV",iters = 3L)

#Search for hyperparameters
treepars <- makeParamSet(
  makeIntegerParam("minsplit",lower = 10, upper = 50),
  makeIntegerParam("minbucket", lower = 5, upper = 50),
  makeNumericParam("cp", lower = 0.001, upper = 0.2)
)

#try 100 different combinations of values
tpcontrol <- makeTuneControlRandom(maxit = 100L)

#hypertune the parameters
rm(acc)
set.seed(11)
treetune <- tuneParams(learner = tree, resampling = set_cv, 
                       task = trainTask, par.set = treepars, control = tpcontrol, measures = acc)
treetune

tunedtree <- setHyperPars(tree, par.vals=treetune$x)

#train the model
treefit <- train(tunedtree, trainTask)
par(mfrow=c(1,1))
fancyRpartPlot(getLearnerModel(treefit))

treepred <- predict(treefit, testTask)

final <- data.frame(Loan_ID = test$Loan_ID, Loan_Status = treepred$data$response)

