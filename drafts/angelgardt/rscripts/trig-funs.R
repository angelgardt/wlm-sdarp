library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")

tibble(x = seq(-10, 10, length.out = 1000),
       sin = sin(x),
       ...2sin = 2 * sin(x),
       ...05sin = 0.5 * sin(x),
       sin_p1 = sin(x) + 1,
       sin_m1 = sin(x) - 1,
       sin2x = sin(2 * x),
       sin05x = sin(.5 * x),
       sin_xp1 = sin(x+1),
       sin_xm1 = sin(x-1),
       arcsin_sin_x = acos(sin)) %>% 
  pivot_longer(cols = -x) -> ds

ds %>% 
  ggplot(aes(x, value, 
             # color = name
             )) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_line() +
  coord_fixed() +
  ylim(-2, 2) +
  facet_wrap(~ name)


ds %>%
  filter(str_detect(name, "^sin$|^arcsin")) %>% 
  ggplot(aes(x, value, 
             color = name
  )) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_line() +
  coord_fixed()
