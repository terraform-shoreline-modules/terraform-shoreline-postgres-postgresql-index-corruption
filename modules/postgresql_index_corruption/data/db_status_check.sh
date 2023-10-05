

#!/bin/bash



# Set the database name and path

DB_NAME=${DATABASE_NAME}

DB_PATH=${DATABASE_PATH}



# Check if the database is running

if pgrep "postgres" > /dev/null

then

    echo "Database is running"

else

    echo "Database is not running"

    exit 1

fi



# Check if the database has been vacuumed recently

if [ "$(find $DB_PATH -name "pg_stat_*" -mtime -7)" ]

then

    echo "Database has been vacuumed recently"

else

    echo "Database has not been vacuumed recently"

fi



# Check if the database has been reindexed recently

if [ "$(find $DB_PATH -name "pg_index_*" -mtime -7)" ]

then

    echo "Database has been reindexed recently"

else

    echo "Database has not been reindexed recently"

fi