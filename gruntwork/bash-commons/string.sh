#!/usr/bin/env bash

# Identify specific flag passed in arguments.
# Usage: arg_passed OPT_FLAG_1 OPT_FLAG_2 ... OPT_FLAG_N --args "$@"


function flag_passed {
  # option flags (e.g. -h, --help); try to match to passed arguments.
  local -a option_flags=()
  # index to find "-a" or "--args" position; separates option flags from other arguments.
  local -i i=0
  local -i start_pos=0

  # Loop identifies option flags and "--args" position.
  # parse option flags and "--args" position.
  for arg in "$@"; do
    if [[ "$arg" == "--args" ]]; then
      start_pos=$((i + 1))
      break
    else 
    # check that arg starts with '-'
    if [[ "$arg" == -* ]]; then
      option_flags+=("$arg")
    else 
      echo "Error: Option flags must start with '-'."
      exit 1
    fi
    i=$((i + 1))
   fi 

  unset arg
  done

  if [[ $start_pos -eq 0 ]]; then
    echo "Error: No '--args' found in arguments."
    exit 1
  fi

  # Shift positional parameters by start position to ignore option flags and "--".
  shift $start_pos

  # Check if first argument after shift is in option flags.
  for opt_flag in "${option_flags[@]}"; do
    # Echo 0 and return if flag matches first argument after shift.
    if [[ "$opt_flag" == "$1" ]]; then
      echo -n 1
      return
    fi
  done

  # Echo 1 if no match found, indicating flag was not passed before "--".
  echo -n 0
}

  for arg in "$@"; do
    if [[ "$arg" == "--" ]]; then
      break
    fi
    option_flags+=("$arg")
    i=$((i + 1))
  done

  shift $i



}

# check if -h, --help is passed as an argument in any position. Return true (0) if it is, false (1) otherwise.
function parse_help_flag {
  local requested=0
  for arg in "$@"; do
    if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
      requested=1
      break
    fi
  done
  echo -n $requested
}

# Usage: parse_help HELP_TEXT "$@"
# HELP_TEXT: The help text to display if the -h or --help flag is passed.
# "$@": The arguments to parse.
# If the -h or --help flag is passed, print the help text and exit.
function parse_help {
  local -r help_text="$1"

  # check if -h, --help is passed as an argument in any position. Return true (0) if it is, false (1) otherwise.
  _help_flag_passed () {
    local requested=0

    for arg in "$@"; do
      if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
        requested=1
        break
      fi
    done
  
    echo -n $requested
  }
  
  # If the -h or --help flag is passed, print the help text and exit.
  if [[ $(_help_flag_passed "$@") -eq 1 ]]; then
    echo "$help_text"
    exit 0
  fi
}


# Return true (0) if the first string (haystack) contains the second string (needle), and false (1) otherwise.
function string_contains {
  local -r haystack="$1"
  local -r needle="$2"

  [[ "$haystack" == *"$needle"* ]]

}

# Returns true (0) if the first string (haystack), which is assumed to contain multiple lines, contains the second
# string (needle), and false (1) otherwise. The needle can contain regular expressions.
function string_multiline_contains {
  local -r haystack="$1"
  local -r needle="$2"

  echo "$haystack" | grep -q "$needle"
}

# Convert the given string to uppercase
function string_to_uppercase {
  local -r str="$1"
  echo "$str" | awk '{print toupper($0)}'
}

# Strip the prefix from the given string. Supports wildcards.
#
# Example:
#
# string_strip_prefix "foo=bar" "foo="  ===> "bar"
# string_strip_prefix "foo=bar" "*="    ===> "bar"
#
# http://stackoverflow.com/a/16623897/483528
function string_strip_prefix {
  local -r str="$1"
  local -r prefix="$2"
  echo "${str#$prefix}"
}

# Strip the suffix from the given string. Supports wildcards.
#
# Example:
#
# string_strip_suffix "foo=bar" "=bar"  ===> "foo"
# string_strip_suffix "foo=bar" "=*"    ===> "foo"
#
# http://stackoverflow.com/a/16623897/483528
function string_strip_suffix {
  local -r str="$1"
  local -r suffix="$2"

  echo "${str%$suffix}"
}

# Return true if the given response is empty or "null" (the latter is from jq parsing).
function string_is_empty_or_null {
  local -r response="$1"
  [[ -z "$response" || "$response" == "null" ]]
}


# Given a string $str, return the substring beginning at index $start and ending at index $end.
#
# Example:
#
# string_substr "hello world" 0 5
#   Returns "hello"
function string_substr {
  local -r str="$1"
  local -r start="$2"
  local end="$3"

  if [[ "$start" -lt 0 || "$end" -lt 0 ]]; then
    log_error "In the string_substr bash function, each of \$start and \$end must be >= 0."
    exit 1
  fi

  if [[ "$start" -gt "$end" ]]; then
    log_error "In the string_substr bash function, \$start must be < \$end."
    exit 1
  fi

  if [[ -z "$end" ]]; then
    end="${#str}"
  fi

  echo "${str:$start:$end}"
}

extract_numbers() {
  local -r str="$1"
  echo "$str" | tr -dc '0-9'
}

