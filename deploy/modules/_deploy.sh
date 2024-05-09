#!/bin/bash

function deploy() {
  
  ## exit wtih a non-zero status
  set -e
  
  printf "${GREEN}\n=====\nRUN DEPLOY\n=====\n\n${NC}"
  
  ## save datetime
  
  render
  
  ## check if no docs/dlp folder
  if [ ! -d docs/dpl ]; then
    mkdir docs/dpl
    touch docs/dpl/README.md
    
    printf "${BLUE}new ${GRAY}docs/dpl${BLUE} created\n${NC}"
  fi
  
  ## make dpl backup
  printf "${GREEN}\n-----\nBACKUP PREVIOUS DEPLOY\n-----\n\n${NC}"
  
  ## remove old backup
  if [ -d deploy/backup ]; then
    rm -r deploy/backup
    printf "${BLUE}old ${GRAY}deploy/backup${BLUE} removed\n${NC}"
  fi
  
  ## make new backup
  mkdir deploy/backup
  cp -r docs/dpl/* deploy/backup
  
  printf "${BLUE}new ${GRAY}deploy/backup${BLUE} created\n${NC}"
  printf "${GREEN}\n-----\nBACKUP COMPLETED\n-----\n\n${NC}"
  
  
  ## remove old dpl
  rm -r docs/dpl
  printf "${BLUE}old ${GRAY}docs/dpl${BLUE} removed\n${NC}"
  
  mkdir docs/dpl
  cp deploy/backup/README.md docs/dpl/README.md
  
  ## copy all files recursively
  {
    # try
    cp -r book/_book/* docs/dpl
  } || {
    # catch
    printf "${RED}\n=====\n${NC}"
    printf "${RED}DEPLOYMENT NOT COMPLETED\n${NC}"
		printf "${RED}File copying error\n${NC}"
		printf "${RED}=====\n\n${NC}"
		exit
  }
  
  printf "${GREEN}\n=====\nDEPLOY COMPLETED\n=====\n\n${NC}"
  printf "${GRAY}Document this deployment in README.md\nCommit and push to save changes.\n${NC}"
  
  open docs/dpl/README.md
  
}