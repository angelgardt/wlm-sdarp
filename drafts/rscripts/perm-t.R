# Данные
group_A <- c(12, 15, 10, 11, 9, 14, 13)
group_B <- c(5, 7, 8, 6, 4, 5, 9)

#par(mfrow=c(2,1))
hist(group_A, main = "Распределение переменной в группе A",
     xlab = "Значение", col = "royalblue", border = "white")
hist(group_B, main = "Распределение переменной в группе A",
     xlab = "Значение", col = "royalblue", border = "white")


# Объединяем
values <- c(group_A, group_B)
group <- factor(rep(c("A", "B"), each = 7))

# Разница средних (наблюдаемая)
obs_diff <- mean(group_A) - mean(group_B)
obs_diff

set.seed(42)            # фиксируем случайность для воспроизводимости
n_perm <- 10000         # число перестановок
perm_diffs <- numeric(n_perm)

for (i in 1:n_perm) {
  shuffled <- sample(values)                         # случайно перемешиваем
  new_A <- shuffled[1:length(group_A)]               # новые "группы"
  new_B <- shuffled[(length(group_A)+1):length(values)]
  perm_diffs[i] <- mean(new_A) - mean(new_B)         # сохраняем разницу средних
}

# Эмпирическое p-значение (двусторонний тест)
p_value <- mean(abs(perm_diffs) >= abs(obs_diff))
p_value

par(mfrow=c(1,1))
hist(perm_diffs, breaks = 40, main = "Перестановочное распределение разности средних",
     xlab = "Разность средних", col = "lightblue", border = "white")
abline(v = obs_diff, col = "red", lwd = 2)
abline(v = -obs_diff, col = "red", lwd = 2, lty = 2)

