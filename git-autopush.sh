#!/bin/bash

export HOME=/root

REPO="/mnt/storage/www"
PUSHOVER="/mnt/storage/scripts/pushover"

error_handler() {
    local exit_code=$?
    local line_no=$1
    local message="git-autopush Fehler in Zeile ${line_no}: ${BASH_COMMAND} (Exit-Code ${exit_code})"

    "$PUSHOVER" 2 "$message"
    echo "$message" >&2
    exit "$exit_code"
}

trap 'error_handler $LINENO' ERR

cd "$REPO"

if [ -z "$(git status --porcelain)" ]; then
    exit 0
fi

git add -A

git commit -m "Automatisches Backup $(date '+%Y-%m-%d %H:%M:%S')"

git push
