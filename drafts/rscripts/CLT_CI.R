library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")

# rbeta(n = 50, shape1 = 1, shape = 4) %>% hist()

set.seed(999)
n_samples <- 10000
sample_size <- 500
shape1 <- 1
shape2 <- 4
mu <- shape1 / (shape1 + shape2)
var <- (shape1 * shape2) / ((shape1 + shape2)^2 *(shape1 + shape2 + 1))

rbeta(n = n_samples * sample_size, 
      shape1 = shape1, 
      shape2 = shape2) %>% 
  matrix(nrow = sample_size, ncol = n_samples) %>% 
  apply(2, mean) -> means

ggplot(NULL) +
  geom_histogram(aes(means, y = after_stat(density)), fill = "gray70") +
  geom_function(fun = dnorm, args = list(mean = mu, sd = sqrt(var / sample_size)),
                linewidth = 2) +
  # geom_function(fun = dnorm, args = list(mean = mu, sd = sqrt(var / sample_size)/2),
  #               linewidth = 2, color = "blue") +
  labs(x = "Выборочные средние", y = "Количество")



set.seed(123)
mu <- 6
sd <- 3
n_samples <- 1000
sample_size <- 500

rnorm(n = n_samples * sample_size, mean = mu, sd = sd) %>% 
  matrix(nrow = sample_size, ncol = n_samples) %>% 
  as_tibble() %>% 
  pivot_longer(cols = everything()) %>% 
  summarise(mean_cl_normal(value),
            .by = name) %>%
  mutate(cover = ifelse(ymin < mu & ymax > mu, TRUE, FALSE)) %>% 
  ggplot() +
  geom_pointrange(aes(x = name, y = y,
                      ymin = ymin, ymax = ymax,
                      color = cover)) +
  geom_hline(yintercept = mu) +
  labs(x = "Номер выборки")

set.seed(123)
rnorm(n = n_samples * sample_size, mean = mu, sd = sd) %>% 
  matrix(nrow = sample_size, ncol = n_samples) %>% 
  as_tibble() %>% 
  pivot_longer(cols = everything()) %>% 
  summarise(mean_cl_normal(value),
            .by = name) %>% 
  mutate(cover = ifelse(ymin < mu & ymax > mu, TRUE, FALSE)) %>% 
  pull(cover) %>% mean()
