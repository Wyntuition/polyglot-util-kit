DATABASE_NAME='postgres'
if [ $1 ]; then 
  DATABASE_NAME=$1
fi 
USERNAME='postgres'
if [ $2 ]; then 
  USERNAME=$2
fi 

docker exec -it postgres psql -h localhost -p 5432 -d $DATABASE_NAME -U $USERNAME --password