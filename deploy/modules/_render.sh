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
    if [ -f dev/_quiz/get_quiz_jsons.R ]; then
      Rscript dev/_quiz/get_quiz_jsons.R
    else
      printf "${BLUE}no ${GRAY}dev/quiz/get_quiz_jsons.R ${BLUE}file{NC}\n"
    fi
    
    if [ -f dev/_sheet/get_sheet_jsons.R ]; then
      Rscript dev/_sheet/get_sheet_jsons.R
    else
      printf "${BLUE}no ${GRAY}dev/sheet/get_sheet_jsons.R ${BLUE}file{NC}\n"
    fi
    
    quarto render book --to html
  } || {
    # catch
    return 1
  }
  
  ## print render success
  printf "${BLUE}book rendered${NC}\n"
  
  printf "${GREEN}\n=====\nRENDER COMPLETED\n=====\n\n${NC}"
  
}