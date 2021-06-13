provider "azurerm" {
  features {}
}

## Configure terraform state backend
#terraform {
#  backend "azurerm" {
#    resource_group_name   = "tstate"
#    storage_account_name  = "tstate09762"
#    container_name        = "tstate"
#    key                   = "terraform.tfstate"
#  }
#}

module "resource_group" {
  source   = "./mod/resource_group"
  name     = var.rg_name
  location = var.location
}

module "network_setup" {
  source         = "./mod/network_setup"
  resource_group = module.resource_group.resource_group_name
  location       = module.resource_group.location
  vnetaddr       = var.vnetaddr
  subnetweb      = var.subnetweb
  subnetapp      = var.subnetapp
  subnetdb       = var.subnetdb
  subnetmgmt     = var.subnetmgmt
}

module "avset" {
  source         = "./mod/avset"
  resource_group = module.resource_group.resource_group_name
  location       = module.resource_group.location
  web_subnet_id  = module.network_setup.websubnet_id
  app_subnet_id  = module.network_setup.appsubnet_id
  db_subnet_id   = module.network_setup.dbsubnet_id
  mgmt_subnet_id = module.network_setup.mgmtsubnet_id
  webcount       = var.webcount
  appcount       = var.appcount
  dbcount        = var.dbcount
  username       = var.username
  password       = var.password
}

module "alb" {
  source         = "./mod/alb"
  resource_group = module.resource_group.resource_group_name
  location       = module.resource_group.location
  web_subnet_id  = module.network_setup.websubnet_id
  app_subnet_id  = module.network_setup.appsubnet_id
  db_subnet_id   = module.network_setup.dbsubnet_id
  webcount       = var.webcount
  appcount       = var.appcount
  dbcount        = var.dbcount
  depends_on     = [module.avset]
}

module "nsg" {
  source         = "./mod/nsg"
  resource_group = module.resource_group.resource_group_name
  location       = module.resource_group.location
  subnetweb      = var.subnetweb
  subnetapp      = var.subnetapp
  subnetdb       = var.subnetdb
  subnetmgmt     = var.subnetmgmt
  web_subnet_id  = module.network_setup.websubnet_id
  app_subnet_id  = module.network_setup.appsubnet_id
  db_subnet_id   = module.network_setup.dbsubnet_id
  mgmt_subnet_id = module.network_setup.mgmtsubnet_id
}