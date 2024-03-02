#!/usr/bin/env bash

set -e

# __conda_repoquery_search() {

#     local CHANNELS ARGS EXTRA_CHANNELS
#     local EXACT=false
#     local JSON=false
#     local QUIET=false
#     local ALL_CHANNELS=false
#     local TERM=0

#     declare -a CHANNELS=()
#     declare -a EXTRA_CHANNELS=()
#     declare -a ARGS=()

#     # while getopts "cnpeh" opt; do
#     #     case $opt in
#     #         c)
#     #             CHANNELS+=("conda-forge")
#     #             ;;
#     #         n)
#     #             CHANNELS+=("nvidia")
#     #             ;;
#     #         p)
#     #             CHANNELS+=("pytorch")
#     #             ;;
#     #         e)
#     #             EXACT=true
#     #             ;;
#     #         h)
#     #             display_help
#     #             exit 0
#     #             ;;
#     #         \?)
#     #             echo "Invalid option: -$OPTARG" >&2
#     #             return 1
#     #             ;;
#     #         :)
#     #             echo "Option -$OPTARG requires an argument." >&2
#     #             return 1
#     #             ;;
#     #     esac
#     # done

#     __display_help() {
#         cat <<EOF
# Usage: conda_repoquery_search [OPTIONS] SEARCH_TERM

#     Options:
#     -h, --help                     Show this message and exit
#     -e, --exact                    Exact search
#     -j, --json                     Output in JSON format
#     -q, --quiet                    Do not display progress bar
#     -p, --platform                 Search for a package on a specific platform

#     Channels:
#     -c, --channel <CHANNEL>    Search on a specific channel
#     -cf, --conda-forge         Search on conda-forge
#     -nv, --nvidia              Search on nvidia
#     -pt, --pytorch             Search on pytorch
#     -a   --all-channels        Search conda-forge, nvidia, and pytorch, and any additional channels specified with -c

# EOF

#     }

#     # shift $((OPTIND -1))
#     # Use getopt to parse options
#     # local options
#     # options=$(getopt -o h --long help -- "$@")
#     # [ $? -eq 0 ] || {
#     #     echo "Error: Incorrect option provided"
#     #     exit 1
#     # }

#     # # echo "${options[*]}"

#     # eval set -- "$options"

#     while true; do
#         case "$1" in
#         -h | --help)
#             __display_help
#             exit 0
#             ;;
#         -cf | --conda-forge)
#             [[ $ALL_CHANNELS == false ]] && CHANNELS+=("conda-forge")
#             shift
#             break
#             ;;
#         -nv | --nvidia)
#             [[ $ALL_CHANNELS == false ]] && CHANNELS+=("nvidia")
#             shift
#             break
#             ;;
#         -pt | --pytorch)
#             [[ $ALL_CHANNELS == false ]] && CHANNELS+=("pytorch")
#             shift
#             break
#             ;;
#         -e | --exact)
#             EXACT=true
#             shift
#             break
#             ;;
#         # option --channel $argument
#         -c | --channel)
#             EXTRA_CHANNELS+=("$2")
#             shift 2
#             ;;
#         -j | --json)
#             ARGS+=("--json")
#             JSON=true
#             shift
#             break
#             ;;
#         -q | --quiet)
#             ARGS+=("--quiet")
#             QUIET=true
#             shift
#             break
#             ;;
#         -p | --platform)
#             ARGS+=("--platform" "$2")
#             shift 2
#             ;;
#         -a | --all-channels)
#             ALL_CHANNELS=true
#             CHANNELS+=("conda-forge" "nvidia" "pytorch")
#             shift
#             ;;
#         --)
#             shift
#             break
#             ;;
#         *)
#             # if [ "$TERM" -eq 0 ]; then
#             #     TERM="$1"
#             #     shift
#             #     break
#             # else
#             #     echo "Error: Incorrect option provided"
#             #     exit 1
#             # fi
#             # ;;
#             echo "Unparsed option: $1"
#             shift
#             ;;
#         esac
#     done

#     # get last argument
#     if [[ $# -gt 0 ]]; then
#         TERM="${@: -1}"
#         # echo "TERM: $TERM"
#     else
#         echo "Error: No search term provided"
#         exit 1
#     fi
#     echo "TERM: $TERM"

