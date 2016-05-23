require(cvTools) 
require(class)
require(caret)
require(adabag)
require(rpart)
require(randomForest)
require(gbm)

dataset <- read.csv('C:/Users/Dharmam/Desktop/Dharmam_ML_assignment5/Wine_Data_Set.csv', 
                    header = TRUE , sep = ",")
dataset$Target <- as.factor(dataset$Target)


k <- 10 #the number of folds
folds <- cvFolds(NROW(dataset), K=k)
dataset$holdoutpred <- rep(0,nrow(dataset))


## For baaging
#print('Bagging.')
#for(i in 1:k){
#  train <- dataset[folds$subsets[folds$which != i], ] #Set the training set
#  validation <- dataset[folds$subsets[folds$which == i], ] #Set the validation set
#  cl<-train$class
#  model <- bagging(Target ~ ., data=dataset, boos = TRUE, mfinal = 7	)
#  newpred <- predict(model,validation)
#  dataset[folds$subsets[folds$which == i], ]$holdoutpred <- newpred$class
#  print(newpred$error)
#}


## For boosting

#print('Boosting.')
#for(i in 1:k){
#  train <- dataset[folds$subsets[folds$which != i], ] #Set the training set
#  validation <- dataset[folds$subsets[folds$which == i], ] #Set the validation set
#  cl<-train$class
#  model <- boosting(Target ~ ., data=dataset, boos = TRUE, mfinal = 7	)
# newpred <- predict(model,validation)
#  print(newpred$error)
#}



## For Gradient Boosting
print('Gradient Boosting.')
#for(i in 1:k){
# train <- dataset[folds$subsets[folds$which != i], ] #Set the training set
#  validation <- dataset[folds$subsets[folds$which == i], ] #Set the validation set
#  cl<-train$Target
#  model <- boost <- gbm(Target~. , data=train, 
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
#  cl<-train$Target
#  model <- randomForest(Target ~ ., data=dataset, boos = TRUE, mfinal = 7	)
#  newpred <- predict(model,validation)
#  dataset[folds$subsets[folds$which == i], ]$holdoutpred <- newpred #Put the hold out prediction in the data set for later use
#}


## FOR KNN
#dataset$class <- as.numeric(dataset$class)
#for(i in 1:k){
#  train <- dataset[folds$subsets[folds$which != i], ] #Set the training set
#  validation <- dataset[folds$subsets[folds$which == i], ] #Set the validation set
#  cl<-train$class
#  newpred <- knn(train, validation,k=10, cl, prob=TRUE)
#  dataset[folds$subsets[folds$which == i], ]$holdoutpred <- newpred #Put the hold out prediction in the data set for later use
#}

print(dataset$holdoutpred) #do whatever you want with these predictions
