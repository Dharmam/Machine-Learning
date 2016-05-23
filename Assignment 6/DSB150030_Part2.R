args = commandArgs(trailingOnly = TRUE)

if (length(args) != 4) {
  stop("Oh ! Uh ! 3 argument must be supplied <numberOfClusters>,<input-file-name> and 
       <output-file-name>.\n", call.=FALSE)
} else {
  k = args[1]
  input = args[3]
  output = args[4]
  initialSeed = args[2]
}



library(data.table)
library(jsonlite)
library(flexclust)
library(cluster)
#library(kernlab)

file <- "Tweets.json"
tweet <- readLines(args[3])
document <- fromJSON(sprintf("[%s]", paste(tweet, collapse=",")))
initial <- read.table(args[2])
initial <- as.data.frame(initial)
initial$V1 <- as.numeric(gsub(",","",initial$V1))

x <- document$text
x <- as.data.frame(x)
y<- document$id

z<-cbind(i = 1:nrow(document),id = y)
z<- as.data.frame(z)
met <- NULL

for(i in 1:nrow(initial))
{
  met<-rbind(met,z[z$id==initial[i,],])
}
# initialize similarity matrix
m <- matrix(NA, nrow=nrow(x),ncol=nrow(x))
jaccard <- as.data.frame(m)

for(i in 1:nrow(x)) {
  tw1 <-  strsplit(document[i,1], " |\\.")
  for(j in i:nrow(x)) {
    tw2 <-  strsplit(document[j,1], " |\\.")
    v <- mapply(function(tw1, tw2) {
      length(intersect(tw1, tw2))
    }, tw1=tw1, tw2=tw2)
    u <- mapply(function(tw1, tw2) {
      length(union(tw1, tw2))
    }, tw1=tw1, tw2=tw2)
    jaccard[i,j]= v/u 
    jaccard[j,i]=jaccard[i,j]
  }
}
k <- args[1]
u=0.1
cl <-pam(jaccard, k,  medoids = met$i)
result <- cbind(cluster = cl$cluster, id = z$id , index = z$i)
DT <- data.table(result, key="cluster")
Dt <- DT[, list(id,index), by=cluster]
output = NULL
for(i in 1 : k){
  select <- Dt[Dt$cluster == i ];
  output <- rbind(output,cbind(i, paste(select$id, collapse=",")))
}

write.table(output, args[4], col.names = FALSE, row.names = FALSE, quote = FALSE)

output = NULL
for(i in 1:k)
{
  select <-Dt[Dt$cl==i];
  output <- rbind(output,cbind(i,paste(select$id,collapse=",")))
}
centre <- cl$id.med
sse = 0
for(i in 1:k)
{
  sum1=0
  a<-Dt[Dt$cl==i]
  for(j in 1:nrow(a))
  {
    sum1=sum1+(jaccard[centre[i],a[j]$index])^2
  }
  sse = sse+sum1
}
sse<-as.numeric(sse)
ess<-paste(c("SSE=",sse*u),collapse = " ")

write.table(ess,args[4],col.names = FALSE, row.names = FALSE, quote = FALSE ,append = TRUE)

