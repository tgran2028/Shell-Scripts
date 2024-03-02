#!/usr/bin/env bash

NEW_SCRIPT_DIR="$HOME/.shell/new"
TIMESTAMP="$(date "+%y-%m-%d_%H%M%S")"
UUID=$(uuid)

SCRIPT_PATH="${NEW_SCRIPT_DIR}/${TIMESTAMP}.sh"

touch "${SCRIPT_PATH}" && chmod +x "${SCRIPT_PATH}"

cat << EOF >> "${SCRIPT_PATH}"
#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# ${TIMESTAMP}.sh
#
# @purpose: 
# @descriptin:
# @uuid: ${UUID}
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# Init:
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# Help:
# -----------------------------------------------------------------------------
show_help() {
    cat <<-'EOF'
Quickly search through and highlight files using ripgrep.

Search through files or directories looking for matching regular expressions (or fixed strings with -F), and print the output using bat for an easy and syntax-highlighted experience.

Usage: batgrep [OPTIONS] PATTERN [PATH...]

Arguments:
  [OPTIONS]
          See Options below
  PATTERN
          Pattern passed to ripgrep
  [PATH...]
          Path(s) to search

Options:
  -i, --ignore-case:
          Use case insensitive searching.

  -s, --case-sensitive:
          Use case sensitive searching.

  -S, --smart-case:
          Use smart case searching

  -A, --after-context=[LINES]:
          Display the next n lines after a matched line.

  -B, --before-context=[LINES]:
          Display the previous n lines before a matched line.

  -C, --context=[LINES]:
          A combination of --after-context and --before-context

  -p, --search-pattern:
          Tell pager to search for PATTERN. Currently supported pagers: less.

      --no-follow:
          Do not follow symlinks

      --no-snip:
          Do not show the snip decoration

          This is automatically enabled when --context=0 or when bat --version is less than 0.12.x

      --no-highlight:
          Do not highlight matching lines.

          This is automatically enabled when --context=0.

      --color:
          Force color output.

      --no-color:
          Force disable color output.

      --paging=["never"/"always"]:
          Enable/disable paging.

      --pager=[PAGER]:
          Specify the pager to use.

      --terminal-width=[COLS]:
          Generate output for the specified terminal width.

      --no-separator:
          Disable printing separator between files.

      --rga:
          Use ripgrep-all instead of ripgrep.

Options passed directly to ripgrep:
  -F, --fixed-strings

  -U, --multiline

  -P, --pcre2

  -z, --search-zip

  -w, --word-regexp

      --one-file-system

      --multiline-dotall

      --ignore, --no-ignore

      --crlf, --no-crlf

      --hidden, --no-hidden

  -E --encoding:
          This is unsupported by bat, and may cause issues when trying to display unsupported encodings.

  -g, --glob

  -t, --type

  -T, --type-not

  -m, --max-count

      --max-depth

      --iglob

      --ignore-file
EOF
}

# -----------------------------------------------------------------------------
# Options:
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# Main:
# -----------------------------------------------------------------------------

EOF

echo "${SCRIPT_PATH}"
