require(tidyverse)
x <- 5
mu <- 4
sd <- 6
n <- 30
alpha <- .05

## one sample
t <- (x - mu) / (sd / sqrt(n))
df <- n - 1


## two sample same var
sdp <- sqrt(((n1 - 1) * sd1 + (n2 - 1) * sd2) / (n1 + n2 - 2))
t <- (x1 - x2) / (sdp * sqrt(1/n1 + 1/n2))
df <- n1 + n2 - 2
d <- (x1 - x2) / sdp

## two sample difference vars
t_test <- function(x1, x2, sd1, sd2, n1, n2, 
                   sig.level = .05,
                   alternative = "two.sided", ...) {
  require(tidyverse)
  theme_set(theme_bw())
  if (!alternative %in% c("two.sided", "less", "greater")) {
    stop("Unknown value of argument: alternative must be two.sided, less, or greater")
  }
  
  
  t <- (x1 - x2) / sqrt(sd1^2 / n1 + sd2^2 / n2)
  df <- (sd1^2 / n1 + sd2^2 / n2)^2 / (((sd1 / n1)^2 / (n1-1)) + ((sd2 / n2)^2 / (n2-1)))
  
  sdp <- sqrt(((n1 - 1) * sd1 + (n2 - 1) * sd2) / (n1 + n2 - 2))
  d <- (x1 - x2) / sdp
  
  if (alternative == "less") {
    p <- integrate(f = dt, df = df, lower = -Inf, upper = t)$value
    t_cr <- qt(p = sig.level, df = df)
  } else if (alternative == "greater") {
    p <- integrate(f = dt, df = df, lower = t, upper = Inf)$value
    t_cr <- qt(p = 1 - sig.level, df = df)
  } else {
    int_left <- integrate(f = dt, df = df, lower = -Inf, upper = t)$value
    int_right <- integrate(f = dt, df = df, lower = t, upper = Inf)$value
    p <- 2 * min(int_left, int_right)
    t_cr <- c(left = qt(p = sig.level / 2, df = df), right = qt(p = 1 - sig.level / 2, df = df))
  }
  
  cat(paste0("t(", round(df, 2), ") = ", round(t, 2), 
             ", p = ", round(p, 2),
             ", d = ", round(d, 2)))
  
  
  lims <- c(left = -3, right = 3)
  if (t < -3) {
    lims["left"] <- t - 1
  } else if (t > 3) {
    lims["right"] <- t + 1
  }
  
  graph <- ggplot(NULL) +
    stat_function(fun = dt, args = list(df = df)) +
    geom_vline(xintercept = t_cr, linetype = "dotted") +
    geom_vline(xintercept = t, linetype = "dashed") +
    scale_x_continuous(limits = lims, ...) +
    labs(x = "t", y = "Density")
  
  if (alternative == "less") {
    graph <- graph +
      stat_function(fun = dt, args = list(df = df),
                    geom = "area",
                    xlim = c(lims["left"], t_cr),
                    fill = "red", alpha = .5) +
      stat_function(fun = dt, args = list(df = df),
                    geom = "area",
                    xlim = c(lims["left"], t),
                    fill = "blue", alpha = .5)
  } else if (alternative == "greater") {
    graph <- graph +
      stat_function(fun = dt, args = list(df = df),
                    geom = "area",
                    xlim = c(t_cr, lims["right"]),
                    fill = "red", alpha = .5) +
      stat_function(fun = dt, args = list(df = df),
                    geom = "area",
                    xlim = c(t, lims["right"]),
                    fill = "blue", alpha = .5)
  } else {
    graph <- graph +
      stat_function(fun = dt, args = list(df = df),
                    geom = "area",
                    xlim = c(lims["left"], t_cr["left"]),
                    fill = "red", alpha = .5) +
      stat_function(fun = dt, args = list(df = df),
                    geom = "area",
                    xlim = c(t_cr["right"], lims["right"]),
                    fill = "red", alpha = .5)
    if (t < 0) {
      graph <- graph +
        stat_function(fun = dt, args = list(df = df),
                      geom = "area",
                      xlim = c(lims["left"], t),
                      fill = "blue", alpha = .5)
    } else {
      graph <- graph +
        stat_function(fun = dt, args = list(df = df),
                      geom = "area",
                      xlim = c(t, lims["right"]),
                      fill = "blue", alpha = .5)
    }
  }
  print(graph)
}

t_test(x1 = 10, x2 = 5, 
       sd1 = 10, sd2 = 10, 
       n1 = 30, n2 = 40,
       alternative = "greater")
