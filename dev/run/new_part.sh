#!/bin/bash

## copy part template to book

if [ $# = 0 ]
then
  echo "====="
  echo "part was not created"
  echo "no name for the part"
  echo "==="
  echo
  exit
fi

cp dev/_templates/part.qmd `echo book/part-"$1".qmd`
