library(tidyverse)
library(plotly)
theme_set(theme_bw())

LSE <- function(x, y) {
    if (length(x) != length(y)) {
        stop("length(x) != length(y)")
    }
    X <- matrix(c(rep(1, length(x)), x), ncol = 2)
    b <- (solve(t(X) %*% X) %*% t(X) %*% y) %>% as.vector()
    names(b) <- c("b0", "b1")
    return(b)
}

L <- function(b0, b1, x, y) {
    if (length(x) != length(y)) {
        stop("length(x) != length(y)")
    }
    n <- length(x)
    return(
        n * b0^2 + 2 * b1^2 * sum(x^2) - 2 * b0 * sum(y) - 2 * b1 * sum(x*y) + 2 * b0 * b1 * sum(x) + sum(y^2)
    )
}

# n <- 30
# meanx <- 8
# sdx <- 6
# meany <- -5
# sdy <- 4
# corxy <- .2

# set.seed(120)
# nsim <- 10000
# cors <- numeric(nsim)
# for(i in 1:nsim) {
# x <- rnorm(n = n, mean = meanx, sd = sdx)
# b1 <- corxy * sdy / sdx
# b0 <- meany - b1 * meanx
# y <- b0 + b1 * x + rnorm(n = n, mean = 0, sd = sqrt(sdy^2 - sdy^2 * corxy^2))
# cors[i] <- cor(x, y)
# }
# mean(cors)
# hist(cors)

n <- 30
meanx <- 8
sdx <- 6
meany <- -5
sdy <- 4
corxy <- .8

set.seed(123)
x <- rnorm(n = n, mean = meanx, sd = sdx)
b1 <- corxy * sdy / sdx
b0 <- meany - b1 * meanx
y <- b0 + b1 * x + rnorm(n = n, mean = 0, sd = sqrt(sdy^2 - sdy^2 * corxy^2))

fit <- lm(y ~ x)
fit$coefficients
summary(fit)$r.squared
cor(x, y)
cor(x, y)^2
LSE(x, y)

ggplot(data = NULL,
       aes(x, y)) +
    geom_point() +
    geom_smooth(method = "lm") +
    geom_abline(intercept = b0, slope = b1)

b0_axis <- seq(-10, -4, by = .01)
b1_axis <- seq(-2, 2, by = .01)
L_data <- tibble(b0 = b0_axis %>% rep(each = length(b1_axis)),
                 b1 = b1_axis %>% rep(times = length(b0_axis)),
                 L = L(b0, b1, x, y))
L_data %>% filter(L == min(L))

plot_ly(
    x = b0_axis,
    y = b1_axis,
    z = L_data$L %>% matrix(ncol = length(b0_axis))
    ) %>%
    add_surface()
LSE(x, y)
min(L_data$L)
