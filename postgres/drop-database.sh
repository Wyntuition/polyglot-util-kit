USER=dev
DB=db

psql -U $USER -d postgres  -c "drop database ${DB}"