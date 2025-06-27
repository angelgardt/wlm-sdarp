library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")

## cover percentage
n_sim <- 1000
n_sample <- 100
mu <- 0
sd <- 1
set.seed(123)
replicate(n_sim,
          mean_cl_normal(rnorm(n = n_sample,
                               mean = mu,
                               sd = sd)),
          simplify = FALSE) %>%
    bind_rows() %>%
    mutate(sim = 1:n_sim,
           cover = ifelse(ymin < mu & mu < ymax, TRUE, FALSE)) -> ci_cover

ci_cover %>% pull(cover) %>% mean()
ci_cover %>%
    ggplot(aes(x = sim)) +
    geom_point(aes(y = y, color = cover)) +
    geom_errorbar(aes(ymin = ymin, ymax = ymax, color = cover)) +
    #geom_pointrange(aes(x = sim, y = y, ymin = ymin, ymax = ymax, color = cover)) +
    geom_hline(yintercept = mu, linetype = "dashed")


## capture percentage
n_sim <- 1000
n_sample <- 100
mu <- 0
sd <- 1
set.seed(123)
replicate(n_sim,
          mean_cl_normal(rnorm(n = n_sample,
                               mean = mu,
                               sd = sd)),
          simplify = FALSE) %>%
    bind_rows() %>%
    mutate(sim = 0:(n_sim-1),
           captured = ifelse(ymin[1] < y & y < ymax[1], TRUE, FALSE)) -> ci_capture
ci_capture %>% filter(sim != 0) %>% pull(captured) %>% mean()
ci_capture %>%
    filter(sim != 0) %>%
    ggplot(aes(x = sim)) +
    geom_point(aes(y = y, color = captured)) +
    geom_errorbar(aes(ymin = ymin, ymax = ymax, color = captured)) +
    geom_hline(data = ci_capture %>%
                   filter(sim == 0) %>%
                   pivot_longer(cols = c(ymin, ymax)),
               aes(yintercept = value))
