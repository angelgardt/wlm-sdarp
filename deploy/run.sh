#!/bin/bash

## import functions and colors
# source deploy/modules/_set-colors.sh
# source deploy/modules/_render.sh
# source dpelo/modules/_deploy.sh
# source deploy/modules/_restore.sh
# source deploy/modules/_release.sh
# source deploy/modules/_logger.sh

## make modes array
modes=( "none" "render" "deploy" "release" "restore" )

## assing inline args to vars, if no --- assign default
mode="${1:-${modes[0]}}"

## check mode
## abort function if not valid

mode_check="\<${mode}\>" # extract a regex that matches the exact value of the argument

if [[ ! ${modes[@]} =~ $mode_check ]]
then

  echo -e "${RED}\n=====\n=====${NC}"
  echo -e "${RED}RUN FAILED${NC}"
  echo -e "${RED}Unknown first inline argument${NC}"
  echo -e "Valid options are ${GRAY}${modes[@]}${NC} (first is default)"
  echo -e "${RED}\n=====\n=====\n${NC}"
  exit
  
fi

if [ "$mode" = "none" ]
then

  echo -e "${GREEN}\n=====\n=====${NC}"
  echo -e "${GREEN}NOTHING DONE${NC}"
  echo -e "${NC}none ${GREEN} mode set${NC}"
  echo -e "${GREEN}\n=====\n=====\n${NC}"
  exit
  
fi

if [ "$mode" = "render" ]
then
  echo "render mode"
  # render 2>&1 | tee deploy/last.log
fi

if [ "$mode" = "deploy" ]
then
  echo "deploy mode"
  # deploy 2>&1 | tee deploy/last.log
fi

if [ "$mode" = "release" ]
then
  echo "release mode"
  # release 2>&1 | tee deploy/last.log
fi

if [ "$mode" = "restore" ]
then
  echo "restore mode"
  # restore 2>&1 | tee deploy/last.log
fi


## add deployment info to docs/REAMDE.md
# logger # $mode
