#!/usr/bin/env bash
#
# Get dump of database
# USAGE:
#   postgres-backup.sh <HOSTNAME> <PG_USERNAME> <DATABASE_NAME> <SCHEMA_NAME>
#

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
SCHEMA_NAME=local_vis
if [ $4 ]; then 
  SCHEMA_NAME=$4
fi

### just includes a single database's objects (not users, etc)
#pg_dump --file $FILENAME --host $HOST --port "5432" --username $PG_USERNAME --verbose --format=c -d $DATABASE_NAME -n $SCHEMA_NAME

### includes all database and other objects
pg_dumpall -U postgres -h $HOST -p 5434 --clean --file $FILENAME

### Copy it to S3 after backup
# aws s3 cp $FILENAME s3://defic-svc-db-backups
# aws s3 ls s3://defic-svc-db-backups