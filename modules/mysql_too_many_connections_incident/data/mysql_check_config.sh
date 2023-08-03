if [ ! -f $MYSQL_CONF ]; then

  echo "Error: MySQL configuration file not found: $MYSQL_CONF"

  exit 1

fi