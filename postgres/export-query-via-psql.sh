##################################################################################################
# USAGE:
# Call script passing a select statement in single quotes, and receive a CSV (called output.csv for now)
#
# EXAMPLE:
#
#   ./export-data-via-psql.sh 'select * from dms_vis.cps_case_header'
#
# This will run that select statement and copy the rows into a CSV file called output.csv
##################################################################################################

if [ $# -eq 0 ] 
    then
        echo "Please supply the SQL statement in single-quotes as the first argument"
        exit
fi

SELECT_STATEMENT=$1
FILENAME=output.csv

DATABASE_URL=nonprod-eve-cases-data-rds.cl7qgmw8a7t0.us-east-1.rds.amazonaws.com
DATABASE_NAME=eve_cases_data_nonprod
DATABASE_USERNAME=evecasesdata

psql -h $DATABASE_URL -p 5432 -d $DATABASE_NAME -U $DATABASE_USERNAME --password -c "Copy ($SELECT_STATEMENT) To STDOUT With CSV HEADER DELIMITER ',';" > $FILENAME
