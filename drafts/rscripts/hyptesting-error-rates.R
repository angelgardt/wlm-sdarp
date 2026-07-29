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



## pval behavior

### has effect
set.seed(912)

n_max <- 500
results <- tibble()

v0 <- rnorm(9, 1, 10)
v1 <- rnorm(9, 1, 10)
v2 <- rnorm(9, 1.5, 10)
v3 <- rnorm(9, 2, 10)
v4 <- rnorm(9, 2.5, 10)
v5 <- rnorm(9, 3, 10)

for (j in 10:n_max) {
  v0[j] <- rnorm(1, 1, 10)
  v1[j] <- rnorm(1, 1, 10)
  v2[j] <- rnorm(1, 1.5, 10)
  v3[j] <- rnorm(1, 2, 10)
  v4[j] <- rnorm(1, 2.5, 10)
  v5[j] <- rnorm(1, 3, 10)
  res <- tibble(
    sim = i,
    sample_size = j,
    v1 = t.test(v0, v1)$p.value,
    v2 = t.test(v0, v2)$p.value,
    v3 = t.test(v0, v3)$p.value,
    v4 = t.test(v0, v4)$p.value,
    v5 = t.test(v0, v5)$p.value,
  )
  results %>%
    bind_rows(res) -> results
}

results %>%
  pivot_longer(cols = c(v1, v2, v3, v4, v5)) %>%
  ggplot(aes(sample_size, value, color = name)) +
  geom_line() +
  geom_hline(yintercept = .05, linetype = "dashed") +
  scale_x_continuous(breaks = seq(10, 500, 10)) +
  scale_color_discrete(labels = c(v1 = 0.0,
                                  v2 = 0.5,
                                  v3 = 1.0,
                                  v4 = 1.5,
                                  v5 = 2.0)) +
  labs(x = "Sample Size",
       y = "p-value",
       color = "Difference of Means")



## no effect
set.seed(614)

n_max <- 500
results <- tibble()
m0 <- 1
m1 <- 1
m2 <- 1
m3 <- 1
m4 <- 1
m5 <- 1

v0 <- rnorm(9, m0, 10)
v1 <- rnorm(9, m1, 10)
v2 <- rnorm(9, m2, 10)
v3 <- rnorm(9, m3, 10)
v4 <- rnorm(9, m4, 10)
v5 <- rnorm(9, m5, 10)

for (j in 10:n_max) {
  v0[j] <- rnorm(1, 1, 10)
  v1[j] <- rnorm(1, m1, 10)
  v2[j] <- rnorm(1, m2, 10)
  v3[j] <- rnorm(1, m3, 10)
  v4[j] <- rnorm(1, m4, 10)
  v5[j] <- rnorm(1, m5, 10)
  res <- tibble(
    sim = i,
    sample_size = j,
    v1 = t.test(v0, v1)$p.value,
    v2 = t.test(v0, v2)$p.value,
    v3 = t.test(v0, v3)$p.value,
    v4 = t.test(v0, v4)$p.value,
    v5 = t.test(v0, v5)$p.value,
  )
  results %>%
    bind_rows(res) -> results
}

results %>%
  pivot_longer(cols = c(v1, v2, v3, v4, v5)) %>%
  ggplot(aes(sample_size, value, color = name)) +
  geom_line() +
  geom_hline(yintercept = .05, linetype = "dashed") +
  scale_x_continuous(breaks = seq(10, 500, 10)) +
  scale_color_discrete(labels = c(v1 = 0, v2 = 0, v3 = 0, v4 = 0, v5 = 0)) +
  labs(x = "Sample Size",
       y = "p-value",
       color = "Difference of Means")
