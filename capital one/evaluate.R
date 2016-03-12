EvaluateAUC <- function(dfEvaluate) {
  require(xgboost)
  require(Metrics)
  require(pROC)
  CVs <- 5
  cvDivider <- floor(nrow(dfEvaluate) / (CVs+1))
  indexCount <- 1
  outcomeName <- c('cluster')
  predictors <- names(dfEvaluate)[!names(dfEvaluate) %in% outcomeName]
  lsErr <- c()
  lsAUC <- c()
  for (cv in seq(1:CVs)) {
   # print(paste('cv',cv))
    dataTestIndex <- c((cv * cvDivider):(cv * cvDivider + cvDivider))
    dataTest <- dfEvaluate[dataTestIndex,]
    dataTrain <- dfEvaluate[-dataTestIndex,]
    
    bst <- xgboost(data = as.matrix(dataTrain[,predictors]),
                   label = dataTrain[,outcomeName],
                   max.depth=6, eta = 1, verbose=0,
                   nround=5, nthread=4, 
                   objective = "reg:linear")
    predictions <- predict(bst, as.matrix(dataTest[,predictors]), outputmargin=TRUE)
    err <- rmse(dataTest[,outcomeName], predictions)
    auc <- auc(dataTest[,outcomeName],predictions)
    
    lsErr <- c(lsErr, err)
    lsAUC <- c(lsAUC, auc)
    gc()
  }
  print(paste('Mean Error:',mean(lsErr)))
  print(paste('Mean AUC:',mean(lsAUC)))
}