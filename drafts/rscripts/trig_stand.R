library(tidyverse)
library(ggforce)
theme_set(theme_minimal())

tibble(
    angle = c(0, pi/6, pi/4, pi/3, pi/2, 2*pi/3, 3*pi/4, 5*pi/6, pi,
              7*pi/6, 5*pi/4, 4*pi/3, 3*pi/2, 5*pi/3, 7*pi/4, 11*pi/6),
    sin = sin(angle),
    cos = cos(angle)
    ) %>%
ggplot() +
    geom_hline(yintercept = 0) +
    geom_vline(xintercept = 0) +
    geom_circle(aes(x0 = 0, y0 = 0, r = 1)) +
    geom_point(aes(cos, sin), size = 2)
