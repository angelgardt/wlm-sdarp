library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")

set.seed(986)

n_samples <- 1000
sample_size <- 200
mu <- 0
sigma <- 1

sample0 <- rnorm(sample_size, mean = mu, sd = sigma)
CI0 <- mean_cl_normal(sample0)

rnorm(n_samples * sample_size, mean = mu, sd = sigma) %>%
    matrix(nrow = sample_size) %>%
    as_tibble() %>%
    pivot_longer(cols = everything()) %>%
    summarise(mean_cl_normal(value),
              .by = name) %>%
    mutate(cover = ifelse(ymin < mu & mu < ymax, TRUE, FALSE),
           capture = ifelse(CI0$ymin < y & y < CI0$ymax, TRUE, FALSE)) -> sim

sim %>% pull(cover) %>% mean()
sim %>% pull(capture) %>% mean()

sim %>%
    ggplot() +
    geom_pointrange(aes(y = name, x = y,
                        xmin = ymin, xmax = ymax,
                        color = cover)) +
    geom_pointrange(data = NULL,
                    aes(y = "V0", x = CI0$y,
                        xmin = CI0$ymin, xmax = CI0$ymax)) +
    geom_vline(xintercept = mu)

sim %>%
    ggplot() +
    geom_pointrange(aes(y = name, x = y,
                        xmin = ymin, xmax = ymax,
                        color = capture)) +
    geom_pointrange(data = NULL,
                    aes(y = "V0", x = CI0$y,
                        xmin = CI0$ymin, xmax = CI0$ymax)) +
    geom_vline(xintercept = c(CI0$ymin, CI0$ymax),
               linetype = "dotted")

sim %>%
    ggplot() +
    geom_histogram(aes(x = y, y = after_stat(density))) +
    geom_function(fun = dnorm,
                  args = list(mean = mu, sd = sigma / sqrt(sample_size)),
                  linewidth = 1)

