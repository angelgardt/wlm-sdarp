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

# tibble(
#   x = rnorm(n),
#   y = r * x + rnorm(n, sd = sqrt(1 - r^2))
# ) %>% 
#   ggplot(aes(x, y)) +
#   geom_point(size = .5) +
#   geom_smooth(method = "lm", se = FALSE, color = "gray70") +
#   geom_label(aes(label = paste0(cor(x, y))),
#              x = 0, y = 0)




set.seed(2525)
n <- 500
cors <- seq(-1, 1, by = .1)
cors_tibble <- tibble(x = rnorm(n))

for (cor in cors) {
  cors_tibble[[paste0(cor, "_1")]] <- cor * cors_tibble$x + rnorm(n, sd = sqrt(1 - cor^2))
  cors_tibble[[paste0(cor, "_2")]] <- cor * cors_tibble$x
}

cors_tibble %>% 
  pivot_longer(cols = -x) %>% 
  filter(str_detect(name, "_1$")) %>% 
  mutate(row = ifelse(str_detect(name, "-0\\.[9876]|-1_"), "1", 
                      ifelse(str_detect(name, "-0\\.[54321]"), "2",
                             ifelse(str_detect(name, "0\\.[12345]"), "4",
                                    ifelse(str_detect(name, "0\\.[6789]|1_"), "5", "3"))))) %>% 
  mutate(name = factor(name, 
                       ordered = TRUE, 
                       levels = paste0(rep(seq(-1, 1, by = .1), times = 2),
                                       rep(c("_1", "_2"), each = 21)
                                      )
                       )
         ) %>% 
  ggplot(aes(x, value)) +
  geom_point(size = 1) +
  geom_smooth(method = "lm", 
              se = FALSE, 
              color = "springgreen",
              linewidth = .5) +
  facet_grid(row ~ name) +
  coord_fixed(ratio = 1)

