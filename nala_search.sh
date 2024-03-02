#!/usr/bin/env bash

function nala_search() {
    : '
    nala_search

    Search apt packages using nala command. 

    Usage:
        nala_search $term [--flags]    
    '
    nala search --full "$@" | bat -l log --color=never -P --plain >"/tmp/nala-search-$1.txt"
    code --new-w indow --wait --disable-extensions --disable-gpu "/tmp/nala-search-$1.txt"
}

nala_search "$@"

