n <- 1000
x <- runif(n = n)
a <- .042
(x == a) |> sum()


n_sim <- 10^4
n <- 1000
a <- .818
n_obs <- 0

for (i in 1:n_sim) {
  cat(i, "\n")
  x <- runif(n = n)
  n_obs + ((x == a) |> sum()) -> n_obs
}
n_obs


n_sim <- 10^4
n_a <- 100
n <- 10000
n_obs <- 0

for (i in 1:n_sim) {
  cat(i, "\n")
  a <- runif(n_a)
  x <- runif(n = n)
  n_obs + ((a %in% x) |> sum()) -> n_obs
}
n_obs

