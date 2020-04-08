-- Filter by some fields

index="your-index" source="/var/log/docker-container-output.log" "application":"app-name" 503 | regex "level\":\"(?P<errorLevel>)[\"ERROR\"|\"WARN\"]*\"" | regex "environment\":\"(?P<errorEnv>PROD)\""

-- Graph events by a field

<service_name> <error message> <ENV>
| rex field=_raw "user (?<userNumber>[A-Z]{4}[\d]{4})" | timechart count by userNumber span=1m


