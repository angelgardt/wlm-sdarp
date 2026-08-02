library(tidyverse)
theme_set(theme_bw())

set.seed(123)
x <- runif(n = 100, min = 0, max = 10)
y <- 10 + 2 * x + 5 * x^3 + rnorm(n = 100, sd = 200)

ggplot(data = NULL,
       aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm")


x_rank <- rank(x)
y_rank <- rank(y)

ggplot(data = NULL,
       aes(x = x_rank, y = y_rank)) +
  geom_point() +
  geom_smooth(method = "lm")
