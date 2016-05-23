require(randomForest)

#Read Data.
train <- read.csv('C:/Users/Dharmam/Desktop/Machine Learning/Titanic DataSet/train.csv', 
                  header = TRUE , sep = ',')

#Drop Name and Ticket, Read report for explaination.
drops <- c("Name","Ticket") 
data <- train[,!(names(train) %in% drops)]

#Convert Factors to numerical values.
data$Pclass <- as.numeric(data$Pclass)
data$Sex <- as.numeric(data$Sex)
data$Cabin <- as.numeric(data$Cabin)
data$Embarked <- as.numeric(data$Embarked)

#Replace Age with the Mean of the Age column.
data$Age[is.na(data$Age)] <- 0
meanAge <- colMeans(data, na.rm = 'False', dims = 1)
data$Age <- train$Age
meanNum <- as.numeric(meanAge[5])
data$Age[is.na(data$Age)] <- meanNum

target <- data[0:791,]$Survived
model <- randomForest(target ~ ., data[0:791,] , boos = TRUE, mfinal = 7	)

validation <- data[792:891, ]


result <- predict(model,validation)

round(result,0)



