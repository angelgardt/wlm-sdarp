library(tidyverse)
theme_set(theme_bw())
theme_update(legend.position = "bottom")

set.seed(414)
n <- 10^6

cor_sim <- function(v, x) {
  cor(v, x)
}

x <- rnorm(n)
tibble(cor_m9 = -.9 * x + rnorm(n, sd = 1 - .9^2),
       cor_m7 = -.7 * x + rnorm(n, sd = 1 - .7^2),
       cor_m5 = -.5 * x + rnorm(n, sd = 1 - .5^2),
       cor_m3 = -.3 * x + rnorm(n, sd = 1 - .3^2),
       cor_0 = .0 * x + rnorm(n, sd = 1 - .0^2),
       cor_p3 = .3 * x + rnorm(n, sd = 1 - .3^2),
       cor_p5 = .5 * x + rnorm(n, sd = 1 - .5^2),
       cor_p7 = .7 * x + rnorm(n, sd = 1 - .7^2),
       cor_p9 = .9 * x + rnorm(n, sd = 1 - .9^2)
       ) -> rs

cor_m <- matrix(ncol = ncol(rs))

set.seed(787)
for(i in 1:10^4) {
  idx <- sample(1:nrow(rs), 1000)
  rs %>% 
    slice(idx) %>% 
    map(cor_sim, x = x[idx]) %>% 
    unlist() %>% 
    rbind(cor_m) -> cor_m
}

cor_m %>% 
  as_tibble() %>% 
  set_names(paste0(colnames(cor_m), "_raw")) -> cor_m

cor_m %>% 
  map(atanh) %>% 
  as_tibble() %>% 
  set_names(paste0(colnames(cor_m), "_artanh")) %>% 
  bind_cols(cor_m) -> cor_m_artanh

cor_m_artanh %>% 
  pivot_longer(cols = everything()) %>% 
  separate(name, into = c("cor", "type"), sep = "_r") %>% 
  ggplot() +
  geom_density(aes(value, color = type)) +
  facet_wrap(~ cor, scales = "free")




