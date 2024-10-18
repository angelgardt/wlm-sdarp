#!/bin/bash

## copy part template to book
source deploy/modules/_set-colors.sh

## printf "${BLUE}new ${GRAY}deploy/logs${BLUE} created\n${NC}"
if [ $# = 0 ]
then
  printf "${RED}=====\n"
  printf "nothing was created\nno inline arguments\n"
  printf "=====${NC}\n"
  exit
fi


if [ $1 = 'help' ]
then
  printf "${BLUE}=====\n"
  printf "COMMAND STRUCTURE\n"
  printf "${GRAY}PART\n"
  printf "dev/run/new.sh part <part name>\n"
  printf "${BLUE}-----\n"
  printf "${GRAY}CHAPTER\n"
  printf "dev/run/new.sh chapter <chapter name> <part name>\n"
  printf "${BLUE}-----\n"
  printf "${GRAY}QUIZ\n"
  printf "dev/run/new.sh quiz <quiz name>\n"
  printf "${BLUE}-----\n"
  printf "${GRAY}SHEET\n"
  printf "dev/run/new.sh sheet <sheet name>\n"
  printf "${BLUE}=====${NC}\n"
  exit
fi

if [ $1 = "part" ]
then
  
  if [ -f `echo book/part-"$2".qmd` ]
  then
    printf "${RED}=====\n"
    printf "nothing was created\nfile `echo book/part-"$2".qmd` exists\n"
    printf "=====${NC}\n"
    exit
  fi
  
  cp dev/_templates/part.qmd `echo book/part-"$2".qmd`
  mkdir `echo book/img/part-"$2"`
  mkdir `echo book/tbl/part-"$2"`
  
  printf "${GREEN}=====\n"
  printf "part ${GRAY}${2}${GREEN} was created\n"
  printf "=====${NC}\n"

elif [ $1 = "chapter" ]
then
  
  if [ -z "$3" ]
  then
    printf "${RED}=====\n"
    printf "nothing was created\nno part name\n"
    printf "=====${NC}\n"
    exit
  fi
  
  if [ -f `echo book/"$3"-"$2".qmd` ]
  then
    printf "${RED}=====\n"
    printf "nothing was created\nfile `echo book/"$3"-"$2".qmd` exists\n"
    printf "=====${NC}\n"
    exit
  fi
  
  mkdir `echo book/img/"$3"-"$2"`
  mkdir `echo book/tbl/"$3"-"$2"`
  cp dev/_templates/chapter.qmd `echo book/"$3"-"$2".qmd`
  
  printf "${GREEN}=====\n"
  printf "chapter ${GRAY}${2}${GREEN} in part ${GRAY}${3}${GREEN} was created\n"
  printf "=====${NC}\n"
  
elif [ $1 = "quiz" ]
then
  
  if [ -f `echo book/quiz-"$2".qmd` ]
  then
    printf "${RED}=====\n"
    printf "nothing was created\nfile `echo book/quiz-"$2".qmd` exists\n"
    printf "=====${NC}\n"
    exit
  fi
  
  mkdir `echo book/img/quiz-"$2"`
  mkdir `echo book/tbl/quiz-"$2"`
  cp dev/_templates/quiz.qmd `echo book/quiz-"$2".qmd`
  
  printf "${GREEN}=====\n"
  printf "quiz ${GRAY}${2}${GREEN} was created\n"
  printf "=====${NC}\n"
  
elif [ $1 = "sheet" ]
then

  if [ -f `echo book/sheet-"$2".qmd` ]
  then
    printf "${RED}=====\n"
    printf "nothing was created\nfile `echo book/sheet-"$2".qmd` exists\n"
    printf "=====${NC}\n"
    exit
  fi
  
  mkdir `echo book/img/sheet-"$2"`
  mkdir `echo book/tbl/sheet-"$2"`
  cp dev/_templates/sheet.qmd `echo book/sheet-"$2".qmd`
  
  printf "${GREEN}=====\n"
  printf "sheet ${GRAY}${2}${GREEN} was created\n"
  printf "=====${NC}\n"
  
else

  printf "${RED}=====\n"
  printf "nothing was created\nunknown first inline argument\n"
  printf "=====${NC}\n"
  exit
  
fi
