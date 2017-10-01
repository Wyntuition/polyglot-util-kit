DATE=`date +%Y-%m-%d`
FILENAME=postgres-backup-$DATE.sql
HOST=<ENTER>
if [ $1 ]; then 
  HOST=$1
fi 
DATABASE_NAME=postgres
if [ $2 ]; then 
  DATABASE_NAME=$2
fi 

### just includes a single database's objects (not users, etc)
pg_dump --file $FILENAME --host $HOST --port "5434" --username "postgres" --verbose --format=c --blobs $DATABASE_NAME

### includes all database and other objects
# pg_dumpall -U postgres -h $HOST -p 5434 --clean --file $FILENAME

### Copy it to S3 after backup
# aws s3 cp $FILENAME s3://defic-svc-db-backups
# aws s3 ls s3://defic-svc-db-backups