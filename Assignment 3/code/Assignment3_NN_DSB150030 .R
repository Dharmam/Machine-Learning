library(neuralnet)
library(car)
library(caret)
require(car)
require(neuralnet)
require(caret)

#put file location here
dataDirectory <- "C:/Users/Dharmam/Desktop/Assignment_3/data set/Haberman_Data_Set.csv"
traindata <- read.csv(file = dataDirectory , sep = "," , header = TRUE)

print('Training Data Read.')

#For Categorical data, convert all factors into numerical
#traindata$Sex <- as.numeric(traindata$Sex)
#traindata$Rings <- as.numeric(traindata$Rings)
#traindata$class <- as.numeric(traindata$class)
#traindata$Buying <- as.numeric(traindata$Buying)
#traindata$Maintainance <- as.numeric(traindata$Maintainance)
#traindata$Doors<- as.numeric(traindata$Doors)
#traindata$Persons<- as.numeric(traindata$Persons)
#traindata$Log_boot<- as.numeric(traindata$Log_boot)
#traindata$Safety <- as.numeric(traindata$Safety)
#traindata$Class <- as.numeric(traindata$Class)


#seperate target from other attributes here.
n <- names(traindata)
f <- as.formula(paste("Survived ~", paste(n[!n %in% "Survived"], collapse = " + ")))
nn <- neuralnet(f,data=traindata,hidden=0, linear.output=T, threshold = 0.5)
print('Neural Network Created.')
#plot(nn)

#put file location here
dataDirectorytest <- "C:/Users/Dharmam/Desktop/Assignment_3/data set/Haberman_Test_Set.csv"
testdata <- read.csv(file = dataDirectorytest , sep = "," , header = TRUE)
print('Test Data Read.')

#testdata$Sex <- as.numeric(testdata$Sex)
#testdata$class <- as.numeric(testdata$class)
#testdata$Buying <- as.numeric(testdata$Buying)
#testdata$Maintainance <- as.numeric(testdata$Maintainance)
#testdata$Doors<- as.numeric(testdata$Doors)
#testdata$Persons<- as.numeric(testdata$Persons)
#testdata$Log_boot<- as.numeric(testdata$Log_boot)
#testdata$Safety <- as.numeric(testdata$Safety)
#testdata$Class <- as.numeric(testdata$Class)

#range will be 1 to size-1, last element is class/target
pr.nn <- compute(nn,testdata[,1:3])

print(round(pr.nn$net.result))