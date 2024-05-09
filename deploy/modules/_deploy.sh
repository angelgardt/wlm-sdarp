#!/bin/bash

function deploy() {
  
  ## exit wtih a non-zero status
  set -e
  
  ## save datetime
  dt=$(date '+%Y-%m-%d_%H-%M-%S')
  render 2>&1 | tee deploy/logs/render_`echo "$dt"`.log
  
  
  
}