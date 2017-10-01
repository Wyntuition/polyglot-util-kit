DATE=`date +%Y-%m-%d`
FILENAME=postgres-backup-$DATE.sql
HOST=localhost
if [ $1 ]; then 
  HOST=$1
fi 

psql -U postgres -h $HOST -f deficiencies < $FILENAME

### To restore the binary version of a backup
# pg_restore --host $HOST --port "5434" --username "postgres" --dbname "deficiencies" --verbose "defic-svc-postgres-prod-$DATE.sql"