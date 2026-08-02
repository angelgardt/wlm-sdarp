library(tidyverse)
theme_set(theme_bw())

f <- function(x, ...) dnorm(x, ...)
x_from <- -4
x_to <- 4
n <- 600
x_seq <- seq(x_from, x_to, length.out = n + 1)
df_strip <- data.frame(
  xmin  = x_seq[-(n + 1)],
  xmax  = x_seq[-1],
  ymax  = pmax(f(x_seq[-(n + 1)]), 0)   # не уходим ниже оси
)



tibble(
  x = seq(-4, 4, by = .01),
  y = dnorm(x)
) %>%
  ggplot(aes(x = x, y = y)) +
  geom_line(linewidth = 1)









library(ggplot2)

# ── 1. Функция, которую будем рисовать ──
f <- function(x) dnorm(x, mean = 0, sd = 1)

# ── 2. Генерируем тонкие полоски для имитации градиента ──
n    <- 1000L                     # чем больше, тем «гладче» градиент
x_seq <- seq(-4, 4, length.out = n)
dx    <- diff(x_seq)[1]

df_fill <- data.frame(
  xmin = x_seq - dx / 2,
  xmax = x_seq + dx / 2,
  y    = f(x_seq),
  xmid = x_seq                    # для маппинга цвета
)

# ── 3. График ──
ggplot() +
  # Градиентная заливка (тысячи узких rect'ов)
  geom_rect(
    data    = df_fill,
    aes(xmin = xmin, xmax = xmax,
        ymin = 0,    ymax = y,
        fill = abs(xmid)),
    colour  = NA,                  # убираем обводку полосок
    #alpha = .7
  ) +

  # Сама линия функции поверх
  geom_function(fun = f, colour = "black", linewidth = 1, xlim = c(-4, 4), n = 1000) +

  # Палитра градиента (подберите под себя)
  scale_fill_gradientn(
    colours = c("royalblue","royalblue", "salmon", "salmon"),
    guide   = guide_colourbar(title = "x")
  ) +
  theme(legend.position = "bottom") +
  labs(
    title = "Градиентная заливка площади под кривой",
    x = "x", y = "f(x)"
  ) +
  coord_cartesian(ylim = c(0, NA))   # обрезаем «хвосты» ниже 0
