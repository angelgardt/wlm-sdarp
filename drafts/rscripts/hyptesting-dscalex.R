library(tidyverse)

sig.level <- .05
power <- .8
sample.size <- 10
effect.size <- .6
se <- 1 / sqrt(sample.size)

ggplot(NULL) +
  stat_function(fun = dnorm, args = list(mean = 0, sd = se)) +
  stat_function(fun = dnorm, args = list(mean = 0, sd = se),
                geom = "area", 
                xlim = c(-1, qnorm(p = sig.level/2, mean = 0, sd = se)),
                fill = "red") +
  stat_function(fun = dnorm, args = list(mean = 0, sd = se),
                geom = "area", 
                xlim = c(qnorm(p = 1-sig.level/2, mean = 0, sd = se), 1),
                fill = "red") +
  stat_function(fun = dnorm, args = list(mean = effect.size, sd = se),
                geom = "area", 
                xlim = c(-1, qnorm(p = 1-sig.level/2, mean = 0, sd = se)),
                fill = "blue") +
  stat_function(fun = dnorm, args = list(mean = effect.size, sd = se)) +
  xlim(c(-1, 1.2)) +
  scale_x_continuous(breaks = seq(-1, 2, by = .1))

pnorm(
  q = qnorm(p = 1-sig.level/2, mean = 0, sd = se),
  mean = effect.size,
  sd = se
)

pnorm(
  q = qnorm(p = 1-sig.level/2, mean = 0, sd = se),
  mean = effect.size,
  sd = se,
  lower.tail = FALSE
)
