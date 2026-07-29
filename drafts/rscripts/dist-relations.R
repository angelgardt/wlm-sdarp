library(tidyverse)
theme_set(theme_minimal())

n1 <- 10000
n2 <- 10000

set.seed(207)
x1 <- rnorm(n1, mean = 2, sd = 4)
x2 <- rnorm(n1, mean = 3, sd = 3)
x3 <- rnorm(n2, mean = 3, sd = 3)
x4 <- rnorm(n2, mean = 2, sd = 2)
x5 <- rnorm(n2, mean = 8, sd = 4)
x6 <- rnorm(n2, mean = 1, sd = 5)

ggplot(data = NULL) +
  geom_histogram(aes(x = x1, y = after_stat(density))) +
  geom_function(fun = dnorm, args = list(mean = 2, sd = 4))

chi1 <- scale(x1)^2 + scale(x2)^2
chi2 <- scale(x3)^2 + scale(x4)^2 + scale(x5)^2 + scale(x6)^2

ggplot(data = NULL) +
  geom_histogram(aes(x = chi1, y = after_stat(density))) +
  geom_function(fun = dchisq, args = list(df = 2))

ggplot(data = NULL) +
  geom_histogram(aes(x = chi2, y = after_stat(density))) +
  geom_function(fun = dchisq, args = list(df = 4))

fish <- (chi1/2) / (chi2/4)
ggplot(data = NULL) +
  geom_histogram(aes(x = fish, y = after_stat(density))) +
  geom_function(fun = df, args = list(df1 = 2, df2 = 4))


