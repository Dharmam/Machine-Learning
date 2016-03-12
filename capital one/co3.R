dataDirectory <- "C:/Users/Dharmam/Desktop/capital one/check.csv"
gisetteRaw  <- read.table(dataDirectory, sep="," , header = TRUE)
print(dim(gisetteRaw))

nzv <- nearZeroVar(gisetteRaw, saveMetrics = TRUE)
print(paste('Range:',range(nzv$percentUnique)))

print(paste('Column count before cutoff:',nrow(nzv)))
## [1] "Column count before cutoff: 255"

data <- gisetteRaw[c(rownames(nzv[nzv$percentUnique > 0.5,])) ]

gisette_nzv <- data[apply(data, 1, Compose(is.finite, all)),]
print(dim(gisette_nzv))
print(paste('Column count after cutoff:',ncol(gisette_nzv)))
## [1] "Column count before cutoff: 251"

dfEvaluate <- cbind(as.data.frame(sapply(gisette_nzv, as.numeric)),
                    cluster=gisette_nzv$target)

EvaluateAUC(dfEvaluate)

pmatrix <- scale(gisette_nzv)
princ <- prcomp(pmatrix)

nComp <- 4  
dfComponents <- predict(princ, newdata=pmatrix)[,1:nComp]

dfEvaluate <- cbind(as.data.frame(dfComponents),
                    cluster=gisette_nzv$target)

EvaluateAUC(dfEvaluate)

