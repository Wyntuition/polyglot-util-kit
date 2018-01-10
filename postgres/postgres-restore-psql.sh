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
SCHEMA_NAME=local_vis
if [ $5 ]; then 
  FILENAME=$5
fi

### Restore plain text backup
psql -U $PG_USERNAME -h $HOST -d $DATABASE_NAME -f $FILENAME