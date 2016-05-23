library(randomForest)
library(plyr)

#Read Data.
train <- read.csv('C:/Users/Dharmam/Desktop/Machine Learning/Titanic DataSet/train.csv', 
                  header = TRUE , sep = ',')


#Drop Name and Ticket, Read report for explaination.
drops <- c("Name","Ticket","Cabin") 
data <- train[,!(names(train) %in% drops)]

#Convert Factors to numerical values.
data$Pclass <- as.numeric(data$Pclass)
data$Sex <- as.numeric(data$Sex)
#data$Cabin <- as.numeric(data$Cabin)
data$Embarked <- as.numeric(data$Embarked)

#Replace Age with the Mean of the Age column.
age <- train$Age
age <- age[!is.na(age)]
meanAge <- mean(age)
data$Age[is.na(data$Age)] <- meanAge

#Replace missing Embraked with the max embarked station.
d <- count(data, 'Embarked')
d <- d[ d$freq == max( d$freq ) , ]
data$Embarked[is.na(data$Embarked)] <- d$Embarked

#Replace missing Fare with the max paid Fare.
f <- count(data, 'Fare')
f <- f[ d$freq == max( d$freq ) , ]
data$Fare[is.na(data$Fare)] <- d$Fare
target <- as.factor(data$Survived)

model <- randomForest(target ~ ., data[,!(names(data) %in% 'Survived')] , boos = TRUE, mfinal = 5 )


test <- read.csv('C:/Users/Dharmam/Desktop/Machine Learning/Titanic DataSet/test.csv', 
         header = TRUE , sep = ',')

validation <- test[,!(names(test) %in% drops)]

#Convert Factors to numerical values.
validation$Pclass <- as.numeric(validation$Pclass)
validation$Sex <- as.numeric(validation$Sex)
#validation$Cabin <- as.numeric(validation$Cabin)
validation$Embarked <- as.numeric(validation$Embarked)

#Replace Age with the Mean of the Age column.
testage <- test$Age
testage <- testage[!is.na(testage)]
testmeanAge <- mean(testage)
validation$Age[is.na(validation$Age)] <- testmeanAge

#Replace missing Embraked with the max embarked station.
testd <- count(validation, 'Embarked')
testd <- testd[ testd$freq == max( testd$freq ) , ]
validation$Embarked[is.na(validation$Embarked)] <- testd$Embarked

#Replace missing Fare with the max paid Fare.
testf <- count(validation, 'Fare')
testf <- testf[ testf$freq == max( testf$freq ) , ]
validation$Fare[is.na(validation$Fare)] <- testf$Fare

pred <- predict(model, validation)

#Prediction <- round(pred)

submit <- data.frame(PassengerId = validation$PassengerId, Survived = Prediction)
write.csv(submit, file = "forest.csv", row.names = FALSE)



