
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# MySQL too many connections incident
---

This incident type occurs when the number of concurrent connections to a MySQL database server exceeds the configured limit of 80%. This can lead to performance degradation or even database server crashes, making the application or system that relies on the database server unavailable for the end-users. This type of incident typically requires immediate attention and resolution to restore normal operation of the affected service.

### Parameters
```shell
# Environment Variables

export PASSWORD="PLACEHOLDER"

export USERNAME="PLACEHOLDER"

export MAX_CONNECTIONS="PLACEHOLDER"

export PATH_TO_MYSQL_CONF="PLACEHOLDER"

```

## Debug

### Check MySQL server status
```shell
systemctl status mysql
```

### Check the current number of connections to the MySQL server
```shell
mysql -u ${USERNAME} -p${PASSWORD} -e "SHOW STATUS WHERE `variable_name` = 'Threads_connected';"
```

### Check the maximum number of connections allowed by the MySQL server
```shell
mysql -u ${USERNAME} -p${PASSWORD} -e "SHOW VARIABLES LIKE 'max_connections';"
```

### Check the current MySQL process list to see the active connections
```shell
mysql -u ${USERNAME} -p${PASSWORD} -e "SHOW PROCESSLIST;"
```

### Check the system load average and CPU usage
```shell
top
```

### Check the available memory and swap usage
```shell
free -m
```

### Check the disk space usage
```shell
df -h
```

### Check the MySQL slow query log
```shell
tail -f /var/log/mysql/mysql-slow.log
```

### Check the MySQL error log
```shell
tail -f /var/log/mysql/error.log
```

## Repair

### Define variables
```shell
MYSQL_CONF=${PATH_TO_MYSQL_CONF}  # Replace with the path to your MySQL configuration file

MAX_CONNECTIONS=${MAX_CONNECTIONS}  # Replace with the desired maximum number of connections
```
### Check if the MySQL configuration file exists
```shell
if [ ! -f $MYSQL_CONF ]; then

  echo "Error: MySQL configuration file not found: $MYSQL_CONF"

  exit 1

fi
```
### Replace the max_connections parameter in the MySQL configuration file
```shell
sed -i "s/^max_connections.*/max_connections = $MAX_CONNECTIONS/" $MYSQL_CONF
```

### Restart the MySQL service to apply the changes
```shell
systemctl restart mysql.service  # Replace with the command to restart your MySQL service
```

### Identify and terminate idle connections to the database server to free up resources for other connections.
```shell
#!/bin/bash

# Get the list of idle MySQL connections

IDLE_CONNECTIONS=$(mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW PROCESSLIST" | awk '{if ($6 == "Sleep") print $1}')

# Terminate idle connections

for connection in $IDLE_CONNECTIONS

do

    mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -e "KILL $connection"

done

echo "Idle MySQL connections terminated."

```