HOSTNAME=xyz.abc.com
PORT=443

# Details
echo | openssl s_client -showcerts -servername $HOSTNAME -connect $HOSTNAME:$PORT 2>/dev/null | openssl x509 -inform pem -noout -text

# Basic
openssl s_client -host $HOSTNAME -port $PORT -prexit -showcerts