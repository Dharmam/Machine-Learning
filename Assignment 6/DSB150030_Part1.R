args = commandArgs(trailingOnly = TRUE)
# test if there is at least one argument: if not, return an error
if (length(args) != 3) {
  stop("Oh ! Uh ! 3 argument must be supplied <numberOfClusters>,<input-file-name> and 
      <output-file-name>.\n", call.=FALSE)
} else {
  k = args[1]
  input = args[2]
  output = args[3]
}

library(cclust)
library(data.table)

if(is.null(args[2])){
    print('Hello Fetching Data From the URL 
          "http://www.utdallas.edu/~axn112530/cs6375/unsupervised/test_data.txt".')
    data <- read.table("http://www.utdallas.edu/~axn112530/cs6375/unsupervised/test_data.txt", 
                       header = TRUE)
}else{
  #This allows code portability, takes the path were code is set as home directory.
    #setwd(dirname(sys.frame(1)$ofile))
    cat('Hello Fetching Data From the Folder.', getwd())
    data <- read.table(args[2], header = TRUE)
}
datamatrix <- as.matrix(data)

print('Data is read.')

print('Value of k is')
print(k)
cl <- cclust (datamatrix[,1:2], k, iter.max=25, verbose=FALSE, dist="euclidean",
              method= "kmeans", rate.method="polynomial", rate.par=NULL)

result <- cbind(cluster = cl$cluster, id = data$id)
DT <- data.table(result, key="cluster")
Dt <- DT[, list(id), by=cluster]
output = NULL
for(i in 1 : k){
  select <- Dt[Dt$cluster == i ];
  output <- rbind(output,cbind(i, paste(select$id, collapse=",")))
}
write.table(output, args[3], col.names = FALSE, row.names = FALSE, quote = FALSE)

cen<-cl$centers
ess = 0
for(i in i:k)
{
  sum1 = 0;
  a<-Dt[Dt$cluster == i]
  for(j in 1:nrow(a))
  {
    d<-data[data$id==a[j]$id,]
    sum1=sum1+(cen[i,2]-d$x)^2
  }
  ess=ess+sum1
}
ess<-as.numeric(ess)
ess<-paste(c("SSE=",ess),collapse = " ")

write.table(ess,args[3],col.names = FALSE, row.names = FALSE, quote = FALSE ,append = TRUE)

