#!/bin/bash

function render() {
  
  ## exit wtih a non-zero status
  set -e
  
  printf "${GREEN}\n=====\nRUN RENDER\n=====\n\n${NC}"
  
  ## remove old _book dir
  
  if [ -d book/_book ]; then
    rm -r book/_book
    printf "${BLUE}old ${GRAY}_book/ ${BLUE}removed${NC}\n"
  else
    printf "${BLUE}no ${GRAY}_book/ ${BLUE}found${NC}\n"
  fi
  
  ## render book
  {
    # try
    quarto render book --to html
  } || {
    # catch
    return 1
  }
  
  ## print render success
  printf "${BLUE}book rendered${NC}\n"
  
  printf "${GREEN}\n=====\nRENDER COMPLETED\n=====\n\n${NC}"
  
}