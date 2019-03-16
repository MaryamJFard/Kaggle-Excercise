library(nycflights13)
library(Lahman)

# Filter
jan1 <- filter(flights, month == 1, day == 1)

novDes <- filter(flights, month == 11 | month == 12)
novDes <- filter(flights, month %in% c(11, 12))

delayLess2 <- filter(flights, dep_delay <= 120 | arr_delay <= 120)

arr_delayMore2 <- filter(flights, arr_delay >= 120)

flyToHuston <- filter(flights, dest %in% c("IAH", "HOU"))

operator <- filter(flights, carrier %in% c("UA", "DL"))

summerDept <- filter(flights, month %in% c(7, 8, 9))

onlyArrLate <- filter(flights, arr_delay > 2 & dep_delay ==0)

delayMore1 <- filter(flights, dep_delay >= 60 & hour * 60 + minute > 30)

depNight <- filter(flights, dep_time >= 0 & dep_time <= 600)
depNight <- filter(flights, between(dep_time, 0, 600))

missingDepTime <- filter(flights, is.na(dep_time))

# Arrange
reorder <- arrange(flights, year, month, day)

reorder <- arrange(flights, desc(arr_delay))

df <- tibble(x = c(5, 2, NA))
reorder <- arrange(df, x)
reorder <- arrange(df, !is.na(x))
reorder <- arrange(df, desc(is.na(x)))

reorder <- arrange(flights, desc(dep_delay))
reorder <- arrange(flights, dep_delay)

reorder <- arrange(flights, hour * 60 + minute)
reorder <- arrange(flights, desc(hour * 60 + minute))

# Select
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

copy <- flights
select(copy, tail_num = tailnum)
rename(copy, tail_num = tailnum)

select(flights, time_hour, air_time, everything())

select(flights, dep_time, dep_delay, arr_time, arr_delay)
var <- c("dep_time", "dep_delay", "arr_time", "arr_delay")
select(flights, one_of(var))
select(flights, dep_time, dep_delay:arr_delay, -(sched_arr_time))
select(flights, dep_time:arr_delay, -c(sched_dep_time, sched_arr_time))
select(flights, -c(year, month, day, sched_dep_time, sched_arr_time, carrier, flight, tailnum, origin, dest, air_time, distance, hour, minute, time_hour))
select(flights, dep_time:arr_delay, -contains("sched"))

select(flights, dep_time, dep_time)

select(flights, contains("TIME"))
select(flights, contains("TIME", ignore.case = F))

# Mutate
flightSml <- select(flights, year:day, ends_with("delay"), distance, air_time)
mutate(flightSml, gain = arr_delay - dep_delay, speed = distance/ air_time * 60)

mutate(flightSml, gain = arr_delay - dep_delay, hours = air_time / 60, gainPerHour = gain / hours)

transmute(flights, gain = arr_delay - dep_delay, hours = air_time / 60, gainPerHour = gain / hours)

(x <- 1:10)
lead(x)
lag(x)
cumsum(x)
cumprod(x)
cummean(x)

y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

flightSml <- select(flights, year:day, dep_time, flight)
mutate(flightSml, dep_time_inMinutes = (dep_time %/% (10 ^ floor(log10(dep_time)))) * 60 + (dep_time %% (10 ^ floor(log10(dep_time)))))

1:3 + 1:10
1:3 + 1:9 

arrange(flights, desc(dep_delay))

arrange(flights[which(min_rank(desc(flights$dep_delay)) %in% 1:10), ], desc(dep_delay))

# Summarize
by_day <- group_by(flights, year, month, day)
summarize(by_day, delay = mean(dep_delay, na.rm = T))

by_delay = group_by(flights, dest)
delay <- summarize(by_delay, count = n(), dist = mean(distance, na.rm = T), delay = mean(arr_delay, na.rm = T))
delay <- filter(delay, count > 20, dest != "HNL")

delay <- flights %>% group_by(dest) %>% summarize(count = n(), dist = mean(distance, na.rm = T), delay = mean(arr_delay, na.rm = T))
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(mapping = aes(size = count), alpha = 1/3) +
  geom_smooth(se = F)

not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))
delayByPlain <- not_cancelled %>% group_by(tailnum) %>% summarise(count = n(), aveDelay = mean(arr_delay, na.rm = T)) %>% arrange(desc(aveDelay)) 
ggplot(data = delayByPlain, mapping = aes(x = aveDelay)) + 
  geom_freqpoly(binwidth = 10)
ggplot(data = delayByPlain, mapping = aes(x = count, y = aveDelay)) +
  geom_point(alpha = 1/3)

delayByPlain %>% 
  filter(count >25) %>%
  ggplot(mapping = aes(x = count, y = aveDelay)) +
  geom_point(alpha = 1/10)

not_cancelled %>% group_by(year, month, day) %>% summarise(first = min(dep_time), last = max(dep_time))
not_cancelled %>% group_by(year, month, day) %>% summarise(first = first(dep_time), last = last(dep_time))
not_cancelled %>%
  group_by(year, month, day) %>%
  mutate(r = min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))

