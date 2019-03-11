install.packages("tidyverse")
library(tidyverse)

data(mpg)
data(diamonds)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cyl, y = hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = class, y = hwy))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))+
  facet_wrap(~displ)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = hwy)) +
  facet_grid(drv ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))+
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv, linetype = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point()+
  geom_smooth(mapping = aes(linetype = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv))+
  geom_smooth(mapping = aes())

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(data = filter(mpg, class == "subcompact"), se = F)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color= drv)) +
  geom_point() +
  geom_smooth(se = F)

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(aes(group = drv), se = F)

ggplot(data = mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth()

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth()

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth(aes(linetype = drv))

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, y = ..prop.., group = 1)
  )

ggplot(data = diamonds) +
  stat_summary(mapping = aes(x = cut, y = depth), fun.y = median, fun.ymax = max, fun.ymin = min)

ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, y = depth)
  )

summary_diamonds = diamonds %>% 
  group_by(cut) %>% 
  summarise(lower = min(depth), upper = max(depth), p = median(depth))
ggplot(data = summary_diamonds, mapping = aes(x = cut, y = p)) +
  geom_pointrange(mapping = aes(ymin = lower, ymax = upper))

min = aggregate(diamonds[, c(5)], by = list(diamonds$cut), FUN = min)
max = aggregate(diamonds[, c(5)], by = list(diamonds$cut), FUN = max)
median = aggregate(diamonds[, c(5)], by = list(diamonds$cut), FUN = median)
df = data.frame(min, median$depth, max$depth)
names(df) = c('cut', 'min', 'median', 'max')
ggplot(data = df, mapping = aes(x = cut, y= median)) +
  geom_pointrange(mapping = aes(ymin = min, ymax = max))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, color = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar( alpha = 1/5, position = "identity")

ggplot(data = diamonds, mapping = aes(x = cut, color = clarity)) +
  geom_bar(fill = NA, position = "identity")

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill")

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge")

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point(position = "jitter")

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()

chart = ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut), show.legend = FALSE, width = 1
  ) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL) 
chart + coord_flip()
chart + coord_polar()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed()
  
