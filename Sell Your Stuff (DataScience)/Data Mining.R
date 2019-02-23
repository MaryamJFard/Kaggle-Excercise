install.packages("ggplot2")
library(ggplot2)

install.packages("reshape2")
library(reshpe2)

install.packages("xts")
library(xts)

install.packages("cluster")
library(cluster)

install.packages("fpc")
library(fpc)

#How many campaigns were run in each country in each year?
campaigns_con_year = table( format(as.Date(campaigns$start_date, format = "20%y-%m-%d"), "20%y"), campaigns$country)

barplot(campaigns_con_year, col = c("#283A90","#D02090"), main = "Number of Campaigns in Each Country in Each Year", legend=c("2017", "2018"), xlab = "Country", ylab = "Number of Campaigns")

#Total ammount of money spent in each country in each year on campaigns
spent_in_con_year = with(campaigns, aggregate(total_spend ~ format(as.Date(start_date, format = "20%y-%m-%d"), "20%y") + country, data = campaigns, sum))
names(spent_in_con_year) = c("year","country", "cost")
melted <- melt(spent_in_con_year, id.vars = c("year", "country"))

p = ggplot(data = melted, aes(x = country, y = value, group = variable)) +
  geom_bar(stat = "identity", width = 0.5, position = "dodge", fill = "#283A90") +
  facet_grid(. ~ year) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90)) +
  ggtitle("Money Spent in Each Country in Each Year on Campaigns") +
  xlab("Country") +
  ylab("Cost")
p

#Transactions Over Time
transactions[,1]
clients_in_trans_residence = clients[match(transactions$account, clients$account), c(1,3)]
transactions$residence = clients_in_trans_residence$residence
transactions$transaction_date = as.Date(transactions$transaction_date)
trans_in_time = as.data.frame(table(transactions$transaction_date))
names(trans_in_time) = c("date", "trans")
trans_ts <- ts(trans_in_time$trans, frequency = 7)
plot(decompose(trans_ts))


xts_Transactions = xts(transactions$residence, order.by = transactions$transaction_date)

#K-means on transactions
for(i in 2:15)wss[i] = sum(fit = kmeans(reduced_trans,centers=i,15)$withinss)
plot(1:15,wss,type="b",main="15 clusters",xlab="no. of cluster",ylab="within clsuter sum of squares")

fit <- kmeans(reduced_trans,3)
plot(reduced_trans,col=fit$cluster,pch=15)
points(fit$centers,col=1:8,pch=3)

plotcluster(reduced_trans,fit$cluster)
points(fit$centers,col=1:8,pch=16)

clusplot(reduced_trans, fit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

#checking mean in each cluster
reduced_trans <- transactions[,c(3:9)]
reduced_trans <- data.frame(reduced_trans,fit$cluster)
cluster_mean <- aggregate(reduced_trans[,1:8],by = list(fit$cluster),FUN = mean)
cluster_mean