#     # add extra channels to CHANNELS
#     if [[ ${#EXTRA_CHANNELS[@]} -gt 0 ]]; then
#         CHANNELS+=("${EXTRA_CHANNELS[@]}")
#     fi
#     # if CHANNELS has no elements, add conda-forge
#     if [ ${#CHANNELS[@]} -eq 0 ]; then
#         CHANNELS+=("conda-forge")
#     fi
#     # add to repoquery arguments
#     for i in "${CHANNELS[@]}"; do
#         ARGS+=("-c" "$i")
#     done

#     # if not exact, wrap $TERM with *
#     if [[ $EXACT == false ]]; then
#         TERM="*${TERM}*"
#     fi
#     ARGS+=("'${TERM}'")

#     echo "conda repoquery search ${ARGS[*]}"
# }

# __conda_repoquery_search "$@"

BOLD='\033[1m'
ITALIC='\033[3m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# echo_with_style() {
#   local style_color="$1"
#   local label="$2"
#   local message="$3"

#   echo -e "${style_color}${ITALIC}${label}${NC}::${style_color}${BOLD}${message}${NC}"
# }

conda_rqs:success_msg() {
  echo -e "${GREEN}${ITALIC}success${NC}::${GREEN}${BOLD}$@${NC}"
}

conda_rqs:verbose_msg() {
  echo -e "${YELLOW}${ITALIC}verbose${NC}::${YELLOW}${BOLD}$@${NC}"
}

conda_rqs:error_msg() {
  echo -e "${RED}${ITALIC}error${NC}::${RED}${BOLD}$@${NC}"
}

