require(cvTools) 
require(class)
require(caret)
require(adabag)
require(rpart)
require(randomForest)
require(gbm)

dataset <- read.csv('C:/Users/Dharmam/Desktop/Dharmam_ML_assignment5/Car_Data_Set.csv', 
                    header = TRUE , sep = ",")
dataset$Buying <- as.numeric(dataset$Buying)
dataset$Maintainance <- as.numeric(dataset$Maintainance)
dataset$Doors <- as.numeric(dataset$Doors)
dataset$Persons <- as.numeric(dataset$Persons)
dataset$Log_boot <- as.numeric(dataset$Log_boot)
dataset$Safety <- as.numeric(dataset$Safety)
dataset$Class <- as.factor(dataset$Class)


k <- 10 #the number of folds
folds <- cvFolds(NROW(dataset), K=k)
dataset$holdoutpred <- rep(0,nrow(dataset))


## For baaging
#print('Bagging.')
#for(i in 1:k){
#  train <- dataset[folds$subsets[folds$which != i], ] #Set the training set
#  validation <- dataset[folds$subsets[folds$which == i], ] #Set the validation set
#  cl<-train$class
#  model <- bagging(Class ~ ., data=dataset, boos = TRUE, mfinal = 7	)
#  newpred <- predict(model,validation)
#  dataset[folds$subsets[folds$which == i], ]$holdoutpred <- newpred$class
#  print(newpred$error)
#}


## For boosting

#print('Boosting.')
#for(i in 1:k){
#  train <- dataset[folds$subsets[folds$which != i], ] #Set the training set
#  validation <- dataset[folds$subsets[folds$which == i], ] #Set the validation set
#  cl<-train$Class
#  model <- boosting(Class ~ ., data=dataset, boos = TRUE, mfinal = 7	)
#  newpred <- predict(model,validation)
#  print(newpred$error)
#}



## For Gradient Boosting
#print('Gradient Boosting.')
#for(i in 1:k){
#  train <- dataset[folds$subsets[folds$which != i], ] #Set the training set
#  validation <- dataset[folds$subsets[folds$which == i], ] #Set the validation set
#  cl<-train$Class
#  model <- boost <- gbm(Class~. , data=train, 
#                        distribution = 'gaussian', 
#                        n.trees = 5000, 
#                       interaction.depth = 4)
#newpred <- predict(model,validation,n.trees=5000)
#dataset[folds$subsets[folds$which == i], ]$holdoutpred <- newpred
#}


## For Random Forest

#for(i in 1:k){
#  train <- dataset[folds$subsets[folds$which != i], ] #Set the training set
#  validation <- dataset[folds$subsets[folds$which == i], ] #Set the validation set
#  cl<-train$Class
#  model <- randomForest(Class ~ ., data=dataset, boos = TRUE, mfinal = 7	)
#  newpred <- predict(model,validation)
#  print(newpred)
#}


## FOR KNN
#dataset$Class <- as.numeric(dataset$Class)
#for(i in 1:k){
#  train <- dataset[folds$subsets[folds$which != i], ] #Set the training set
#  validation <- dataset[folds$subsets[folds$which == i], ] #Set the validation set
#  cl<-train$Class
#  newpred <- knn(train, validation,k=10, cl, prob=TRUE)
#  dataset[folds$subsets[folds$which == i], ]$holdoutpred <- newpred #Put the hold out prediction in the data set for later use
#}

#print(dataset$holdoutpred) #do whatever you want with these predictions