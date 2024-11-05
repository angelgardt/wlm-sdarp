#!/bin/bash

function release() {
  
  ## exit wtih a non-zero status
  set -e
  
  printf "${GREEN}\n=====\nRUN RELEASE\n=====\n\n${NC}"
  
  ## save versions from input
  printf "${GRAY}What is a current version?\n${NC}"
  read -p "Current version: " current_version
  printf "${GRAY}What is a previous version?\n${NC}"
  read -p "Previous version: " previous_version
  
  ## check inputs, exit if rejected
  printf "${RED}\n\nYou said, that\n${NC}"
  printf "${GRAY}Current version: ${current_version}${NC}\n"
  printf "${GRAY}Previous version: ${previous_version}${NC}\n"
  
  {
    read -p "Is it correct? (Y/N) " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]
  } || {
    printf "${RED}\n=====\n${NC}"
    printf "${RED}RELEASE NOT COMPLETED\n${NC}"
		printf "${RED}You rejected your input. Restart release.\n${NC}"
		printf "${RED}=====\n\n${NC}"
		say "release not completed"
		say "You rejected your input"
		say "Restart release"
		exit
  }
  
  ## check deploy, exit if rejected
  printf "${RED}\n\nDid you deploy all changes after proofreading, debugging, etc?\n${NC}"
  
  {
    read -p "You did? (Y/N) " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]
  } || {
    printf "${RED}\n=====\n${NC}"
    printf "${RED}RELEASE NOT COMPLETED\n${NC}"
		printf "${RED}Deploy and double check first, then restart release.\n${NC}"
		printf "${RED}=====\n\n${NC}"
		say "release not completed"
		say "Deploy and double check first, then restart release."
		exit
  }
  
  ## check if no cr
  if [ ! -d docs/cr ]; then
    mkdir docs/cr
    touch docs/cr/README.md
    printf "${RED}new ${GRAY}docs/cr${RED} created\n${NC}"
  fi
  
  ### start release
  
  ## save previous
  mkdir docs/prev/`echo "${previous_version}"`
  cp -r docs/cr/* docs/prev/`echo "${previous_version}"`
  printf "${BLUE}previous release archived\n${NC}"
  
  ## remove old cr
  rm -r docs/cr
  printf "${BLUE}old ${GRAY}docs/cr${BLUE} removed\n${NC}"
  
  mkdir docs/cr
  
  ## copy all files recursively
  {
    # try
    cp -r docs/dpl/* docs/cr
  } || {
    # catch
    printf "${RED}\n=====\n${NC}"
    printf "${RED}RELEASE NOT COMPLETED\n${NC}"
		printf "${RED}File copying error\n${NC}"
		printf "${RED}=====\n\n${NC}"
		say "release not completed"
		say "File copying error"
		exit
  }
  
  cp docs/prev/`echo "${previous_version}"`/README.md docs/cr/README.md
  
  printf "${GREEN}\n=====\nRELEASE COMPLETED\n=====\n\n${NC}"
  printf "${GRAY}Document this release in README.md\nCommit and push to save changes.\n${NC}"
  say "release completed"
	say "Document this release in README"
	say "Commit and push to save changes."
  
  open docs/cr/README.md
  
}