__conda_repoquery_search() {

  local CHANNELS ARGS EXTRA_CHANNELS TERM RES
  local EXACT=false
  local JSON=${CONDA_REPOQUERY_JSON:-false}
  local QUIET=${CONDA_REPOQUERY_QUIET:-false}
  local ALL_CHANNELS=false
  local PRETTY=false
  local VERBOSE=false
  local DRY_RUN=false

  declare -a CHANNELS=()
  declare -a EXTRA_CHANNELS=()
  declare -a ARGS=()

  __display_help() {
    cat << EOF
Usage: conda_repoquery_search [OPTIONS] SEARCH_TERM

Options:
-h, --help                     Show this message and exit.
-e, --exact                    Perform an exact search.
-j, --json                     Output results in JSON format. Can be set via CONDA_REPOQUERY_JSON environment variable.
-q, --quiet                    Enable quiet mode, no output except for errors. Can be set via CONDA_REPOQUERY_QUIET environment variable.
-p, --platform <PLATFORM>      Search for packages on a specific platform (e.g., linux-64, osx-64).
-v, --verbose                  Enable verbose messaging for debugging.
-d, --dry-run                  Only display the final search command without executing it.

Channels:
-c,  --channel <CHANNEL>       Specify additional channels to search.
-cf, --conda-forge             Include the conda-forge channel in the search.
-nv, --nvidia                  Include the Nvidia channel in the search.
-pt, --pytorch                 Include the PyTorch channel in the search.
-a,  --all-channels            Search across all default channels (conda-forge, nvidia, pytorch) and any specified with -c.

Miscellaneous:
    --pretty                   Produce pretty-printed JSON output (requires the 'jq' utility).
EOF
  }

  [[ "$JSON" -eq "1" ]] && JSON=true
  [[ "$QUIET" -eq "1" ]] && QUIET=true
  [[ "$ALL_CHANNELS" -eq "1" ]] && ALL_CHANNELS=true
  [[ "$EXACT" -eq "1" ]] && EXACT=true
  [[ "$PRETTY" -eq "1" ]] && PRETTY=true
  [[ "$VERBOSE" -eq "1" ]] && VERBOSE=true
  [[ "$DRY_RUN" -eq "1" ]] && DRY_RUN=true

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -h | --help)
        __display_help
        return 0
        ;;
      -cf | --conda-forge)
        if [[ $ALL_CHANNELS == false ]]; then CHANNELS+=("conda-forge"); fi
        shift
        ;;
      -nv | --nvidia)
        if [[ $ALL_CHANNELS == false ]]; then CHANNELS+=("nvidia"); fi
        shift
        ;;
      -pt | --pytorch)
        if [[ $ALL_CHANNELS == false ]]; then CHANNELS+=("pytorch"); fi
        shift
        ;;
      -e | --exact)
        EXACT=true
        shift
        ;;
      -c | --channel)
        EXTRA_CHANNELS+=("$2")
        shift 2
        ;;
      -j | --json)
        JSON=true
        ARGS+=("--json")
        shift
        ;;
      -q | --quiet)
        QUIET=true
        ARGS+=("--quiet")
        shift
        ;;
      --platform)
        ARGS+=("--platform" "$2")
        shift 2
        ;;
      -p | --pretty)
        PRETTY=true
        shift
        ;;
      -a | --all-channels)
        ALL_CHANNELS=true
        CHANNELS=("conda-forge" "nvidia" "pytorch")
        shift
        ;;
      -v | --verbose)
        VERBOSE=true
        shift
        ;;
      -d | --dry-run)
        DRY_RUN=true
        shift
        ;;
      --)
        shift
        break
        ;;
      *)
        # Capture TERM if it is not a flag; otherwise print error and exit
        if [[ "$1" =~ ^- ]]; then
          echo "Error: Invalid option $1"
          return 1
        elif [[ -z "$TERM" ]]; then
          TERM="$1"
        else
          echo "Error: Multiple search terms provided"
          return 1
        fi
        shift
        ;;
    esac
  done

  if [[ $VERBOSE == true ]]; then
    conda_rqs:verbose_msg "ALL PASSED ARGS: $@"
    conda_rqs:verbose_msg "TERM: $TERM"
    conda_rqs:verbose_msg "CHANNELS: ${CHANNELS[*]}"
    conda_rqs:verbose_msg "EXTRA_CHANNELS: ${EXTRA_CHANNELS[*]}"
    conda_rqs:verbose_msg "EXACT: $EXACT"
    conda_rqs:verbose_msg "JSON: $JSON"
    conda_rqs:verbose_msg "QUIET: $QUIET"
    conda_rqs:verbose_msg "ARGS: ${ARGS[*]}"
    conda_rqs:verbose_msg "ALL_CHANNELS: $ALL_CHANNELS"
    conda_rqs:verbose_msg "PRETTY: $PRETTY"
    conda_rqs:verbose_msg "VERBOSE: $VERBOSE"
  fi

  # Ensure TERM was supplied
  if [[ -z "$TERM" ]]; then
    echo "Error: No search term provided"
    return 1
  fi

  # Add extra channels to CHANNELS unless ALL_CHANNELS is true
  if [[ $ALL_CHANNELS == false && ${#EXTRA_CHANNELS[@]} -gt 0 ]]; then
    CHANNELS+=("${EXTRA_CHANNELS[@]}")
  fi

  # If CHANNELS has no elements due to ALL_CHANNELS being false and no other channels specified, add default conda-forge
  if [[ ${#CHANNELS[@]} -eq 0 ]]; then
    CHANNELS+=("conda-forge")
  fi

  # Add channels to repoquery arguments
  for i in "${CHANNELS[@]}"; do
    ARGS+=("-c" "$i")
  done

  if [[ $EXACT == false ]]; then
    TERM="*${TERM}*"
  else
    # remove single and doubld quotes if they exist
    TERM="${TERM//\"/}"
    TERM="${TERM//\'/}"
  fi

  if [[ $VERBOSE == true ]]; then
    conda_rqs:verbose_msg "TERM (post-processing): $TERM"
  fi

  # Add search term to ARGS
  ARGS+=("${TERM}")

  if [[ $VERBOSE == true ]]; then
    conda_rqs:verbose_msg "ARGS: ${ARGS[*]}"
    conda_rqs:verbose_msg "COMMAND: \"conda repoquery search ${ARGS[*]}\""
    if [[ $JSON = false ]]; then
      RES="$(conda repoquery search --json ${ARGS[*]})"
    else
      RES="$(conda repoquery search ${ARGS[*]})"
    fi
    echo "$RES" | jq -r '.'
  fi

  if [[ $DRY_RUN == false ]]; then
    set -v
    # Execute the search
    if [[ $JSON = false && $VERBOSE == true ]]; then
      RES="$(conda repoquery search ${ARGS[*]})"
    elif [[ $VERBOSE == false ]]; then
      RES="$(conda repoquery search ${ARGS[*]})"
    fi

    if [[ $JSON = true && $PRETTY = true ]]; then
      echo "$RES" | jq -r '.'
    else
      echo "$RES"
    fi
    set +v
    return 0

  else
    if [[ $VERBOSE == false ]]; then
      if [[ $PRETTY = true ]]; then
        echo "conda repoquery search ${ARGS[*]}" | bat -l bash -P --plain -f
      else
        echo "conda repoquery search ${ARGS[*]}"
      fi
    fi
    return 0
  fi

}

__conda_repoquery_search "$@"
