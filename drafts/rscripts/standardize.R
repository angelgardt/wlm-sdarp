library(tidyverse)
theme_set(theme_bw())

## free
set.seed(65)
tibble(x = c(rnorm(80, 1.5, 0.3), rnorm(40, 3.4, 0.5), rbeta(50, 2, 4)),
       x_cent = scale(x, center = TRUE, scale = FALSE),
       x_norm = scale(x, center = FALSE, scale = TRUE),
       x_stand = scale(x, center = TRUE, scale = TRUE)) %>% 
  ggplot(aes(x)) +
  # geom_histogram(aes(y = after_stat(density))) +
  stat_function(fun = dnorm, linetype = "dashed") +
  geom_density(aes(x), color = "blue") +
  geom_density(aes(x_cent), color = "orange") +
  geom_density(aes(x_norm), color = "green") +
  geom_density(aes(x_stand), color = "red")

## bimodal
set.seed(65)
tibble(x = c(rnorm(80, 1.5, 0.4), rnorm(40, 4, 0.5)),
       x_cent = scale(x, center = TRUE, scale = FALSE),
       x_norm = scale(x, center = FALSE, scale = TRUE),
       x_stand = scale(x, center = TRUE, scale = TRUE)) |> 
  ggplot() +
  stat_function(fun = dnorm, linetype = "dashed") +
  geom_density(aes(x), color = "blue") +
  geom_density(aes(x_cent), color = "orange") +
  geom_density(aes(x_norm), color = "green") +
  geom_density(aes(x_stand), color = "red")


## negasymm

ggplot(NULL) +
  stat_function(fun = dbeta, args = list(shape1 = 7, shape2 = 2))
# mean = alpha / (alpha + beta)
# var = (alpha*beta) / ((alpha + beta)^2 * (alpha + beta + 1))

set.seed(120)
tibble(x = c(rbeta(100, 5, 3)),
       x_cent = scale(x, center = TRUE, scale = FALSE),
       x_norm = scale(x, center = FALSE, scale = TRUE),
       x_stand = scale(x, center = TRUE, scale = TRUE)) |> 
  ggplot() +
  stat_function(fun = dnorm, linetype = "dashed") +
  geom_density(aes(x), color = "blue") +
  geom_density(aes(x_cent), color = "orange") +
  geom_density(aes(x_norm), color = "green") +
  geom_density(aes(x_stand), color = "red")




## posasymm

ggplot(NULL) +
  stat_function(fun = dgamma, args = list(shape = 2, rate = 3))

# tibble(x = seq(0, 5, by = .001),
#        y = dgamma(x, 2, 2)) -> median_rightskew_data