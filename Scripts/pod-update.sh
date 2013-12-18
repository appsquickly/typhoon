#!/bin/bash

SCRIPTS_DIR="$(cd $(dirname "$0") && pwd)"
REPO_ROOT="${SCRIPTS_DIR}/.."
TESTS_DIR="${REPO_ROOT}/Tests"
PODS="${TESTS_DIR}/Pods"
SOURCE="${REPO_ROOT}/Source"

CHECKSUM="$(find "$SOURCE" \! -path "*xcuserdata*" \! -path "*.git" | openssl sha1)"
CHECKSUM_FILE="${REPO_ROOT}/.scripts/pod-update-checksum.txt"
LAST_CHECKSUM="$(cat "$CHECKSUM_FILE")"
COMMAND="pod update"

cd "$TESTS_DIR"

update_checksum() 
{
  echo "$CHECKSUM" > "$CHECKSUM_FILE"
}

# echo "LAST_CHECKSUM is: $LAST_CHECKSUM"
# echo "CURRENT CHECKSUM is: $CHECKSUM"

if [ "$LAST_CHECKSUM" != "$CHECKSUM" ]; then
  echo "Running ${COMMAND}, as source files have changed!"

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
     update_checksum
     exit 0
     else
       echo "${COMMAND} failed."
      exit 1
    fi
    fi
    
  fi

  RVM_COMMAND="$RVM all in $TESTS_DIR do $COMMAND"
  echo "Running ${RVM_COMMAND}"
  $RVM_COMMAND

  if [ $? -eq 0 ]
  then
    echo "${COMMAND} succeeded."
    update_checksum
  else
    echo "${COMMAND} failed."
    exit 1
  fi
else
  echo "Not running $COMMAND as source files have not changed."
fi


exit 0

