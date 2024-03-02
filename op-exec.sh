#!/usr/bin/env bash

__op_exe() {
  local CMD

	CMD=/usr/bin/op
	if [[ ! -x $CMD ]];then
	  echo "no op command found at '$CMD'."
	  exit 1
	fi

	$CMD whoami > /dev/null 2>&1
  if [[ $? -eq 1 ]]; then
    eval "$(echo $ONEPW_KEY | $CMD signin)" > /dev/null 2>&1
  fi

  $CMD "$@"
}

__op_exe "$@"

