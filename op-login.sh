#!/usr/bin/env bash

RES="$(gzip -d -c ~/.1password/.1pwk | op signin --account my)" 2>&1
eval "$RES"
jq -M '.' ~/.config/op/config > ~/.1password/config.json 2>&1
op whoami --format=json | jq -r

echo "-------------------- res --------------------"
echo "$RES"
echo "-------------------- config -----------------"
jq -r .  ~/.1password/config.json


# # Verify if current user is authenticated with 1Password, output the status code.
# __op_try_whoami() {
#     op whoami >/dev/null && echo $?
# }

# # Sign into 1Password using gzipped credentials, store session details, and update config.
# __op_signin() {
#     local KEY VALUE

#     # Authenticate silently with 1Password.
#     #   eval "$(gzip -d -c ~/.1password/.1pwk | op signin --account my)" > /dev/null

#     # Capture OP_SESSION variable for activation.
#     echo "export $(env | grep '^OP_SESSION')" >~/.1password/activate

#     # Extract OP_SESSION key-value pair.
#     KEY="$(printenv | grep '^OP_SESSION' | cut -d'=' -f1)"
#     VALUE="$(printenv | grep '^OP_SESSION' | cut -d'=' -f2)"

#     # Update session details in JSON configuration.
#     jq --arg key "$KEY" --arg value "$VALUE" --arg timestamp "$(date +%s)" \
#         '. + {"session": {"key": $key, "value": $value, "timestamp": ($timestamp | tonumber)}}' \
#         ~/.config/op/config | tee ~/.1password/config.json >/dev/null 2>&1

#     return $?
# }

# # Authenticate and set OP_SESSION variable if not already authenticated.
# __op_signin_setenv() {
#     # Check authentication status with 1Password.
#     op whoami >/dev/null
#     if [[ $? -eq 1 ]]; then
#         __op_signin # Authenticate if necessary.
#     fi

#     # Set environment variable from activation file.
#     [[ -f "$HOME/.1password/activate" ]] && . "$HOME/.1password/activate"

# }

# Initiate sign-in setup with provided arguments.
# __op_signin_setenv "$@"