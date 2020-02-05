#!/usr/bin/env bash

# Render proxy.conf
erb "nginx/${INGRESS_TYPE}.conf.erb" > /etc/nginx/sites-enabled/proxy.conf

# TODO: need more research into how stopping a Docker container affects open
# ssh processes; this clean up may not be necessary.

# Close any open SSH tunnels
cleanup() {
  echo "Cleaning up..."
  echo "- Terminating SSH tunnels"
  for each in `pgrep -f 'ssh -L'`; do
    kill $each
  done
}

# Clean up before exiting container
trap 'cleanup' SIGTERM
trap 'cleanup' SIGINT


### START SCRIPT ###

# Edit /etc/hosts:
# You can't edit /etc/hosts in place in a Docker container with sed because of
# the way Docker mounts work; you can, however, replace it with a new file.

proxied_urls=`cat envs/${INGRESS_TYPE}.env | tr "\n" " "`

cp /etc/hosts .
sed -i "s/127\.0\.0\.1\tlocalhost$/127\.0\.0\.1\tlocalhost ${proxied_urls}/" hosts
cp hosts /etc/hosts

echo "Setting up the following SSH tunnels:"
INGRESS_SSH_KEY=./ssh_key.pem

# Set up the SSH tunnels
# We can't bind to the actual INGRESS_START_PORT value, since that's being used by nginx, so bind to port+1000 instead
port=$INGRESS_START_PORT
for entry in `cat envs/${INGRESS_TYPE}.env`; do
  host=`echo $entry | cut -d' ' -f2`

  ssh -i $INGRESS_SSH_KEY -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -L $((port+1000)):$host:443 ubuntu@$INGRESS_BASTION_IP -4 -f -N > "${host}_out" 2>&1 | tee -a "${host}_out"

  if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo "  https://localhost:${port}, http://${INGRESS_TYPE}-ingress:$((port+100))  ->  https://$host"
    port=$((port+1))
  elif grep -q "resolve hostname" "${host}_out"; then
    echo " SSH Tunnel for ${entry} failed with the following status:"
    echo "   `less ${host}_out | cut -c6-`"
    echo
    echo "   - Are you using and referencing the correct bastion hostname?"
    echo "   - Is your bastion still available?"
    echo " Exiting..."
    exit 1
  else
    echo " SSH Tunnel for ${entry} failed with the following status:"
    echo "   `tail -n 1 ${host}_out`"
    echo
    echo "   - Are you using and referencing the correct SSH Key?"
    echo " Exiting..."
    exit 1
  fi
done

exec nginx -g 'daemon off;' & wait
