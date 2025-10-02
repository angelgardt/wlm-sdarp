library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")

## cover percentage -----
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



set.seed(404)
seeds <- runif(100, 0, 10^6)
map(seeds,
    function(seed) {
        set.seed(seed)
        replicate(n_sim,
                  mean_cl_normal(rnorm(n = n_sample,
                                       mean = mu,
                                       sd = sd)),
                  simplify = FALSE) %>%
            bind_rows() %>%
            mutate(cover = ifelse(ymin < mu & mu < ymax, TRUE, FALSE))
    }
) %>% map(
    function(x) {x %>% pull(cover) %>% mean()}
) %>% unlist() -> ci_covers

mean(ci_covers)
median(ci_covers)
ggplot(NULL) +
    geom_histogram(aes(x = ci_covers)) +
    geom_vline(xintercept = mean(ci_covers))





### capture percentage -----
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



set.seed(404)
seeds <- runif(100, 0, 10^6)
map(seeds,
    function(seed) {
        set.seed(seed)
        replicate(n_sim,
                  mean_cl_normal(rnorm(n = n_sample,
                                       mean = mu,
                                       sd = sd)),
                  simplify = FALSE) %>%
            bind_rows() %>%
            mutate(sim = 0:(n_sim-1),
                   captured = ifelse(ymin[1] < y & y < ymax[1], TRUE, FALSE))
    }
) %>% map(
    function(x) {x %>% pull(captured) %>% mean()}
) %>% unlist() -> ci_captures

mean(ci_captures)
median(ci_captures)

ggplot(NULL) +
    geom_histogram(aes(x = ci_captures)) +
    geom_vline(xintercept = mean(ci_captures))


### confidence interval & p-value -----

set.seed(123)
sample <- rnorm(n = 100, mean = 0, sd = 1)
bins <- 50
ci <- mean_cl_normal(sample)
tibble(
    hat_thetas = c(
        seq(from = ci$ymin - (ci$y - ci$ymin),
            to = ci$ymin,
            length.out = bins),
        seq(from = ci$ymin,
            to = ci$y,
            length.out = bins),
        seq(from = ci$y,
            to = ci$ymax,
            length.out = bins),
        seq(from = ci$y,
            to = ci$ymax + (ci$ymax - ci$y),
            length.out = bins)
        ),
    pvals = map(hat_thetas,
                function(x) {t.test(x = sample, mu = x)$p.value}) %>%
        unlist()
) %>%
    ggplot(aes(hat_thetas, pvals)) +
    geom_line() +
    geom_vline(xintercept = c(ci$ymin, ci$ymax), linetype = "dashed") +
    geom_hline(yintercept = .05, linetype = "dotted") +
    geom_pointrange(data = ci,
                    aes(y = 0, x = y, xmin = ymin, xmax = ymax))

