# Load the data from the csv file
dataDirectory <- "C:/Users/Dharmam/Desktop/capital one/check.csv"
data <- read.csv(dataDirectory, sep="," , header = TRUE )
drops <- c("f_61","f_121","f_215","f_237")
pcaTraindata<-data[,!(names(data) %in% drops)]
print ('reading train data and filtering less variant features is done')


# build pca model 
pcamodel <- prcomp(~ ., data=filteredData[1:4000,], na.action=na.omit, scale=TRUE)
print ('building pca model is done')


pckTrainComponents <- predict(pcamodel, newdata=pcaTraindata[1:4000,])
bindTraindata <- cbind(as.data.frame(pckTrainComponents),class=pcaTraindata[1:4000,]$target)
print ('projection of train data to K components is done')


# save the pca train data to a file
write.table(bindTraindata,"pcatraindata",sep = ",", eol="\n")
print ('saving pca train data ')


# read validation file 
pcaValdata <- pcaTraindata[4001:4900,]
print(' reading validation data is done')


# take first k components from validation data
pckValComponents <- predict(pcamodel, newdata=pcaValdata)
bindValdata <- cbind(as.data.frame(pckValComponents),class=pcaValdata[4001:4900,]$target)
print ('projection of validation  data to K components is done')


# save the pca validation data to a file
write.table(bindValdata,"pcavaldata",sep = ",", eol="\n")
print ('saving pca validation data ')



target<- bindTraindata$target

#Create a linear regression model
model <- lm(target ~ .,bindTraindata)
head(model)






# read test data file 
#testdata <- read.csv("C:/Users/Dharmam/Desktop/capital one/checktest.csv", sep=",",header = TRUE)
#na.omit(testdata)
#drops <- c("f_61","f_121","f_215","f_237")
#pcaTestdata<-testdata[,!(names(testdata) %in% drops)]
#print(' reading test data is done')

# take first k components from validation data
#pckTestComponents <- predict(pcamodel, newdata=pcaTestdata)
#bindTestdata <- cbind(as.data.frame(pckTestComponents),class=pcaTestdata$V26)
#print ('projection of Test  data to K components is done')

# save the pca Test data to a file
#write.table(bindTestdata,"pcatestdata",sep = ",", eol="\n")
#print ('saving pca test data ')












