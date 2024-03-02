#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 24-03-02_032311.sh
#
# @purpose: 
# @descriptin:
# @uuid: 7d7464ba-d876-11ee-b6c8-1b4f1fb3cfb4
# -----------------------------------------------------------------------------
cd '/home/tim/.local/src/bat-extras/src' || exit 1


declare -a FILES=(
    bat-modules
    batdiff
    batgrep
    batman
    batpipe
    batwatch
    prettybat
)


# -----------------------------------------------------------------------------
# gh gist create --help
# Create a new GitHub gist with given contents.

# Gists can be created from one or multiple files. Alternatively, pass `-` as
# file name to read from standard input.

# By default, gists are secret; use `--public` to make publicly listed ones.


# USAGE
#   gh gist create [<filename>... | -] [flags]

# ALIASES
#   new

# FLAGS
#   -d, --desc string       A description for this gist
#   -f, --filename string   Provide a filename to be used when reading from standard input
#   -p, --public            List the gist publicly (default "secret")
#   -w, --web               Open the web browser with created gist

# INHERITED FLAGS
#   --help   Show help for command

# EXAMPLES
#   # publish file 'hello.py' as a public gist
#   $ gh gist create --public hello.py
  
#   # create a gist with a description
#   $ gh gist create hello.py -d "my Hello-World program in Python"
  
#   # create a gist containing several files
#   $ gh gist create hello.py world.py cool.txt
  
#   # read from standard input to create a gist
#   $ gh gist create -
  
#   # create a gist from output piped from another command
#   $ cat cool.txt | gh gist create

# LEARN MORE
#   Use `gh <command> <subcommand> --help` for more information about a command.
#   Read the manual at https://cli.github.com/manual
# -----------------------------------------------------------------------------

gh gist create 






# -----------------------------------------------------------------------------
# Init:
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# Help:
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Options:
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# Main:
# -----------------------------------------------------------------------------

