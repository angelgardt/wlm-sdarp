#!/bin/bash

## import functions and colors
source deploy/modules/_set-colors.sh
source deploy/modules/_render.sh
# source dpelo/modules/_deploy.sh
# source deploy/modules/_restore.sh
# source deploy/modules/_release.sh
# source deploy/modules/_logger.sh

# check if no logs folder
if [ ! -d deploy/logs ]; then
  mkdir deploy/logs
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
  exit
  
elif [ "$mode" = "render" ]; then
  
  ## render with logging
  render 2>&1 | tee deploy/logs/render_`echo "$dt"`.log

elif [ "$mode" = "deploy" ]; then

  echo "deploy mode"
  # deploy 2>&1 | tee deploy/logs/deploy_`echo "$dt"`.log

elif [ "$mode" = "release" ]; then
  echo "release mode"
  # release 2>&1 | tee deploy/logs/release_`echo "$dt"`.log

else

  echo -e "${RED}\n=====\n=====${NC}"
  echo -e "${RED}RUN FAILED${NC}"
  echo -e "${RED}Unknown first inline argument value${NC} ${mode}"
  echo -e "Valid options are ${GRAY}${modes[@]}${NC} (first is default)"
  echo -e "${RED}\n=====\n=====\n${NC}"
  exit
  
fi


## add deployment info to docs/REAMDE.md
# logger # $mode
