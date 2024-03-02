#!/bin/bash

###############################################################################
# usage: shfmt [flags] [path ...]

# shfmt formats shell programs. If the only argument is a dash ('-') or no
# arguments are given, standard input will be used. If a given path is a
# directory, all shell scripts found under that directory will be used.

#   --version  show version and exit

#   -l,  --list      list files whose formatting differs from shfmt's
#   -w,  --write     write result to file instead of stdout
#   -d,  --diff      error with a diff when the formatting differs
#   -s,  --simplify  simplify the code
#   -mn, --minify    minify the code to reduce its size (implies -s)

# Parser options:

#   -ln, --language-dialect str  bash/posix/mksh/bats, default "auto"
#   -p,  --posix                 shorthand for -ln=posix
#   --filename str               provide a name for the standard input file

# Printer options:

#   -i,  --indent uint       0 for tabs (default), >0 for number of spaces
#   -bn, --binary-next-line  binary ops like && and | may start a line
#   -ci, --case-indent       switch cases will be indented
#   -sr, --space-redirects   redirect operators will be followed by a space
#   -kp, --keep-padding      keep column alignment paddings
#   -fn, --func-next-line    function opening braces are placed on a separate line

# Utilities:

#   -f, --find   recursively find all shell files and print the paths
#   --to-json    print syntax tree to stdout as a typed JSON
#   --from-json  read syntax tree from stdin as a typed JSON

# For more information, see 'man shfmt' and https://github.com/mvdan/sh.
###############################################################################

shfmt_args=(
    -ln bash # bash dialect
    -i 0     # tabs
    -ci      # indent case statements
    -sr      # space redirect operators
    -kp      # keep column alignment paddings
    -bn      # binary ops like && and | may start a line
)

parse_args() {
    local ln=bash
    local i=0
    local filename
    local write

    while [[ $# -gt 0 ]]; do
        case "$1" in
        -ln | --language-dialect)
            ln="$2"
            shift 2
            ;;
        -i | --indent)
            i="$2"
            shift 2
            ;;
        -w | --write)
            write=1
            shift
            ;;
        --filename)
            filename="$2"
            shift 2
            ;;
        *)
            shift
            ;;
        esac
    done

    declare -a shfmt_args=(
        -ln "$ln"
        -i "$i"
        -ci # indent case statements
        -sr # space redirect operators
        -kp # keep column alignment paddings
        -bn # binary ops like && and | may start a line
    )

    # -w,--write
    [[ -n "$write" ]] && shfmt_args+=(-w)

    # --filename
    [[ -n "$filename" ]] && shfmt_args+=(--filename "$filename")

    echo "${shfmt_args[@]}"
}

# only if this script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    args=$(parse_args "$@")
    # last arg as filename
    echo "shfmt ${args[*]} ${@: -1}" | bat -l sh -P --plain
    zsh -c "shfmt ${args[*]} ${@: -1}"
fi
