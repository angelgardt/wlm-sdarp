library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")

tibble(x = seq(-10, 10, length.out = 1000),
       `sin x` = sin(x),
       `2 sin x` = 2 * sin(x),
       `0.5 sin x` = 0.5 * sin(x),
       `sin x + 1` = sin(x) + 1,
       `sin x − 1` = sin(x) - 1,
       `sin 2x` = sin(2 * x),
       `sin 0.5x` = sin(.5 * x),
       `sin (x + 1)` = sin(x+1),
       `sin (x − 1)` = sin(x-1),
       `2 sin (2x + 1)` = 2 * sin(2*x+1)) %>% 
  pivot_longer(cols = -x) -> ds

ds %>% 
  ggplot(aes(x, value)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_line(data = ds %>% 
              filter(name == "sin x") %>% 
              select(-name),
            color = "blue") +
  geom_line() +
  coord_fixed() +
  ylim(-2, 2) +
  facet_wrap(~ name, ncol = 2)

tibble(x = seq(-10, 10, length.out = 10000),
       sin = sin(x),
       cos = cos(x),
       tan = tan(x),
       cot = 1/tan(x),
       sec = 1/cos(x),
       csc = 1 / sin(x)) %>% 
  pivot_longer(cols = -x) %>% 
  ggplot(aes(x, value, color = name)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_line() +
  coord_fixed() +
  ylim(-5, 5)



tibble(x = seq(-10, 10, length.out = 10000),
       sin = sin(x),
       arcsin = asin(x),
       cos = cos(x),
       arccos = acos(x),
       tan = tan(x),
       arctan = atan(x),
       cot = 1/tan(x),
       arccot = pi/2 - atan(x)) %>% 
  pivot_longer(cols = -x) %>% 
  mutate(group = str_extract(name, "[:alpha:]{3}$")) %>% 
  ggplot(aes(x, value, color = name)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_line() +
  facet_wrap(~group) +
  coord_fixed() +
  ylim(-5, 5)




tibble(x = seq(-10, 10, length.out = 10000),
       sinh = sinh(x),
       arsin = asinh(x),
       cosh = cosh(x),
       arcos = acosh(x),
       tanh = tanh(x),
       artan = atanh(x),
       coth = 1/tanh(x),
       sech = 1/cosh(x),
       csch = 1/sinh(x),
       # arccot = pi/2 - atan(x)
       ) %>% 
  pivot_longer(cols = -x) %>% 
  mutate(group = str_extract(name, "sin|cos|tan|cot|sec|csc")) %>% 
  ggplot(aes(x, value, color = name)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_line() +
  facet_wrap(~group) +
  coord_fixed() +
  ylim(-5, 5)
