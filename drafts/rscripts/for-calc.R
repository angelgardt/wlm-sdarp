library(latex2exp)
library(tidyverse)
theme_set(theme_minimal())
theme_update(legend.position = "bottom")


tibble(x = rep(1:10, each = 10),
       y = rep(1:10, times = 10),
       rel = y <= x) %>%
    ggplot(aes(x = x, y = y, color = rel)) +
    geom_point(size = 3) +
    scale_x_continuous(breaks = 1:10) +
    scale_y_continuous(breaks = 1:10) +
    scale_color_manual(values = c(`TRUE` = "black",
                                  `FALSE` = "gray70")) +
    labs(x = TeX("$a \\in N$"),
         y = TeX("$b \\in N$"),
         color = TeX("$b \\leq a$"))


ggplot() +
    stat_function(fun = function(x) x,
                  geom = "ribbon",
                  aes(ymin = -Inf, ymax = after_stat(y)),
                  xlim = c(-5, 5),
                  fill = "black", alpha = 0.5) +
    stat_function(fun = function(x) x,
                  geom = "line",
                  xlim = c(-5, 5),
                  fill = "black", alpha = .3) +
    geom_hline(yintercept = 0) +
    geom_vline(xintercept = 0) +
    annotate(geom = "text",
             label = TeX("$y \\leq x$"),
             x = 2.5, y = -2.5) +
    labs(x = TeX("$x \\in R$"),
         y = TeX("$y \\in R$"),
         color = TeX("$y \\leq x$"))



tibble(
    n = 1:100,
    `1/n` = 1/n,
    `1/n^2` = 1/n^2,
    `S_n(1/n)` = cumsum(`1/n`),
    `S_n(1/n^2)` = cumsum(`1/n^2`)
) %>%
    pivot_longer(cols = -n) %>%
    mutate(type = ifelse(str_detect(name, "S_n"), "series", "seq"),
           seq = str_extract(name, "1/n(\\^.)?")) %>%
    ggplot(aes(n, value,
               color = seq,
               shape = type)) +
    geom_point()
