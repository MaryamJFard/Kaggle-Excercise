install.packages("caTools")
require(caTools)
install.packages("caret")
require(caret)
install.packages("ellipse")
require(ellipse)

#Load Data
flowerAttr = iris

#Split
set.seed(1234)
sample = sample.split(1:150, SplitRatio = 0.80)
train = subset(flowerAttr, sample == TRUE)
test  = subset(flowerAttr, sample == FALSE)

#Summerize Train Data
dim(train)
sapply(train, class)
head(train)
levels(train$Species)
percentage = prop.table(table(train$Species)) * 100
cbind(frequency = table(train$Species), percentage)
summary(train)

#Visualise 
#Univariate plotting
par(mfrow = c(1, 4)) 
listOfAttr = list(Sepal.Length = train$Sepal.Length, Sepal.Width = train$Sepal.Width, Petal.Length = train$Petal.Length, Petal.Width = train$Petal.Width)
lapply(list, boxplot)
#Visualise
#Multivariate Plotting
pairs(train[1:4], main = "Scatter Plot", pch = 21, bg = c("red", "green", "blue")[as.integer(train$Species)])
featurePlot(x = train[1:4], y = train$Species, plot = "ellipse")

#Fitting Algorithms
control <- trainControl(method="cv", number=10)
metric <- "Accuracy"
# a) linear algorithms
# LDA
set.seed(7)
fit.lda <- train(Species~., data=train, method="lda", metric=metric, trControl=control)
# b) nonlinear algorithms
# CART
set.seed(7)
fit.cart <- train(Species~., data=train, method="rpart", metric=metric, trControl=control)
# kNN
set.seed(7)
fit.knn <- train(Species~., data=train, method="knn", metric=metric, trControl=control)
# c) advanced nonlinear algorithms
# SVM
set.seed(7)
fit.svm <- train(Species~., data=train, method="svmRadial", metric=metric, trControl=control)
# Random Forest
set.seed(7)
fit.rf <- train(Species~., data=train, method="rf", metric=metric, trControl=control)
results <- resamples(list(lda=fit.lda, cart=fit.cart, knn=fit.knn, svm=fit.svm, rf=fit.rf))
summary(results)
#Compare
dotplot(results)
#Summarize Best Model
print(fit.lda)

#Prediction
predictions <- predict(fit.lda, test)
confusionMatrix(predictions, test$Species)

