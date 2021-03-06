#!/bin/sh

# Run the following from a directory containing multiple git repositories underneath it

function repo_states () {
  CURRENT_PATH="$(pwd)"
  for repo in $CURRENT_PATH/*/; do
    cd "$repo"
    if [ -d .git ]; then
        REPO_NAME=${repo//$CURRENT_PATH/}
        printf '%-40s' "$REPO_NAME"
        ( git status --short --branch )
    fi
  done
}

repo_states
