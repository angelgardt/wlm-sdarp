library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")


r_ci <- function(r, n, ci = .95, lazy = FALSE, limits = "both") {
  if (lazy) {
    se <- sqrt((1 - r^2) / (n - 2))
    ci_lower <- r + qnorm((1 - ci) / 2) * se
    ci_upper <- r + qnorm(ci + ((1 - ci) / 2)) * se
  } else {
    z_r <- atanh(r)
    se <- 1 / sqrt(n - 3)
    ci_lower <- tanh(z_r + qnorm((1 - ci) / 2) * se)
    ci_upper <- tanh(z_r + qnorm(ci + ((1 - ci) / 2)) * se)
  }
  if (limits == "upper") return(c(upper = ci_upper))
  if (limits == "lower") return(c(lower = ci_lower))
  return(c(lower = ci_lower, 
           upper = ci_upper))
}

tibble(
  r = seq(-.99, .99, by = .01) %>% rep(each = 199),
  n = seq(10, 1000, by = 5) %>% rep(times = 199),
  ci_lower = numeric(39601),
  ci_upper = numeric(39601)
) -> r_ci_ds

for (i in 1:nrow(r_ci_ds)) {
  r_ci_ds$ci_lower[i] <- r_ci(r_ci_ds$r[i], r_ci_ds$n[i], limits = "lower")
  r_ci_ds$ci_upper[i] <- r_ci(r_ci_ds$r[i], r_ci_ds$n[i], limits = "upper")
}
beepr::beep()

# r_ci_ds$r %>% r_ci(n = 100)

r_ci_ds %>% 
  mutate(has_zero = ifelse(sign(ci_lower) != sign(ci_upper), TRUE, FALSE)) %>% 
  # filter(r > 0) %>% 
  # filter(n > 100 & n < 500) %>% 
  ggplot(aes(x = n, y = r, color = has_zero)) +
  geom_point(size = 1) +
  scale_color_manual(values = c("TRUE" = "salmon", "FALSE" = "springgreen")) +
  scale_x_continuous(breaks = seq(10, 1000, by = 10)) +
  scale_y_continuous(breaks = seq(-1, 1, length.out = 51)) +
  theme(axis.text.x = element_text(angle = 90))

