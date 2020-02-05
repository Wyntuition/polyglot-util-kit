function docker-login-fix() {
    CONFIG_FILE="${HOME}/.docker/config.json"
    echo "Checking for docker config file..." >&2
    if [[ ! -f "$CONFIG_FILE" ]]
    then
        echo "Docker config file, $CONFIG_FILE, not found. Exiting." >&2
        exit 1
    fi
    echo "Checking for jq..."
    if ! command -v jq &>/dev/null
    then
        echo "Utility jq not found. Installing..."
        brew install jq
    fi
    echo "Cleaning value for 'auths' attribute..." >&2
    jq '.auths |= {}' < "$CONFIG_FILE" > "$CONFIG_FILE".tmp && mv "$CONFIG_FILE".tmp "$CONFIG_FILE"
    echo "Fix Complete." >&2
}