#!/usr/bin/env bash
#
# Get dump of schema
# USAGE:
#   postgres-backup.sh <HOSTNAME> <PG_USERNAME> <DATABASE_NAME> <SCHEMA_NAME>
#
# -n schema for specific schema, 
# -F c for custom compressed binary, p for plain text
# -v verbose output
# -n [specific schema]
# -s schema only

DATE=`date +%Y-%m-%d`
FILENAME=postgres-backup-$DATE.sql
HOST=localhost
if [ $1 ]; then 
  HOST=$1
fi 
PG_USERNAME=postgres
if [ $2 ]; then 
  PG_USERNAME=$2
fi
DATABASE_NAME=postgres
if [ $3 ]; then 
  DATABASE_NAME=$3
fi
SCHEMA_NAME=local
if [ $4 ]; then 
  SCHEMA_NAME=$4
fi

### just includes a single database's objects (not users, etc)
pg_dump --file $FILENAME --host $HOST --port "5432" --username $PG_USERNAME --verbose --format=c -d $DATABASE_NAME -n $SCHEMA_NAME
