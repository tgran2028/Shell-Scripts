#!/bin/bash

DATA_DIR="$HOME/.var/app/com.google.ChromeDev/config/google-chrome-unstable"
URL='https://chat.openai.com/chat'

flatpak run com.google.ChromeDev "$URL"

