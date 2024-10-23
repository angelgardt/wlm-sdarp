library(tidyverse)
theme_set(theme_bw())

# n <- 1000
# set.seed(616)
# tibble(
#   x = rnorm(n),
#   y = rnorm(n),
#   cor_0 = y,
#   cor_m1 = -x,
#   cor_m09 = -.9 * sd(y) / sd(x) * x + y,
#   cor_m08 = -.8 * sd(y) / sd(x)  * x + y,
#   cor_m07 = -.7 * sd(y) / sd(x) * x + y,
#   cor_m06 = -.6 * sd(y) / sd(x) * x + y,
#   cor_m05 = -.5 * sd(y) / sd(x) * x + y,
#   cor_m04 = -.4 * sd(y) / sd(x) * x + y,
#   cor_m03 = -.3 * sd(y) / sd(x) * x + y,
#   cor_m02 = -.2 * sd(y) / sd(x) * x + y,
#   cor_m01 = -.1 * sd(y) / sd(x) * x + y,
#   cor_p01 = .1 * sd(y) / sd(x) * x + y,
#   cor_p02 = .2 * sd(y) / sd(x) * x + y,
#   cor_p03 = .3 * sd(y) / sd(x) * x + y,
#   cor_p04 = .4 * sd(y) / sd(x) * x + y,
#   cor_p05 = .5 * sd(y) / sd(x) * x + y,
#   cor_p06 = .6 * sd(y) / sd(x) * x + y,
#   cor_p07 = .7 * sd(y) / sd(x) * x + y,
#   cor_p08 = .8 * sd(y) / sd(x) * x + y,
#   cor_p09 = .9 * sd(y) / sd(x) * x + y,
#   cor_p1 = x,
#   cor2_m1 = -x,
#   cor2_m09 = -.9 * x,
#   cor2_m08 = -.8 * x,
#   cor2_m07 = -.7 * x,
#   cor2_m06 = -.6 * x,
#   cor2_m05 = -.5 * x,
#   cor2_m04 = -.4 * x,
#   cor2_m03 = -.3 * x,
#   cor2_m02 = -.2 * x,
#   cor2_m01 = -.1 * x,
#   cor2_0 = 0,
#   cor2_p01 = .1 * x,
#   cor2_p02 = .2 * x,
#   cor2_p03 = .3 * x,
#   cor2_p04 = .4 * x,
#   cor2_p05 = .5 * x,
#   cor2_p06 = .6 * x,
#   cor2_p07 = .7 * x,
#   cor2_p08 = .8 * x,
#   cor2_p09 = .9 * x,
#   cor2_p1 = x,
# ) %>% 
#   pivot_longer(cols = -c(x, y)) %>%
#   # summarise(cor = cor(x, value),
#   #           sd = sd(value),
#   #           .by = name) %>% View()
#   ggplot(aes(x, value)) +
#   geom_point(alpha = .5) +
#   geom_smooth(se = FALSE, method = "lm") +
#   facet_wrap(~ name, nrow = 2, scales = "fixed") +
#   coord_fixed()





set.seed(923856)
r <- 1
n <- 500

tibble(
  x = rnorm(n),
  y = r * x + rnorm(n, sd = sqrt(1 - r^2))
) %>% 
  ggplot(aes(x, y)) +
  geom_point(size = .5) +
  # geom_smooth(method = "lm", se = FALSE) +
  geom_label(aes(label = paste0(cor(x, y))),
             x = 0, y = 0)

