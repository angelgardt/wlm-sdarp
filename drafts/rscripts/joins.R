library(tidyverse)

x <- tibble(id = c("A", "B", "C", "D"),
            V1 = c(1, 2, 3, 5),
            V2 = c("Am", "Dm", "Cm", "Gm"))

y <- tibble(id = c("A", "D", "E", "F"),
            V3 = c(TRUE, FALSE, FALSE, TRUE),
            V4 = c("No", "Yes", "No", "No"))

full_join(x, y)
left_join(x, y)
right_join(x, y)
inner_join(x, y)
