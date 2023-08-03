#!/bin/bash

# Get the list of idle MySQL connections

IDLE_CONNECTIONS=$(mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW PROCESSLIST" | awk '{if ($6 == "Sleep") print $1}')

# Terminate idle connections

for connection in $IDLE_CONNECTIONS

do

    mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -e "KILL $connection"

done

echo "Idle MySQL connections terminated."