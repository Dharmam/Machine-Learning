library('RTextTools')
setwd(".")

r<-read_data("C:/Users/Dharmam/Desktop/Assignment_3/example/spam-sh",type = "folder",
             index = "C:/Users/Dharmam/Desktop/Assignment_3/example/labels.csv")

doc_matrix <- create_matrix(r$Text.Data, language="english", removeNumbers=TRUE, stemWords=TRUE, removeSparseTerms=.998)
container <- create_container(doc_matrix, r$Labels, trainSize=1:16, testSize=17:20, virgin=FALSE)

SVM <- train_model(container,"SVM")
GLMNET <- train_model(container,"GLMNET")
MAXENT <- train_model(container,"MAXENT")
TREE <- train_model(container,"TREE")

SVM_CLASSIFY <- classify_model(container, SVM)
GLMNET_CLASSIFY <- classify_model(container, GLMNET)
MAXENT_CLASSIFY <- classify_model(container, MAXENT)
TREE_CLASSIFY <- classify_model(container, TREE)

analytics <- create_analytics(container,MAXENT_CLASSIFY, cbind(SVM_CLASSIFY,  GLMNET_CLASSIFY, TREE_CLASSIFY))
summary(analytics)