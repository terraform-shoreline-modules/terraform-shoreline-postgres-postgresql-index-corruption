
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# PostgreSQL Index Corruption
---

PostgreSQL Index Corruption refers to a situation where the indexes of a PostgreSQL database become corrupted or damaged. This can cause problems with database queries, leading to errors and degraded performance. When this occurs, it is usually necessary to repair the indexes to restore the database to its normal state. Failure to address index corruption issues can result in data loss or other serious consequences.

### Parameters
```shell
export DATABASE_NAME="PLACEHOLDER"

export TABLE_NAME="PLACEHOLDER"

export DATABASE_PATH="PLACEHOLDER"

export PATH_TO_BACKUP_FILE="PLACEHOLDER"
```

## Debug

### Check PostgreSQL version
```shell
sudo -u postgres psql -c "SELECT version();"
```

### Check the number of indexes in the database
```shell
sudo -u postgres psql -d ${DATABASE_NAME} -c "\diS+"
```

### Check for index corruption in a specific table
```shell
sudo -u postgres psql -d ${DATABASE_NAME} -c "SELECT * FROM pgstattuple(${TABLE_NAME})"
```

### Check for general corruption in the database
```shell
sudo -u postgres pg_dumpall | gzip -9 > dump.sql.gz && gunzip -c dump.sql.gz | psql ${DATABASE_NAME}
```

### Rebuild all indexes in a specific table
```shell
sudo -u postgres psql -d ${DATABASE_NAME} -c "REINDEX TABLE ${TABLE_NAME};"
```

### Rebuild all indexes in the entire database
```shell
sudo -u postgres psql -d ${DATABASE_NAME} -c "REINDEX DATABASE ${DATABASE_NAME};"
```

### Analyze a specific table to update its statistics
```shell
sudo -u postgres psql -d ${DATABASE_NAME} -c "ANALYZE ${TABLE_NAME};"
```

### Analyze the entire database to update its statistics
```shell
sudo -u postgres psql -d ${DATABASE_NAME} -c "ANALYZE;"
```

### Database maintenance: Incorrect execution of database maintenance tasks, such as vacuuming or reindexing, can cause index corruption.
```shell


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


```

## Repair

### If repair is not possible or does not resolve the issue, consider restoring from a backup of the database that was taken prior to the index corruption issue.
```shell


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


```