#!/bin/bash

PODS="${PROJECT_DIR}/Pods"
REPO_ROOT="${PROJECT_DIR}/.."
SOURCE="${REPO_ROOT}/Source"
CHANGED_SOURCE_FILES="$(find "$SOURCE" \! -path "*xcuserdata*" \! -path "*.git" -newer "$PODS/")"
COMMAND="pod update"

if [ -n "$CHANGED_SOURCE_FILES" ]; then
  echo "Running ${COMMAND}..."
  echo "Because of changed source files:"
  echo "$CHANGED_SOURCE_FILES"
  echo -e "\n"

  RVM="${HOME}/.rvm/bin/rvm"
  if [ ! -x $RVM ]
  then
    echo "WARNING: RVM not found in ${RVM}. Trying to use rbenv..."
    RBENV="${HOME}/.rbenv"
     if [ ! -x $RBENV ]
     then
      echo "ERROR: rbenv not found in ${RBENV}. Unable to run ${COMMAND}."
      exit 0 # don't screw up people with neither rbenv or RVM
    else
      # RBENV is a go!
      RBENV_COMMAND="${RBENV}/shims/${COMMAND}"
      $RBENV_COMMAND
     if [ $? -eq 0 ]
    then
     echo "${COMMAND} succeeded."
     exit 0
     else
       echo "${COMMAND} failed."
      exit 1
    fi
    fi
    
  fi

  RVM_COMMAND="$RVM all in $PROJECT_DIR do $COMMAND"
  echo "Running ${RVM_COMMAND}"
  $RVM_COMMAND

  if [ $? -eq 0 ]
  then
    echo "${COMMAND} succeeded."
  else
    echo "${COMMAND} failed."
    exit 1
  fi
else
  echo "Not running $COMMAND as source files have not changed."
fi

exit 0

