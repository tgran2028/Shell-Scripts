#!/usr/bin/env bash
# lsfont.sh

lsfont() {
	: '
    List available fonts families.
    
    Usage: lsfont [grep_args]
    - if no args, then array of font families returned.
    - if args, then output piped to grep and args passed (e.g. "lsfont -i fira" performs case-insensative search for fira)
    '
	if [[ $# -gt 0 ]]; then
		fc-list : family | sort -u | grep "$@"
	else
		fc-list : family | sort -u
	fi
}