not_cancelled %>%
  group_by(dest) %>%
  summarize(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

not_cancelled %>% 
  count(dest)
not_cancelled %>% 
  count(dest, sort = T)
not_cancelled %>% 
  group_by(dest) %>% 
  summarize(n())

not_cancelled %>% 
  count(tailnum, wt = distance)
not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(sum(distance))
  
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarize(nOfEarlyFlights = sum(dep_time < 500))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarize(propOfFlights = mean(dep_delay > 60))

daily <- group_by(flights, year, month, day)
(per_day <- summarize(daily, flights = n()))
(per_month <- summarize(per_day, flights = sum(flights)))
(per_year <- summarize(per_month, flights = sum(flights)))

(dailyCancelled <- 
  flights %>% 
  group_by(year, month, day)) %>% 
  summarize(prop = mean(is.na(dep_time) & is.na(arr_time)), aveDelay = mean(dep_delay, na.rm = T)) %>% 
  ggplot(mapping = aes(x = prop, y = aveDelay)) +
  geom_point(alpha = 1/10) +
  geom_smooth(se = F)
  
flights %>% 
  group_by(carrier) %>% 
  summarise(delay = mean(arr_delay, na.rm = T)) %>% 
  arrange(desc(delay))
  
flights %>%
  filter(!is.na(arr_delay)) %>%
  # Total delay by carrier within each origin, dest
  group_by(origin, dest, carrier) %>%
  summarise(
    arr_delay = sum(arr_delay),
    flights = n()
  ) %>%
  # Total delay within each origin dest
  group_by(origin, dest) %>%
  mutate(
    arr_delay_total = sum(arr_delay),
    flights_total = sum(flights)
  ) %>%
  # average delay of each carrier - average delay of other carriers
  ungroup() %>%
  mutate(
    arr_delay_others = (arr_delay_total - arr_delay) /
      (flights_total - flights),
    arr_delay_mean = arr_delay / flights,
    arr_delay_diff = arr_delay_mean - arr_delay_others
  ) %>%
  # remove NaN values (when there is only one carrier)
  filter(is.finite(arr_delay_diff)) %>%
  # average over all airports it flies to
  group_by(carrier) %>%
  summarise(arr_delay_diff = mean(arr_delay_diff)) %>%
  arrange(desc(arr_delay_diff)) 

flights %>% 
  group_by(tailnum) %>% 
  arrange(arr_delay) %>% 
  filter(arr_delay < 60) %>% 
  summarise(count = n())

daily %>% 
  ungroup() %>% 
  summarise(flights = n())

not_cancelled %>% 
  group_by(flight) %>% 
  summarise(fifEarly = sum(dep_delay == -15) / n(), fifLate = sum(dep_delay == 15) / n()) %>% 
  filter(fifEarly == 0.5 | fifLate == 0.5)

not_cancelled %>% 
  group_by(flight) %>% 
  summarise(fifEarly = mean(dep_delay == -15), fifLate = mean(dep_delay == 15)) %>% 
  filter(fifEarly == 0.5 | fifLate == 0.5)

(temp <- not_cancelled %>% 
  group_by(flight, dep_delay) %>% 
  summarise(count = n()))
temp %>% 
  mutate(flightsPerGroup = sum(count)) %>% 
  filter((dep_delay == -15 | dep_delay == 15)) %>% 
  mutate(prop = count/flightsPerGroup) %>% 
  filter(prop == 0.5)

not_cancelled %>% 
  group_by(flight) %>% 
  summarise(fifLate = mean(dep_delay == 10)) %>% 
  filter(fifLate == 1)  

(popular_dests <- flights %>%
  group_by(dest) %>%
  filter(n() > 365))

flightSml %>% 
  group_by(year, month, day) %>% 
  filter(rank(desc(arr_delay)) <  10)

flights %>% 
  arrange(desc(arr_delay)) %>% 
  head(1)
flights %>% 
  group_by(tailnum) %>% 
  summarise(delayForPlane = sum(arr_delay)) %>% 
  filter(min_rank(desc(delayForPlane)) == 1)

dayPartFun <- function(x){
  if(600 <= x & x < 1200)
    return("MorNoon")
  else if(1200 <= x & x < 1800)
    return("NoonANoon")
  else if(1800 <= x & x < 2400)
    return("ANoonNi")
  else if(0 <= x & x < 600)
    return("NiMor")
}
not_cancelled %>% 
  mutate(dayPart = sapply(sched_dep_time, dayPartFun)) %>% 
  group_by(dayPart) %>% 
  summarise(ave_dep_delay = mean(dep_delay, na.rm = T)) 
not_cancelled %>% 
  mutate(dayPart = sapply(sched_dep_time, dayPartFun)) %>%
  ggplot(mapping = aes(x = dep_delay, y = arr_delay)) +
  geom_point(mapping = aes(color = dayPart), alpha = 1/5) +
  geom_smooth(se = F)

Batting <- as_tibble(Batting)
batters <- Batting %>% 
  group_by(playerID) %>% 
  summarize(ba = sum(H, na.rm = T)/sum(AB), ab = sum(AB, na.rm = T))
batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point(alpha = 1/3) +
  geom_smooth(se = F)
batters %>% arrange(desc(ba))

