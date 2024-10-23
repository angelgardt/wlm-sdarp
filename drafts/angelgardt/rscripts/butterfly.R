library(tidyverse)
theme_set(theme_minimal())

tibble(
  t = seq(0, 12*pi, length.out = 1000),
  a = exp(cos(t)) - 2 * cos(4 * t) + sin(t / 12)^5,
  x = sin(t) * a,
  y = cos(t) * a
) %>% 
  ggplot(aes(x, y, color = t)) +
  geom_line() +
  scale_color_gradient(low = "black", high = "magenta") +
  guides(color = "none") +
  labs(x = "", y = "")

tibble(
  t = seq(0, 12*pi, length.out = 10000),
  a = exp(cos(t)) - 2 * cos(4 * t) + sin(t / 12)^5,
  x = sin(t) * a,
  y = cos(t) * a
) %>% 
  ggplot(aes(x, y, color = t)) +
  geom_point(size = 1) +
  scale_color_gradient(low = "springgreen",
                       high = "royalblue") +
  guides(color = "none") +
  labs(x = "", y = "")

