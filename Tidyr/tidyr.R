# Each row represents an observation 
# Each column contains the value for that variable
table1 <- tibble(country = c('Afghanistan', 'Afghanistan', 'Brazil', 'Brazil', 'China', 'China'),
       year = c(1999, 2000, 1999, 2000, 1999, 2000),
       cases = c(745, 2666, 37737, 80488, 212258, 213766),
       population = c(19987071, 20595360, 172006362, 174504898, 1272915272, 1280428583)
       )
# Each row represents an observation
# Column count contains the value for both case and population
table2 <- tibble(country = c('Afghanistan', 'Afghanistan', 'Afghanistan', 'Afghanistan', 'Brazil', 'Brazil', 'Brazil', 'Brazil', 'China', 'China', 'China', 'China'),
                 year = c(1999, 1999, 2000, 2000, 1999, 1999, 2000, 2000, 1999, 1999, 2000, 2000),
                 type = c('cases', 'population', 'cases', 'population','cases', 'population', 'cases', 'population', 'cases', 'population', 'cases', 'population'),
                 count = c(745, 19987071, 2666, 20595360, 37737, 37737, 80488, 174504898, 212258, 1272915272, 213766, 1280428583))

# Each row represents an observation
# column rate provides the values of both `cases` and `population` in a string formatted like `cases / population`
table3 <- tibble(country = c('Afghanistan', 'Afghanistan', 'Brazil', 'Brazil', 'China', 'China'),
                 year = c(1999, 2000, 1999, 2000, 1999, 2000),
                  rate = c('745/19987071', '2666/20595360', '37737/172006362', '80488/174504898', '212258/1272915272', '213766/1280428583'))

# Table 4 is split into two tables, table4a for cases and table4b for population
# Each row represents an observation
# Within each table, each row represents a country, each column represents a year, and the cells are the value of the table's variable for that country and year. 
table4a <- tibble(country = c('Afghanistan', 'Brazil', 'China'), '1999' = c(745, 37737, 212258), '2000' = c(2666, 80488, 213766))
table4b <- tibble(country = c('Afghanistan', 'Brazil', 'China'), '1999' = c(19987071, 172006362, 1272915272), '2000' = c(20595360, 174504898, 1280428583))

# Qestion2
(t2_cases <- table2 %>% 
  filter(type == 'cases') %>% 
  rename(cases = count) %>% 
  arrange(country, year))
(t2_population <- table2 %>% 
  filter(type == 'population') %>% 
  rename(population = count) %>% 
  arrange(country, year))
newTable2 <- tibble(
  year = t2_cases$year,
  country = t2_cases$country,
  cases = t2_cases$cases,
  population = t2_population$population
) %>% 
  mutate(rate = (cases / population) * 10000) %>% 
  select(country, year, rate)

table4c <- tibble(
  year = table4a$country,
  '1999' = table4a[['1999']] / table4b[['1999']] * 10000,
  '2000' = table4a[['2000']] / table4b[['2000']] * 10000
)