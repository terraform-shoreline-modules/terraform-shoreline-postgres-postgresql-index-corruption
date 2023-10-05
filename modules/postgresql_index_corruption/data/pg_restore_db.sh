

#!/bin/bash



# Define variables

DB_NAME=${DATABASE_NAME}

BACKUP_FILE=${PATH_TO_BACKUP_FILE}



# Stop PostgreSQL service

sudo systemctl stop postgresql



# Drop the existing database

sudo -u postgres psql -c "DROP DATABASE IF EXISTS $DB_NAME"



# Create a new database

sudo -u postgres psql -c "CREATE DATABASE $DB_NAME"



# Restore the database from backup

sudo -u postgres pg_restore -d $DB_NAME $BACKUP_FILE



# Restart PostgreSQL service

sudo systemctl start postgresql