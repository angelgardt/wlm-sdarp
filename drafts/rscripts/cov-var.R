library(tidyverse)
theme_set(theme_bw())

n <- 100

set.seed(404)
tibble(
  x1 = rnorm(n, sd = 1),
  cov1 = 0.4 * x1 + rnorm(n, mean = 2, sd = 1 - 0.4^2),
  x2 = rnorm(n, sd = 2),
  cov2 = 0.4 * x2 + rnorm(n, mean = 2, sd = 2 - 2 * 0.4^2),
  x3 = rnorm(n, sd = 2),
  cov3 = -0.8 * x3 + rnorm(n, mean = 2, sd = 2 - 2 * 0.8^2),
  x4 = rnorm(n, sd = 4),
  cov4 = -0.8 * x3 + rnorm(n, mean = 4, sd = 4 - 4 * 0.8^2)
) -> ds


ds %>% 
  ggplot(aes(x1, cov1)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

ds %>% 
  ggplot(aes(x2, cov2)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

ds %>% 
  ggplot(aes(x3, cov3)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

ds %>% 
  ggplot(aes(x4, cov4)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)
