library(tidyverse)
theme_set(theme_bw())

t_stat <- function(x, y) {
  n <- length(x)
  sp <- sqrt((var(x) + var(y)) / 2)
  (mean(x) - mean(y)) / (sp * sqrt(2/n))
}

n_sim <- 30000
sample_size <- 10
df <- 2*sample_size-2
t_values <- numeric(n_sim)

set.seed(123)
for (i in 1:n_sim) {
  x <- rnorm(sample_size)
  y <- rnorm(sample_size)
  t_values[i] <- t_stat(x, y)
}

ggplot(NULL) +
  geom_histogram(aes(x = t_values, y = ..density..), bins = 180, alpha = .5) +
  stat_function(fun = dt, args = list(df = df), color = "blue") +
  stat_function(fun = dnorm, color = "red")
