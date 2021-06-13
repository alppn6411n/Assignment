resource "azurerm_network_security_group" "web" {
  name                = "web"
  location            = var.location
  resource_group_name = var.resource_group
  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "80"
  }
  security_rule {
    name                       = "HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443"
  }
  security_rule {
    name                       = "SSH"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.subnetmgmt
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
  }
  security_rule {
    name                       = "allow-subnet-http"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.subnetweb
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "80"
  }
  security_rule {
    name                       = "allow-subnet-https"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.subnetweb
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443"
  }
  security_rule {
    name                       = "deny-vnet"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
    destination_port_range     = "*"
  }
  tags = {
    env  = "${terraform.workspace}"
    tier = "web"
  }
}

resource "azurerm_subnet_network_security_group_association" "web-nsg-subnet" {
  subnet_id                 = var.web_subnet_id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_network_security_group" "app" {
  name                = "app"
  location            = var.location
  resource_group_name = var.resource_group
  security_rule {
    name                       = "allow-web-tier"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.subnetweb
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "8080"
  }
  security_rule {
    name                       = "allow-subnet"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.subnetapp
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "8080"
  }
  security_rule {
    name                       = "SSH"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.subnetmgmt
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
  }
  security_rule {
    name                       = "deny-vnet"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
    destination_port_range     = "*"
  }
  tags = {
    env  = "${terraform.workspace}"
    tier = "app"
  }
}

resource "azurerm_subnet_network_security_group_association" "app-nsg-subnet" {
  subnet_id                 = var.app_subnet_id
  network_security_group_id = azurerm_network_security_group.app.id
}


resource "azurerm_network_security_group" "db" {
  name                = "db"
  location            = var.location
  resource_group_name = var.resource_group
  security_rule {
    name                       = "allow-app-tier"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.subnetapp
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "3306"
  }
  security_rule {
    name                       = "allow-subnet"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.subnetdb
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "3306"
  }
  security_rule {
    name                       = "SSH"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.subnetmgmt
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
  }
  security_rule {
    name                       = "deny-vnet"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
    destination_port_range     = "*"
  }
  tags = {
    env  = "${terraform.workspace}"
    tier = "db"
  }
}

resource "azurerm_subnet_network_security_group_association" "db-nsg-subnet" {
  subnet_id                 = var.db_subnet_id
  network_security_group_id = azurerm_network_security_group.db.id
}


resource "azurerm_network_security_group" "mgmt" {
  name                = "mgmt"
  location            = var.location
  resource_group_name = var.resource_group
  security_rule {
    name                       = "allow-ssh-only"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
  }
  security_rule {
    name                       = "deny-vnet"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
    destination_address_prefix = "VirtualNetwork"
    destination_port_range     = "*"
  }
  tags = {
    env  = "${terraform.workspace}"
    tier = "mgmt"
  }
}

resource "azurerm_subnet_network_security_group_association" "mgmt-nsg-subnet" {
  subnet_id                 = var.mgmt_subnet_id
  network_security_group_id = azurerm_network_security_group.mgmt.id
}