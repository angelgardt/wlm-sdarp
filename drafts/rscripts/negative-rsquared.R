library(tidyverse)
theme_set(theme_bw())

n <-  200

set.seed(404)
tibble(x = runif(n, 0, 40),
       y = sqrt(x) + rnorm(n, sd = .5),
       y_hat = -.05 * x + 3.5) -> ds
ds %>%
    ggplot() +
    geom_point(aes(x, y))  +
    geom_line(aes(x, y_hat))

TSS <- sum((ds$y - mean(ds$y))^2)
ESS <- sum((ds$y_hat - mean(ds$y))^2)
RSS <- sum((ds$y - ds$y_hat)^2)

ESS / TSS
1 - RSS / TSS
