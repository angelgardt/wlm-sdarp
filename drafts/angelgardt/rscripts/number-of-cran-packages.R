library(tidyverse)
library(rvest)

read_html("https://cran.r-project.org/web/packages/available_packages_by_date.html") %>%
  html_table() %>% .[[1]] %>% 
  mutate(year = str_extract(Date, "^\\d{4}")) %>% 
  summarise(n = n(),
            .by = year) %>% 
  arrange(year) %>% 
  mutate(cum_n = n + lag(n)) %>% 
  filter(year != "2008") %>% 
  ggplot(aes(x = year)) +
  geom_col(aes(y = n), fill = "royalblue") +
  geom_line(aes(y = cum_n), group = 1) +
  geom_point(aes(y = cum_n), size = 2) +
  labs(x = 'Год',
       y = "Количество")

