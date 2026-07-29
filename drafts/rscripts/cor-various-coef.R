library(tidyverse)

tibble(x = rnorm(100),
       y = 3 + rnorm(100))

# set.seed(2525)
set.seed(110)
n <- 500
cors <- seq(-1, 1, by = .1)
cors_tibble <- tibble(x = rnorm(n))

for (cor in cors) {
  cors_tibble[[paste0(cor, "_1")]] <- cor * cors_tibble$x + rnorm(n, sd = sqrt(1 - cor^2))
  cors_tibble[[paste0(cor, "_2")]] <- cor * cors_tibble$x
}

cors_tibble %>%
    pivot_longer(cols = -x) %>%
    filter(str_detect(name, "_1$")) %>%
    mutate(name = str_remove(name, "_1$")) %>%
    summarise(pearson= cor(x, value),
              spearman = cor(x, value, method = "sp"),
              kendall = cor(x, value, method = "ken"),
              .by = name) %>%
    mutate(pop_cor = as.numeric(name)) %>%
    pivot_longer(cols = -c(name, pop_cor),
                 names_to = "kind",
                 values_to = "cor") %>%
    ggplot(aes(x = pop_cor,
               y = cor,
               color = kind)) +
    geom_point() +
    geom_line()


## Spearman vs Pearson
set.seed(111)
n <- 500
x <- rnorm(n)
r <- .5
y <- r * x + rnorm(n, sd = sqrt(1 - r^2))

cor(x, y)
cor(x, y, method = "sp")
cor(rank(x), rank(y))



