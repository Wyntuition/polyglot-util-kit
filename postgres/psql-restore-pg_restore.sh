#!/usr/bin/env bash
#
# Restore dump (binary or text)
# USAGE:
#   postgres-backup.sh <HOSTNAME> <PG_USERNAME> <DATABASE_NAME> <SCHEMA_NAME>
#
# EXAMPLE: ./postgres-restore-pg_restore.sh localhost dev db postgres-backup.sql

DATE=`date +%Y-%m-%d`

HOST=localhost
if [ $1 ]; then 
  HOST=$1
fi 
PG_USERNAME=dev
if [ $2 ]; then 
  PG_USERNAME=$2
fi
DATABASE_NAME=db
if [ $3 ]; then 
  DATABASE_NAME=$3
fi
FILENAME=postgres-backup-$DATE.sql
if [ $4 ]; then 
  FILENAME=$4
fi 
SCHEMA_NAME=local
if [ $5 ]; then 
  FILENAME=$5
fi

### To restore the binary version of a backup
pg_restore --host $HOST --port "5432" --username $PG_USERNAME --dbname $DATABASE_NAME --verbose $FILENAME