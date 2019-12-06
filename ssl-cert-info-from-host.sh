$HOSTNAME=xyz.abc.org
$PORT=443

echo | openssl s_client -showcerts -servername  -connect $HOSTNAME:$PORT 2>/dev/null | openssl x509 -inform pem -noout -text
