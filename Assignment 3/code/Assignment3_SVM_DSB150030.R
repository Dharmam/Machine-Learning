require(e1071)
library(e1071)

#put file location here.
dataDirectory <- "C:/Users/Dharmam/Desktop/Assignment_3/Iris_Data_Set.csv"
traindata <- read.csv(file = dataDirectory , sep = "," , header = TRUE)
print('Training Data Read.')

traindata$class <- as.numeric(traindata$class)

#seperate target from other attributes here.
n <- names(traindata)
f <- as.formula(paste("class ~", paste(n[!n %in% "class"], collapse = " + ")))

svm.model <- svm(f, traindata, cost = 1, kernel = 'linear', type = 'C-classification')

print('SVM Model Ready.')

#put test file location here.
dataDirectorytest <- "C:/Users/Dharmam/Desktop/Assignment_3/Iris_Test_Set.csv"
testdata <- read.csv(file = dataDirectorytest , sep = "," , header = TRUE)
print('Test Data Read.')

testdata$class <- as.numeric(testdata$class)

svm.pred <- predict(svm.model, testdata)

print(svm.pred)
