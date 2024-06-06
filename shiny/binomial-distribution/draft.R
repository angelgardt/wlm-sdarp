library(tidyverse)
theme_set(theme_bw())

n = 30
p = .1
k = 10
lambda = n * p

tibble(n_ = 1:n,
       p_ = dbinom(n_, n, p)) %>% 
  ggplot(aes(n_, p_)) +
  geom_point() +
  geom_function(fun = dnorm, 
                args = list(mean = n*p, 
                            sd = sqrt(n * p * (1 - p))))

tibble(n_ = 1:n,
       p_ = dbinom(n_, n, p)) %>% 
  ggplot(aes(n_, p_)) +
  geom_point() +
  geom_function(fun = dpois, 
                args = list(lambda = lambda))

dpois(1:n, lambda)
