library(rpart)
require(rpart)

#put file location here
dataDirectory <- "C:/Users/Dharmam/Desktop/Assignment_3/Iris_Data_Set.csv"
traindata <- read.csv(file = dataDirectory , sep = "," , header = TRUE)
print('Training Data Read.')

traindata$class <- as.numeric(traindata$class)

#seperate target from other attributes here.
n <- names(traindata)
f <- as.formula(paste("class ~", paste(n[!n %in% "class"], collapse = " + ")))

fittree <- rpart(f, traindata, method = 'class' )


print('Decison Tree Created.')
plotcp(fittree)

#put file location here
dataDirectorytest <- "C:/Users/Dharmam/Desktop/Assignment_3/Iris_Test_Set.csv"
newdata <- read.csv(file = dataDirectorytest , sep = "," , header = TRUE)
print('Test Data Read.')

#newdata$Sex <- as.numeric(newdata$Sex)

#range will be 1 to size-1, last element is class/target
result <- predict(fittree, newdata[,1:4], type = 'class')
print('Prediction Done.')
print(result)