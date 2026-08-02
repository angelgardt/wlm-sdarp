library(tidyverse)
theme_set(theme_bw())

## INDEPENDENT TESTS
sig_level <- .05
n_comp <- 1:50
theoretical_fpr <- tibble(n_comp = n_comp,
                          fpr = 1 - (1 - sig_level)^n_comp)
n_sim <- 100
sample_size <- 50
n_rep <- 20
empirical_fpr <- tibble(n_comp = n_comp)

z_test_pval <- function(x, mu = 0, sigma = 1) {
  z <- (mean(x) - mu) / (sigma / sqrt(length(x)))
  return(2 * pnorm(-abs(z)))
}


set.seed(123)
for (i in 1:n_rep) {
  empirical_fpr[[paste0("rep", i)]] <- numeric(1)
  for (j in 1:length(n_comp)) {
    empirical_fpr[[paste0("rep", i)]][j] <- replicate(n_sim,
          (replicate(n_comp[j],
                     z_test_pval(rnorm(sample_size))) < sig_level) %>%
            sum(na.rm = TRUE)) %>%
  as.logical() %>% mean()
  }
  }

matrix(rnorm(sample_size * n_comp[2]), nrow = n_comp[2])

array(data = rnorm(sample_size * 1 * n_sim * n_rep),
      dim = c(1, sample_size, n_sim, n_rep)) %>%
  apply(c(3, 4), rowMeans) %>%
  `*`(sqrt(sample_size)) %>%
  abs() %>%
  `-`() %>%
  pnorm() %>%
  `*`(2) %>%
  `<`(sig_level) %>%
  { if (F) apply(., 3, colSums) %>% `>`(0) else . } %>%
  # apply(3, colSums) %>%
  # `>`(0) %>%
  apply(2, mean)

map(n_comp,
    function(n_comp) {
      array(data = rnorm(sample_size * n_comp * n_sim * n_rep),
            dim = c(n_comp, sample_size, n_sim, n_rep)) %>%
        apply(c(3, 4), rowMeans) %>%
        `*`(sqrt(sample_size)) %>%
        abs() %>%
        `-`() %>%
        pnorm() %>%
        `*`(2) %>%
        `<`(sig_level) %>%
        { if (n_comp != 1) apply(., 3, colSums) %>% `>`(0) else . } %>%
        apply(2, mean) %>%
        return()
    }) -> sim

sim %>% as_tibble(.name_repair = "universal_quiet") %>%
  mutate(rep = paste0("rep", 1:n_rep)) %>%
  pivot_longer(cols = -rep, names_to = "n_comp", values_to = "fpr") %>%
  mutate(n_comp = str_replace_all(n_comp, "\\.{3}", "") %>% as.numeric()) -> sim_tbl

sim_tbl %>%
  ggplot(aes(n_comp, fpr)) +
  geom_point(alpha = .3) +
  geom_line(aes(group = rep),
            alpha = .3) +
  stat_summary(fun = mean, geom = "point",
               aes(color = "empirical_mean"),
               size = 2) +
  stat_summary(fun = mean, geom = "line",
               aes(color = "empirical_mean"),
               linewidth = 1) +
  geom_point(data = theoretical_fpr, aes(n_comp, fpr, color = "theor_fpr"),
             shape = 15, size = 2) +
  geom_line(data = theoretical_fpr, aes(n_comp, fpr, color = "theor_fpr"),
            linewidth = 1) +
  scale_x_continuous(breaks = n_comp) +
  scale_color_manual(values = c(empirical_mean = "royalblue",
                                theor_fpr = "tan"),
                     labels = c(empirical_mean = "Средний FPR по симуляциям",
                                theor_fpr = "Теоретический FPR")) +
  labs(x = "Количество статистических тестов",
       y = "Вероятность ошибки I рода\n(False Positive Rate, FPR)",
       color = "") +
  theme(legend.position = "bottom",
        axis.text.x = element_text(size = 8))

# for (i in 1:n_rep) {
#   for (j in 1:length(n_comp)) {
#     empirical_fpr[paste0("rep", i)][j] <- replicate(n_sim,
#                                                     (replicate(n_comp[j],
#                                                                BSDA::z.test(rnorm(sample_size),
#                                                                             mu = 0,
#                                                                             sigma.x = 1)$p.value) < sig_level) %>%
#                                                       sum(na.rm = TRUE)) %>% as.logical() %>% mean()
#   }
# }

