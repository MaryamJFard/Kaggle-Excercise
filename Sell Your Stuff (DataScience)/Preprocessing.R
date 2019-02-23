install.packages("data.table")
library(data.table)

#World Wide campaigns
campaigns$country[which(campaigns$country == "")] = "ww"

#Length of each campaigns in days
campaigns$length = as.numeric(difftime(as.POSIXct(as.Date(campaigns$end_date)), as.POSIXct(as.Date(campaigns$start_date))), units= "days")

#NA values

#Transactions

#Those who did not deposit
transactions[which(transactions$count_deposits == 0 & is.na(transactions$total_deposits)), 5] = 0

#Those who did not withdrawl
transactions[which(transactions$count_withdrawals == 0 & is.na(transactions$total_withdrawals)), 6] = 0

#Those who sell nothing so total_sell should be 0 dollars
transactions[which(transactions$count_contracts == 0 & is.na(transactions$total_sell)), 4] = 0

#Those who sell something but total_sell is missing
missing_sell_amount = transactions[which(transactions$count_contracts != 0 & is.na(transactions$total_sell)), 2]
missing_sell_amount = as.data.frame.table(table(missing_sell_amount), stringsAsFactors = F)
missing_sell_amount = missing_sell_amount[which(missing_sell_amount$Freq == 1), ]
missing_sell_amount$Freq = NULL
names(missing_sell_amount) = c("account")
missing_sell_amount$account = as.integer(missing_sell_amount$account)
missing_sell_amount_trans = transactions[which(transactions$account %in% missing_sell_amount$account),]
not_possible_to_analyse = missing_sell_amount_trans[which(is.na(temp$total_buy) | is.na(temp$total_deposits) | is.na(temp$total_withdrawals)),2]
not_possible_to_analyse = not_possible_to_analyse[match(not_possible_to_analyse, not_possible_to_analyse) == seq_along(not_possible_to_analyse)]
missing_sell_amount = missing_sell_amount[-which(missing_sell_amount$account %in% not_possible_to_analyse), ]
possible_missing_sell_amount_trans = transactions[which(transactions$account %in% missing_sell_amount), ]
possible_missing_sell_amount_trans[which(is.na(possible_missing_sell_amount_trans$total_sell)), 4] = 0
possible_missing_sell_amount_trans$transaction_date = NULL
missing_sell_amount_final = with(possible_missing_sell_amount_trans, aggregate(.~account,possible_missing_sell_amount_trans, sum ))
balance = clients[which(clients$account %in% missing_sell_amount_final$account),c(1,10)]
balance_from_trans = data.frame("account" = missing_sell_amount_final$account, "balance" = missing_sell_amount_final$total_sell + missing_sell_amount_final$total_deposits-missing_sell_amount_final$total_withdrawals-missing_sell_amount_final$total_buy)
balance_from_trans = balance_from_trans[ order(match(balance_from_trans$account, balance$account)), ]
#Cannot find sell amount missing 
match(balance_from_trans$account, balance$account)
#So
transactions[is.na(transactions)] = 0

#alternatively
transactions = na.omit(transactions,na.action=TRUE)
#Data reduction 
reduced_trans = transactions[,-c(1,2)]
#Outliers (projection)
boxplot(reduced_trans)
plot(reduced_trans[,2])
plot(reduced_trans[,3])
plot(reduced_trans[,5])
plot(reduced_trans[,6]) #reduced_trans[,7] > 15
plot(reduced_trans[,7]) #reduced_trans[,7] > 10

outlierReplace = function(dataframe, cols, rows, newValue = NA) {
  if (any(rows)) {
    set(dataframe, rows, cols, newValue)
  }
}

outlierReplace(reduced_trans, "count_deposits", which(reduced_trans$count_deposits > 15), 10)
outlierReplace(reduced_trans, "count_withdrawals", which(reduced_trans$count_withdrawals > 10), 10)

#scaling
reduced_trans = scale(reduced_trans)

#Choosing the data mining task
wss = (nrow(reduced_trans) - 1) * sum(apply(reduced_trans,2,var))

