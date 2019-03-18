library("tidyverse")
library("gridExtra")
library("ggstance")
library("lvplot")
library("ggbeeswarm")
library("nycflights13")
library("viridis")
library("hexbin")
data(diamonds)
data(mpg)

# Examine the distribution of Diamonds' cut
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
table(diamonds$cut)
prop.table(table(diamonds$cut))
diamonds %>% 
  group_by(cut) %>% 
  summarise(n())
diamonds %>% 
  count(cut)

# Examine the distribution of Diamonds' carat
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
diamonds %>% 
count(cut_width(carat, 0.5))

diamonds %>% 
  filter(carat < 3) %>% 
  ggplot() +
  geom_histogram(mapping = aes(x = carat, color = cut, fill = cut), binwidth = 0.1)
diamonds %>% 
  filter(carat < 3) %>% 
  ggplot() +
  geom_freqpoly(mapping = aes(x = carat, color = cut), binwidth = 0.1)

# Examine the distribution of Faithful eruptions
ggplot(data = faithful) +
  geom_histogram(mapping = aes(x = eruptions), binwidth = 0.5)
faithful %>% 
  count(cut_width(eruptions, 0.5))

# Examine the distribution of Diamonds x, y and z variables
g1 <- diamonds %>% 
  ggplot() +
  geom_histogram(mapping = aes(x = x), binwidth = 0.5)
g2 <- diamonds %>% 
  ggplot() +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
g3 <- diamonds %>% 
  ggplot() +
  geom_histogram(mapping = aes(x = z), binwidth = 0.5)
grid.arrange(g1, g2, g3, nrow = 1, ncol = 3)
diamonds %>% 
  ggplot() +
  geom_point(mapping = aes(x = x, y = y)) +
  geom_abline() +
  coord_fixed()
diamonds %>%
  mutate(id = row_number()) %>%
  select(x, y, z, id) %>%
  gather("variable", "value", -id) %>%
  ggplot(aes(x = value)) +
  geom_density() +
  geom_rug() +
  facet_grid(variable ~ .)

# Compare the scheduled departure times for cancelled
# and noncancelled times
flights %>% 
  mutate(
    cancelled = is.na(dep_time), 
    sched_hour = sched_dep_time %/% 100, 
    sched_min = sched_dep_time %% 100, 
    sched_dep_time = sched_hour + sched_min / 60
    ) %>% 
  ggplot() + 
  geom_freqpoly(
    mapping = aes(x = sched_dep_time, color = cancelled),
    binwidth = 1/4
    )
flights %>% 
  mutate(
    cancelled = is.na(dep_time), 
    sched_hour = sched_dep_time %/% 100, 
    sched_min = sched_dep_time %% 100, 
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot() + 
  geom_freqpoly(
    mapping = aes(x = sched_dep_time, y = ..density.., color = cancelled),
    binwidth = 1/2
  )

# Show the relationship between Diamonds' price and cut
ggplot(
  data = diamonds,
  mapping = aes(x = price, y = ..density..)
) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

# How highway mileadge varies across classes
mpg %>% 
  ggplot() +
  geom_boxplot(
    mapping = aes(
      x = reorder(class, hwy, FUN = median),
      y = hwy)
  )

# What variable in the diamonds dataset is most important for predicting the price of a diamond?
display(lm(price~., diamonds), detail = T)
diamonds %>% 
  ggplot() +
  geom_freqpoly(mapping = aes(x = carat, y = ..density.., color = cut), binwidth = 0.5)
diamonds %>% 
  ggplot() +
  geom_boxplot(mapping = aes(x = reorder(cut, carat, FUN = median), y = carat))
diamonds %>%
  group_by(cut) %>%
  summarise(cor(carat, price))

# Horizontal box plot
mpg %>% 
  ggplot() +
  geom_boxploth(mapping = aes(x = hwy, y = class))
mpg %>% 
  ggplot() +
  geom_boxplot(mapping = aes(x = class, y = hwy)) +
  coord_flip()

# display the distribution of price versus cut using geom_lv
diamonds %>% 
  ggplot() +
  geom_lv(mapping = aes(x = cut, y = price, color = ..LV.., fill = ..LV..))

# Compare and contrast
diamonds %>%
  ggplot(aes(cut, price)) +
  geom_violin()
diamonds %>%
  ggplot(aes(price)) +
  geom_histogram() +
  facet_wrap(~ cut, scale = "free_y", nrow = 1)
diamonds %>% 
  ggplot(aes(x = price)) +
  geom_freqpoly(mapping = aes(color = cut))

# Visualize the covariation between cut and color
diamonds %>% 
  ggplot() +
  geom_count(mapping = aes(x = cut, y = color))
diamonds %>% 
  count(color, cut) %>% 
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))
diamonds %>% 
  count(color, cut) %>% 
  group_by(color) %>% 
  mutate(perc = n/sum(n)) %>% 
  ggplot(mapping = aes(x = color, y = cut, fill = perc)) +
  geom_tile()

# Explore how average flight delays vary by destination and month of year
not_cancelled %>% 
  ggplot(mapping = aes(x = factor(month), y = dest, fill = dep_delay)) +
  geom_tile()
flights %>%
  mutate(total_delay = dep_delay + arr_delay) %>%
  filter(total_delay > 0) %>%
  group_by(dest, month) %>%
  summarize(del_average = mean(total_delay, na.rm = T)) %>%
  filter(n() == 12) %>%
  ungroup() %>%
  ggplot(aes(x = factor(month), y = reorder(dest, del_average, FUN = mean), fill = del_average)) +
  geom_tile() +
  scale_fill_viridis()

# Covariation between price and carat
ggplot(data = diamonds) +
  geom_bin2d(mapping = aes(x = carat, y = price))
ggplot(data = diamonds) +
  geom_hex(mapping = aes(x = carat, y = price))
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = carat, y = price, group = cut_width(carat, 0.1)))
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = carat, y = price, group = cut_number(carat, 20)))