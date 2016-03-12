# Load the data from the csv file
dataDirectory <- "C:/Users/Dharmam/Desktop/capital one/check.csv"
gisetteRaw <- read.csv(dataDirectory, sep="," , header = TRUE,na.strings=c("") )
print(dim(gisetteRaw))

nzv <- nearZeroVar(gisetteRaw, saveMetrics = TRUE)
print(paste('Range:',range(nzv$percentUnique)))

print(paste('Column count before cutoff:',nrow(nzv)))
## [1] "Column count before cutoff: 255"

gisette_nzv <- gisetteRaw[c(rownames(nzv[nzv$percentUnique > 55,])) ]


print(dim(gisette_nzv))
print(paste('Column count after cutoff:',ncol(gisette_nzv)))
## [1] "Column count before cutoff: 251"



#Create a linear regression model
target<- gisette_nzv$target
model <- lm(target ~ .,gisette_nzv[,0:10])
head(model)
# Add the fitted line
# abline(model)

testdata <- read.csv("C:/Users/Dharmam/Desktop/capital one/checktest.csv", sep="," ,
                     header = TRUE)
na.omit(testdata)
drops <- c("f_61","f_121","f_215","f_237")
TestData<-testdata[,!(names(testdata) %in% drops)]

result <- predict(model,TestData)

plot(result)

print(summary(result))

res <- data.matrix(result, rownames.force = NA)
