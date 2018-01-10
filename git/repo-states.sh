# Run the following from a directory containing multiple git repositories
# The `28` in the printf command is arbitrary and just matches the number of characters in the longest-named repo I have.
function repo_states () {
  CURRENT_PATH="$(pwd)"
  for repo in $CURRENT_PATH/*/; do
    REPO_NAME=${repo//$CURRENT_PATH/}
    printf '%-28s' "$REPO_NAME"
    ( cd "$repo" && git status --short --branch --untracked-files=no )
  done
}

repo_states