resource "shoreline_notebook" "mysql_too_many_connections_incident" {
  name       = "mysql_too_many_connections_incident"
  data       = file("${path.module}/data/mysql_too_many_connections_incident.json")
  depends_on = [shoreline_action.invoke_mysql_config_max_connections,shoreline_action.invoke_mysql_check_config,shoreline_action.invoke_terminate_idle_mysql_connections]
}

resource "shoreline_file" "mysql_config_max_connections" {
  name             = "mysql_config_max_connections"
  input_file       = "${path.module}/data/mysql_config_max_connections.sh"
  md5              = filemd5("${path.module}/data/mysql_config_max_connections.sh")
  description      = "Define variables"
  destination_path = "/agent/scripts/mysql_config_max_connections.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "mysql_check_config" {
  name             = "mysql_check_config"
  input_file       = "${path.module}/data/mysql_check_config.sh"
  md5              = filemd5("${path.module}/data/mysql_check_config.sh")
  description      = "Check if the MySQL configuration file exists"
  destination_path = "/agent/scripts/mysql_check_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "terminate_idle_mysql_connections" {
  name             = "terminate_idle_mysql_connections"
  input_file       = "${path.module}/data/terminate_idle_mysql_connections.sh"
  md5              = filemd5("${path.module}/data/terminate_idle_mysql_connections.sh")
  description      = "Identify and terminate idle connections to the database server to free up resources for other connections."
  destination_path = "/agent/scripts/terminate_idle_mysql_connections.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_mysql_config_max_connections" {
  name        = "invoke_mysql_config_max_connections"
  description = "Define variables"
  command     = "`chmod +x /agent/scripts/mysql_config_max_connections.sh && /agent/scripts/mysql_config_max_connections.sh`"
  params      = ["PATH_TO_MYSQL_CONF","MAX_CONNECTIONS"]
  file_deps   = ["mysql_config_max_connections"]
  enabled     = true
  depends_on  = [shoreline_file.mysql_config_max_connections]
}

resource "shoreline_action" "invoke_mysql_check_config" {
  name        = "invoke_mysql_check_config"
  description = "Check if the MySQL configuration file exists"
  command     = "`chmod +x /agent/scripts/mysql_check_config.sh && /agent/scripts/mysql_check_config.sh`"
  params      = []
  file_deps   = ["mysql_check_config"]
  enabled     = true
  depends_on  = [shoreline_file.mysql_check_config]
}

resource "shoreline_action" "invoke_terminate_idle_mysql_connections" {
  name        = "invoke_terminate_idle_mysql_connections"
  description = "Identify and terminate idle connections to the database server to free up resources for other connections."
  command     = "`chmod +x /agent/scripts/terminate_idle_mysql_connections.sh && /agent/scripts/terminate_idle_mysql_connections.sh`"
  params      = []
  file_deps   = ["terminate_idle_mysql_connections"]
  enabled     = true
  depends_on  = [shoreline_file.terminate_idle_mysql_connections]
}

