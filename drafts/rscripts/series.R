library(latex2exp)
library(tidyverse)
theme_set(theme_bw())

n <- 1:100
tibble(x = n,
       y1 = cumsum(1/n),
       y2 = cumsum(1/n^2)) %>% 
ggplot(aes(x = x)) +
  geom_point(aes(y = y1), color = "salmon") +
  geom_point(aes(y = y2), color = "royalblue") +
  geom_hline(yintercept = pi^2/6) +
  labs(x = "n", y = TeX("$S_n$"))

tibble(x = n,
       y = cumsum((-1)^(n+1)*(1/n))) %>% 
  ggplot(aes(x = x)) +
  geom_point(aes(y = y), color = "royalblue") +
  geom_hline(yintercept = log(2), color = "salmon", linetype = "dashed") +
  labs(x = "n", y = TeX("$S_n$"))




n <- 10000
# Лейбниц
# terms <- rep(c(1, -1), length.out = n) / (2 * (0:(n-1)) + 1)
# Гармонический с чередованием
terms <- rep(c(1, -1), length.out = n) / (1:n)
# Целевая сумма
target <- 2
# Разделяем положительные и отрицательные члены
pos <- terms[terms > 0]
neg <- terms[terms < 0]
# Применяем метод Римана
rearranged <- numeric(0)
current_sum <- 0

while(length(pos) > 0 | length(neg) > 0) {
  # Берём положительные до превышения цели
  while(current_sum < target & length(pos) > 0) {
    current_sum <- current_sum + pos[1]
    rearranged <- c(rearranged, pos[1])
    pos <- pos[-1]
  }
  # Берём отрицательные до ухода ниже цели
  while(current_sum > target & length(neg) > 0) {
    current_sum <- current_sum + neg[1]
    rearranged <- c(rearranged, neg[1])
    neg <- neg[-1]
  }
  # Если один из списков пуст, добавляем оставшиеся элементы
  if(length(pos) == 0 & length(neg) > 0) {
    rearranged <- c(rearranged, neg)
    break
  }
  if(length(neg) == 0 & length(pos) > 0) {
    rearranged <- c(rearranged, pos)
    break
  }
}

# Частичные суммы
partial_sums <- cumsum(rearranged)

# Data frame для ggplot
df <- data.frame(
  n = 1:length(partial_sums),
  sum = partial_sums
)

# Визуализация
ggplot(df, aes(x = n, y = sum)) +
  geom_point(color = "royalblue", size = .5) +
  geom_hline(yintercept = target, linetype = "dashed", color = "salmon") +
  labs(
    x = "n",
    y = TeX("$S_n$")
  )


