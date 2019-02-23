install.packages("RSQLite")
library(RSQLite)

#Connect to DB
sqlite.driver <- dbDriver("SQLite")
con = dbConnect(drv=sqlite.driver, dbname="DB.db")

#Retrieve tables
alltables = dbListTables(con)

#Create a dataframe corresponding to each table
clients = dbGetQuery( con,'select * from clients' )
transactions = dbGetQuery( con,'select * from transactions' )
campaigns = dbGetQuery( con,'select * from campaigns' )


