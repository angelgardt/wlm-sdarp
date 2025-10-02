library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")

alpha <- 0.05
n_samples <- 10000
# sample_size <- 300

### norm & right asymm ----
# r.beta <- function(n, shape1, shape2, mean = 0, sd = 1) {
#     rbeta(n, shape1, shape2) %>% scale() %>% `+`(mean) %>% `*`(sd)
# }

# mu <- 0
# sd <- 1
shape1 <- 7
shape2 <- 2
mu_asym <- shape1 / (shape1 + shape2)
sd_asym <- sqrt((shape1 * shape2) / ((shape1 + shape2)^2 * (shape1 + shape2 + 1)))
sample.size <- 50

ggplot() +
    geom_function(fun = dbeta, args = list(shape1 = shape1, shape2 = shape2)) +
    geom_function(fun = dnorm, args = list(mean = mu_asym, sd = sd_asym)) +
    xlim(-.5, 1)


set.seed(919)
replicate(n_samples,
          t.test(
              rnorm(n = sample.size, mean = mu_asym, sd = sd_asym),
              rbeta(n = sample.size, shape1 = shape1, shape2 = shape2)
              )$p.value,
          simplify = TRUE
          ) %>%
    as_tibble() %>%
    mutate(is_sig = value < alpha) %>% pull(is_sig) %>% mean()






