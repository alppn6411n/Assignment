resource "azurerm_virtual_network" "vnet" {
  name                = "${terraform.workspace}-vnet"
  resource_group_name = var.resource_group
  location            = var.location
  address_space       = [var.vnetaddr]
  tags = {
    env = "${terraform.workspace}"
  }
}

resource "azurerm_subnet" "web" {
  name                 = "${terraform.workspace}-web"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group
  address_prefixes     = [var.subnetweb]
}

resource "azurerm_subnet" "app" {
  name                 = "${terraform.workspace}-app"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group
  address_prefixes     = [var.subnetapp]
}

resource "azurerm_subnet" "db" {
  name                 = "${terraform.workspace}-db"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group
  address_prefixes     = [var.subnetdb]
}

resource "azurerm_subnet" "mgmt" {
  name                 = "${terraform.workspace}-mgmt"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group
  address_prefixes     = [var.subnetmgmt]
}