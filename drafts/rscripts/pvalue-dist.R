library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")
library(latex2exp)

n_samples <- 10000
sample_size <- 300
alpha <- 0.05


### p-val dist - no effect -----

set.seed(474)
m0 <- matrix(rnorm(sample_size * n_samples, mean = 1, sd = 10), ncol = n_samples)
m1 <- matrix(rnorm(sample_size * n_samples, mean = 1, sd = 10), ncol = n_samples)

results <- tibble(pval = numeric(n_samples),
                  is_lower = logical(n_samples))

for (i in 1:n_samples) {
  results$pval[i] <- t.test(m0[,i], m1[,i])$p.value
}

results$is_lower <- results$pval < .05
results$is_lower %>% mean()

results %>%
  ggplot(aes(pval, fill=is_lower)) +
  geom_histogram(binwidth = .01) +
  geom_vline(xintercept = .05, linetype = "dashed", color = "red3") +
  ylim(0, n_samples/4) +
  scale_fill_manual(values = c("TRUE" = "red3", "FALSE" = "blue3"),
                    labels = c("TRUE" = "yes", "FALSE" = "no")) +
  labs(x = "p-value", y = "Number of values", fill = TeX("Lower than $$\\alpha$$"))


### p-val dist - has effect ----

set.seed(474)
means <- seq(1, 4.5, by = .5)
all_results <- tibble()

for (mean in means) {
  m0 <- matrix(rnorm(sample_size * n_samples, mean = 1, sd = 10), ncol = n_samples)
  m1 <- matrix(rnorm(sample_size * n_samples, mean = mean, sd = 10), ncol = n_samples)
  results <- tibble(pval = numeric(n_samples),
                    is_lower = logical(n_samples),
                    cond = character(n_samples))
  for (i in 1:n_samples) {
    results$pval[i] <- t.test(m0[,i], m1[,i])$p.value
  }
  results$cond <- paste0("d = ", mean-1)
  all_results %>%
    bind_rows(results) -> all_results
}

all_results$is_lower <- all_results$pval < .05

all_results %>%
  ggplot(aes(pval, fill=is_lower)) +
  geom_histogram(binwidth = .01) +
  geom_vline(xintercept = .05, linetype = "dashed", color = "red3") +
  facet_wrap(~ cond) +
  scale_fill_manual(values = c("TRUE" = "red3", "FALSE" = "blue3"),
                    labels = c("TRUE" = "yes", "FALSE" = "no")) +
  labs(x = "p-value", y = "Number of values", fill = TeX("Lower than $$\\alpha$$"))



set.seed(474)
means <- 1:3
sample_sizes <- c(50, 100, 200)
all_results <- tibble()

for (mean in means) {
  for (sample_size in sample_sizes) {
    m0 <- matrix(rnorm(sample_size * n_samples, mean = 1, sd = 10), ncol = n_samples)
    m1 <- matrix(rnorm(sample_size * n_samples, mean = mean, sd = 10), ncol = n_samples)
    results <- tibble(pval = numeric(n_samples),
                      is_lower = logical(n_samples),
                      means_diff = character(n_samples),
                      sample_size = character(n_samples))
    for (i in 1:n_samples) {
      results$pval[i] <- t.test(m0[,i], m1[,i])$p.value
    }
  results$means_diff <- paste0("Difference between means: ", mean-1)
  results$sample_size <- paste0("Sample size: ", sample_size)
  all_results %>%
    bind_rows(results) -> all_results
  }
}

all_results$is_lower <- all_results$pval < .05

all_results %>%
  ggplot(aes(pval, fill=is_lower)) +
  geom_histogram(binwidth = .01) +
  geom_vline(xintercept = .05, linetype = "dashed", color = "red3") +
  facet_grid(sample_size ~ means_diff) +
  scale_fill_manual(values = c("TRUE" = "red3", "FALSE" = "blue3"),
                    labels = c("TRUE" = "yes", "FALSE" = "no")) +
  labs(x = "p-value", y = "Number of values", fill = TeX("Lower than $$\\alpha$$"))





### p-value behavior with effect comparing to is effect - sequential sampling -----

# set.seed(781) # bad results
set.seed(912) # good results
# set.seed(95384)

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
beepr::beep()

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



## p-value with no effect

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
beepr::beep()


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





# # set.seed(781) # bad results
# set.seed(614) # good results
# # set.seed(95384)
#
# n_max <- 500
# results <- tibble()
#
# v0 <- rnorm(9, 1, 10)
# v1 <- rnorm(9, 1, 10)
# v2 <- rnorm(9, 2, 10)
# v3 <- rnorm(9, 3, 10)
#
# for (i in 1:100) {
#   for (j in 10:n_max) {
#     v0[j] <- rnorm(1, 1, 10)
#     v1[j] <- rnorm(1, 1, 10)
#     v2[j] <- rnorm(1, 2, 10)
#     v3[j] <- rnorm(1, 3, 10)
#     res <- tibble(
#       sim = i,
#       sample_size = j,
#       v1 = t.test(v0, v1)$p.value,
#       v2 = t.test(v0, v2)$p.value,
#       v3 = t.test(v0, v3)$p.value,
#     )
#     results %>%
#       bind_rows(res) -> results
#   }
# }
#
# results %>%
#   pivot_longer(cols = c(v1, v2, v3)) %>%
#   summarise(mean = mean(value),
#             se_lower = mean_se(value)$ymin,
#             se_upper = mean_se(value)$ymax,
#             .by = c(name, sample_size)) %>%
#   ggplot(aes(sample_size, mean, color = name)) +
#   geom_line() +
#   geom_hline(yintercept = .05)
