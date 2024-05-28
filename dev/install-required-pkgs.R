pkgs <- readLines("../dev/required-pkgs.txt")
install.packages(pkgs[!pkgs %in% installed.packages()])
