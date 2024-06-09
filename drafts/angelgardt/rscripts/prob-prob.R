set.seed(123)

tibble(n = seq(1, 5000, by = 5),
       p = n %>% 
  map(sample, x = 1:6, replace = TRUE) %>% 
  map(table) %>% 
  map(.[1]) %>% 
  unlist() %>% 
  `/`(n)
  ) %>% 
  ggplot(aes(n, p)) +
  geom_point(size = 1) +
  geom_hline(yintercept = 1/6,
             color = "#36D38C",
             linewidth = 1) +
  # ylim(0, .5) +
  labs(x = "Количество случайных экспериментов",
       y = "Относительная частота")


set.seed(956)
sample(1:6, 100*1000, replace = TRUE) %>% 
  matrix(ncol = 100) %>% 
  apply(2, function(x) sum(x == 1)) %>% 
  `/`(1000) %>% 
  tibble(n = 1:100,
         p = .) %>% 
  ggplot(aes(x = n,
             y = p)) +
  geom_point(size = 1) +
  geom_hline(yintercept = 1/6,
             color = "#36D38C",
             linewidth = 1) +
  ylim(0, 1) +
  labs(x = "Номер серии экспериментов",
       y = "Относительная частота")

