library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")

tibble(
  h1 = seq(from = 0, to = 1, by = .01),
  h0 = 1 - h1,
  sig.level = .05,
  # sig.level = seq(from = 0, to = 1, by = .01),
  not.sig.level = 1 - sig.level,
  # power = seq(from = 0, to = 1, by= .01),
  power = .8,
  beta = 1 - power,
  tn = not.sig.level * h0,
  fp = sig.level * h0,
  fn = beta * h1,
  tp = power * h1
  ) %>%
  pivot_longer(cols = tn:tp, names_to = "res", values_to = "prob") %>%
  ggplot() +
  geom_line(aes(h1, prob, color = res))


tibble(
  h1 = .5,
  #h1 = seq(from = 0, to = 1, by = .01),
  h0 = 1 - h1,
  # sig.level = .05,
  sig.level = seq(from = 0, to = 1, by = .01),
  not.sig.level = 1 - sig.level,
  #power = seq(from = 0, to = 1, by= .01),
  power = .8,
  beta = 1 - power,
  tn = not.sig.level * h0,
  fp = sig.level * h0,
  fn = beta * h1,
  tp = power * h1
  ) %>%
  pivot_longer(cols = tn:tp, names_to = "res", values_to = "prob") %>%
  ggplot() +
  geom_line(aes(sig.level, prob, color = res))

tibble(
  h1 = .5,
  #h1 = seq(from = 0, to = 1, by = .01),
  h0 = 1 - h1,
  sig.level = .05,
  #sig.level = seq(from = 0, to = 1, by = .01),
  not.sig.level = 1 - sig.level,
  power = seq(from = 0, to = 1, by= .01),
  #power = .8,
  beta = 1 - power,
  tn = not.sig.level * h0,
  fp = sig.level * h0,
  fn = beta * h1,
  tp = power * h1
) %>%
  pivot_longer(cols = tn:tp, names_to = "res", values_to = "prob") %>%
  ggplot() +
  geom_line(aes(power, prob, color = res)) +
  scale_x_continuous(limits = c(0, 1)) +
  scale_y_continuous(limits = c(0, 1))

