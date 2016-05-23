require(RTextTools)

setwd("C:/Users/Dharmam/Desktop/Machine Learning/Assignment 4/Data")

r<-read_data("CommonData",type = "folder",index = "CommonLabels.csv", warn=F)
print('Data Read.')
doc_matrix <- create_matrix(r$Text.Data, language="english", removeNumbers=TRUE, stemWords=TRUE, removeSparseTerms=.998)
print('Container Ready.')
container <- create_container(doc_matrix, r$Labels, trainSize=1:2388,testSize=2389:3769,  virgin=FALSE)

print('Model Creation started.')
SVM <- train_model(container,"SVM")
print('SVM Model Ready.')
GLMNET <- train_model(container,"GLMNET")
print('NN Model Ready.')
MAXENT <- train_model(container,"MAXENT")
print('MaxEnt Model Ready.')
BOOSTING <- train_model(container,"BOOSTING")
print('Boosting Model Ready.')
TREE <- train_model(container,"TREE")
print('DT Model Ready.')

print('Model Creation Completed, Predictiction Started.')


SVM_CLASSIFY <- classify_model(container, SVM)
print('SVM Predcition Done.')
GLMNET_CLASSIFY <- classify_model(container, GLMNET)
print('NN Predcition Done.')
MAXENT_CLASSIFY <- classify_model(container, MAXENT)
print('MaxEnt Predcition Done.')
BOOSTING_CLASSIFY <- classify_model(container, BOOSTING)
print('Boosting Predcition Done.')
TREE_CLASSIFY <- classify_model(container, TREE)
print('DT Predcition Done.')

print('Predictiction Completed, Analysis of results Started.')
analytics <- create_analytics(container, cbind(SVM_CLASSIFY, BOOSTING_CLASSIFY, GLMNET_CLASSIFY, TREE_CLASSIFY, MAXENT_CLASSIFY))
summary(analytics)

doc_summary <- analytics@document_summary

summary(doc_summary)
