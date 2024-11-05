#!/bin/bash

## import functions and colors
source deploy/modules/_set-colors.sh
source deploy/modules/_render.sh
source deploy/modules/_deploy.sh
source deploy/modules/_release.sh

# check if no logs folder
if [ ! -d deploy/logs ]; then
  mkdir deploy/logs
  printf "${BLUE}new ${GRAY}deploy/logs${BLUE} created\n${NC}"
fi

# check if no docs folder
if [ ! -d docs ]; then
  mkdir docs
  printf "${RED}new ${GRAY}docs${RED} created\n${NC}"
fi

## make modes array
modes=( "none" "render" "deploy" "release" )

## assing inline args to vars, if no --- assign default
mode="${1:-${modes[0]}}"

## save datetime
dt=$(date '+%Y-%m-%d_%H-%M-%S')

## main flow
if [ "$mode" = "none" ]; then

  echo -e "${GREEN}\n=====\n=====${NC}"
  echo -e "${GREEN}NOTHING DONE${NC}"
  echo -e "${NC}none ${GREEN}mode set${NC}"
  echo -e "${GREEN}\n=====\n=====\n${NC}"
  say "nothing done"
  say "none mode set"
  exit
  
elif [ "$mode" = "render" ]; then
  
  ## render with logging
  render 2>&1 | tee deploy/logs/render_`echo "$dt"`_raw.log
  sed -e 's/\x1b\[[0-9;]*m//g' deploy/logs/render_`echo "$dt"`_raw.log >> deploy/logs/render_`echo "$dt"`.log
  rm deploy/logs/render_`echo "$dt"`_raw.log
  
elif [ "$mode" = "deploy" ]; then
  
  ## deploy with logging
  deploy 2>&1 | tee deploy/logs/deploy_`echo "$dt"`_raw.log
  sed -e 's/\x1b\[[0-9;]*m//g' deploy/logs/deploy_`echo "$dt"`_raw.log >> deploy/logs/deploy_`echo "$dt"`.log
  rm deploy/logs/deploy_`echo "$dt"`_raw.log

elif [ "$mode" = "release" ]; then
  
  ## release with logging
  release 2>&1 | tee deploy/logs/release_`echo "$dt"`_raw.log
  sed -e 's/\x1b\[[0-9;]*m//g' deploy/logs/release_`echo "$dt"`_raw.log >> deploy/logs/release_`echo "$dt"`.log
  rm deploy/logs/release_`echo "$dt"`_raw.log

else

  echo -e "${RED}\n=====\n=====${NC}"
  echo -e "${RED}RUN FAILED${NC}"
  echo -e "${RED}Unknown first inline argument value${NC} ${mode}"
  echo -e "Valid options are ${GRAY}${modes[@]}${NC} (first is default)"
  echo -e "${RED}\n=====\n=====\n${NC}"
  say "run failed"
  say "unknown first inline argument value"
  exit
  
fi
