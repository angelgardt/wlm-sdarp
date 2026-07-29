library(tidyverse)
theme_set(theme_minimal())

logcurve <- function(x, a=1, b=0) {1 / (1 + exp(-(a*x+b)))}

ggplot() +
  geom_function(fun = pnorm, color = "salmon") +
  geom_function(fun = logcurve, color = "royalblue") +
  geom_function(fun = logcurve, args = list(a=1.8 , b=0), color = "black") +
  xlim(-4, 4)
