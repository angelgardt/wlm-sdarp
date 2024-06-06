library(tidyverse)
theme_set(theme_bw())

n = 5
p = .4
lambda = n * p

tibble(n_ = 1:n,
       p_ = dbinom(n_, n, p),
       p_pois = dpois(n_, lambda)) %>% 
  ggplot(aes(x = n_)) +
  geom_point(aes(y = p_)) +
  geom_point(aes(y = p_pois), color = "gray")
  # stat_function(geom = "point",
  #               color = "gray",
  #               fun = dpois, 
  #               args = list(lambda = lambda))


tibble(n_ = 1:n,
       p_ = dbinom(n_, n, p)) %>% 
  ggplot(aes(n_, p_)) +
  geom_point() +
  geom_function(fun = dnorm, 
                args = list(mean = n*p, 
                            sd = sqrt(n * p * (1 - p))))
