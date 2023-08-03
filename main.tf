terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "mysql_too_many_connections_incident" {
  source    = "./modules/mysql_too_many_connections_incident"

  providers = {
    shoreline = shoreline
  }
}