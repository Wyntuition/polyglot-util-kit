#!/bin/sh

##################
# USAGE SYNTAX
#
#     ssh -f <BASTION_USERNAME>@<BASTION_IP> -L <LOCAL PORT>:<TARGET HOST>:<TARGET_PORT> -N -i <PATH_TO_PRIVATE_KEY>
#
# USAGE
#    
# Set connection variables for environments, and run tunneling script like so:
#
#        export BASTION_IP=10.193.181.202
#        export PATH_TO_PRIVATE_KEY=~/.ssh/wv-gfe-prod.pem
#
#        export DB_HOST=perf-save-verification-rds.cubwlfvtgq6h.us-east-1.rds.amazonaws.com
#        export DATABASE_NAME=postgres
#        export USERNAME=savever
#        export LOCAL_PORT=5001
#        export TARGET_PORT=5432
#
#       ./ssh-bastion-tunnel
#
# NOTES
#
#   - View mappings with: sudo lsof -i -n  | grep ssh
#   - Kill all ssh tunnels: pkill ssh
#
##################

if [ ! -z "$1" ] ; then
  BASTION_IP=$1
fi

if [ ! -z "$2" ] ; then
  PATH_TO_PRIVATE_KEY=$2
fi

ssh -f ubuntu@$BASTION_IP -L $LOCAL_PORT:$DB_HOST:$TARGET_PORT -N -i $PATH_TO_PRIVATE_KEY
