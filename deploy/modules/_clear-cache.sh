#!bin/bash

function clear_cache {
  {
    # try
    rm book/*.html
    rm book/*.rmarkdown
    rm -r book/*_cache
    rm -r book/*_files
    
    printf "${BLUE}cache cleaning done${NC}\n"
  } || {
    # catch
    return 1
    printf "${RED}cache cleaning failed${NC}\n"
    say "cache cleaning error"
  }
}
