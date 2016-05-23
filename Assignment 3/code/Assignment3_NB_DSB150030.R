require(e1071)
library(e1071)

#put file location here
dataDirectory <- "C:/Users/Dharmam/Desktop/Assignment_3/Iris_Data_Set.csv"
traindata <- read.csv(file = dataDirectory , sep = "," , header = TRUE)
print('Training Data Read.')

#For Categorical Data
traindata$class <- as.numeric(traindata$class)
#traindata$Rings <- as.numeric(traindata$Rings)
#traindata$Maintainance <- as.numeric(traindata$Maintainance)
#traindata$Doors<- as.numeric(traindata$Doors)
#traindata$Persons<- as.numeric(traindata$Persons)
#traindata$Log_boot<- as.numeric(traindata$Log_boot)
#traindata$Safety <- as.numeric(traindata$Safety)
#traindata$Class <- as.numeric(traindata$Class)

#If you get all NAs in output use this,
#table <- as.data.frame(rbind(as.matrix(traindata),as.matrix(traindata)))
#
#This is happening because one of the classes in the dataset has only one instance.
#An easy fix for my application was to clone that record and add a tiny amount of noise, 
#after which predict works as expected.

#or 
#use simple testdata
table <- traindata

#naiveBayes(all attributes,target)
#range will be 1 to size-1, last element is class/target
model <- naiveBayes(table[,1:4], table$class)
print('naiveBayes Model Ready.')

#put file location here
dataDirectorytest <- "C:/Users/Dharmam/Desktop/Assignment_3/Iris_Test_Set.csv"
testdata <- read.csv(file = dataDirectorytest , sep = "," , header = TRUE)
print('Test Data Read.')

#testdata$Buying <- as.numeric(testdata$Buying)
#testdata$Sex <- as.numeric(testdata$Sex)
#testdata$Doors<- as.numeric(testdata$Doors)
#testdata$Persons<- as.numeric(testdata$Persons)
#testdata$Log_boot<- as.numeric(testdata$Log_boot)
#testdata$Safety <- as.numeric(testdata$Safety)
#testdata$Class <- as.numeric(testdata$Class)

#range will be 1 to size-1, last element is class/target
result <- predict(model, testdata[,1:4], type = 'raw')

results <- max.col(result)

print(results)