empirical_fpr %>%
  # as_tibble(.name_repair = "unique") %>%
  # mutate(n_comp = n_comp) %>%
  pivot_longer(cols = -n_comp) %>% # print()
  ggplot(aes(n_comp, value)) +
  geom_point(alpha = .3) +
  geom_line(aes(group = name),
            alpha = .3) +
  stat_summary(fun = mean, geom = "point",
               aes(color = "empirical_mean"),
               size = 2) +
  stat_summary(fun = mean, geom = "line",
               aes(color = "empirical_mean"),
               linewidth = 1) +
  geom_point(data = theoretical_fpr, aes(n_comp, fpr, color = "theor_fpr"),
             shape = 15, size = 2) +
  geom_line(data = theoretical_fpr, aes(n_comp, fpr, color = "theor_fpr"),
            linewidth = 1) +
  geom_hline(yintercept = sig_level, linetype = "dashed") +
  scale_x_continuous(breaks = n_comp) +
  scale_color_manual(values = c(empirical_mean = "royalblue",
                                theor_fpr = "tan"),
                     labels = c(empirical_mean = "Средний FPR по симуляциям",
                                theor_fpr = "Теоретический FPR")) +
  labs(x = "Количество статистических тестов",
       y = "Вероятность ошибки I рода\n(False Positive Rate, FPR)",
       color = "") +
  theme(legend.position = "bottom",
        axis.text.x = element_text(size = 8))



## PAIRWISE COMPARISONS
sig_level <- .05
n_group <- 2:10
n_comp <- choose(k = 2, n = n_group)
theoretical_fpr <- tibble(n_comp = n_comp,
                          fpr = 1 - (1 - sig_level)^n_comp)
n_sim <- 100
sample_size <- 50
n_rep <- 20
empirical_fpr <- list()

set.seed(123)
for (i in 1:n_rep) {
  empirical_fpr[[i]] <- numeric(length(n_group))
  for (j in 1:length(n_group)) {
    empirical_fpr[[i]][j] <- replicate(n_sim,
                                       (pairwise.t.test(
                                         x = rnorm(sample_size * n_group[j]),
                                         g = rep(1:n_group[j], each = sample_size),
                                         p.adjust.method = "none", pool.sd = FALSE)$p.value %>%
                                          as.vector() < sig_level) %>%
                                         sum(na.rm = TRUE)) %>% as.logical() %>% mean()
    }
}

empirical_fpr %>%
  as_tibble(.name_repair = "universal_quiet") %>%
  mutate(n_comp = n_comp) %>%
  pivot_longer(cols = -n_comp) %>% # print()
  ggplot(aes(n_comp, value)) +
  geom_point(alpha = .5) +
  geom_line(aes(group = name), alpha = .5) +
  geom_point(data = theoretical_fpr, aes(n_comp, fpr, color = "theor_fpr"),
             shape = 15, size = 2) +
  geom_line(data = theoretical_fpr, aes(n_comp, fpr, color = "theor_fpr"),
            linewidth = 1, size = 2) +
  stat_summary(fun = mean, geom = "point",
               aes(color = "empirical_mean"),
               size = 2) +
  stat_summary(fun = mean, geom = "line",
               aes(color = "empirical_mean"),
               linewidth = 1) +
  geom_hline(yintercept = sig_level, linetype = "dashed") +
  scale_x_continuous(breaks = n_comp,
                     sec.axis = dup_axis(name = "Количество групп",
                                         labels = n_group)) +
  scale_color_manual(values = c(empirical_mean = "royalblue",
                                theor_fpr = "tan"),
                     labels = c(empirical_mean = "Средний FWER по симуляциям",
                                theor_fpr = "Теоретический FPR для независимых тестов")) +
  labs(x = "Количество попарных сравнений",
       y = "Вероятность ошибки I рода\n(False Wise Error Rate, FWER)",
       color = "") +
  theme(legend.position = "bottom",
        axis.text.x = element_text(size = 8))
