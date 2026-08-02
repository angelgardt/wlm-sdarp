library(tidyverse)
theme_set(theme_minimal())


set.seed(123)
n <- 1000
mu <- 0
sd <- 1
ds <- tibble(x = rnorm(mean = mu, sd = sd, n = n),
             bin = NA)

bins <- 30

ggplot(data = ds) +
  # geom_histogram(aes(x = x)) +
  geom_histogram(aes(x = x, y = after_stat(density)), bins = bins) +
  geom_function(fun = dnorm, args = list(mean = mu, sd = sd))


bins_margins <- seq(from = min(ds$x), to = max(ds$x), length.out = bins+1)

for (i in 1:length(ds$x)) {
  for (j in 1:(length(bins_margins)-1)) {
    if (ds$x[i] >= bins_margins[j] & ds$x[i] <= bins_margins[j+1]) {
      ds$bin[i] <- j
    }
  }
}

ds %>%
  summarise(n_bin = n(),
            .by = bin) %>%
  mutate(p = n_bin / n) -> ds_bins

shift <- -bins/2
ds_bins$p_rel <- ds_bins$p / ds_bins$p[abs(shift)]
scale_h <- (1/(sqrt(2*pi)*sd))/ds_bins$p_rel[abs(shift)]

ggplot(data = ds_bins) +
  geom_point(aes(x = bin+shift, y = p_rel*scale_h)) +
  geom_function(fun = dnorm, args = list(mean = mu, sd = sd))

# gridExtra::grid.arrange(plot1, plot2)
