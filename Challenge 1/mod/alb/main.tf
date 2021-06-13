resource "azurerm_public_ip" "web" {
  name                = "lb-pubip"
  location            = "eastus"
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  tags = {
    env  = "${terraform.workspace}"
    tier = "web"
  }
}

resource "azurerm_lb" "web" {
  name                = "weblb"
  location            = "eastus"
  resource_group_name = var.resource_group

  frontend_ip_configuration {
    name                 = "web-pubip"
    public_ip_address_id = azurerm_public_ip.web.id
  }
  tags = {
    env  = "${terraform.workspace}"
    tier = "web"
  }
}

resource "azurerm_lb_backend_address_pool" "web" {
  loadbalancer_id = azurerm_lb.web.id
  name            = "web-pool"
}

data "azurerm_network_interface" "web" {
  count               = var.webcount
  name                = "web-nic-${count.index}"
  resource_group_name = var.resource_group
}

resource "azurerm_network_interface_backend_address_pool_association" "web" {
  count                   = var.webcount
  network_interface_id    = data.azurerm_network_interface.web[count.index].id
  ip_configuration_name   = "webip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id
}

resource "azurerm_lb_rule" "web1" {
  resource_group_name            = var.resource_group
  loadbalancer_id                = azurerm_lb.web.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "web-pubip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.web.id
  probe_id                       = azurerm_lb_probe.web1.id
}

resource "azurerm_lb_probe" "web1" {
  resource_group_name = var.resource_group
  loadbalancer_id     = azurerm_lb.web.id
  name                = "http-probe"
  port                = 80
}

resource "azurerm_lb_rule" "web2" {
  resource_group_name            = var.resource_group
  loadbalancer_id                = azurerm_lb.web.id
  name                           = "https-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "web-pubip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.web.id
  probe_id                       = azurerm_lb_probe.web2.id
}

resource "azurerm_lb_probe" "web2" {
  resource_group_name = var.resource_group
  loadbalancer_id     = azurerm_lb.web.id
  name                = "https-probe"
  port                = 443
}




resource "azurerm_lb" "app" {
  name                = "applb"
  location            = "eastus"
  resource_group_name = var.resource_group

  frontend_ip_configuration {
    name                          = "appinternal"
    subnet_id                     = var.app_subnet_id
    private_ip_address            = "10.0.2.11"
    private_ip_address_allocation = "Static"
  }
  tags = {
    env  = "${terraform.workspace}"
    tier = "app"
  }
}

resource "azurerm_lb_backend_address_pool" "app" {
  loadbalancer_id = azurerm_lb.app.id
  name            = "app-pool"
}

data "azurerm_network_interface" "app" {
  count               = var.appcount
  name                = "app-nic-${count.index}"
  resource_group_name = var.resource_group
}

resource "azurerm_network_interface_backend_address_pool_association" "app" {
  count                   = var.appcount
  network_interface_id    = data.azurerm_network_interface.app[count.index].id
  ip_configuration_name   = "appip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.app.id
}

resource "azurerm_lb_rule" "app" {
  resource_group_name            = var.resource_group
  loadbalancer_id                = azurerm_lb.app.id
  name                           = "allow-from-web-tier-rule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "appinternal"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.app.id
  probe_id                       = azurerm_lb_probe.app.id
}

resource "azurerm_lb_probe" "app" {
  resource_group_name = var.resource_group
  loadbalancer_id     = azurerm_lb.app.id
  name                = "web-tier-probe"
  port                = 8080
}



resource "azurerm_lb" "db" {
  name                = "dblb"
  location            = "eastus"
  resource_group_name = var.resource_group

  frontend_ip_configuration {
    name                          = "dbinternal"
    subnet_id                     = var.db_subnet_id
    private_ip_address            = "10.0.3.11"
    private_ip_address_allocation = "Static"
  }
  tags = {
    env  = "${terraform.workspace}"
    tier = "db"
  }
}

resource "azurerm_lb_backend_address_pool" "db" {
  loadbalancer_id = azurerm_lb.db.id
  name            = "db-pool"
}

data "azurerm_network_interface" "db" {
  count               = var.dbcount
  name                = "db-nic-${count.index}"
  resource_group_name = var.resource_group
}

resource "azurerm_network_interface_backend_address_pool_association" "db" {
  count                   = var.dbcount
  network_interface_id    = data.azurerm_network_interface.db[count.index].id
  ip_configuration_name   = "dbip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.db.id
}

resource "azurerm_lb_rule" "db" {
  resource_group_name            = var.resource_group
  loadbalancer_id                = azurerm_lb.db.id
  name                           = "allow-from-app-tier-rule"
  protocol                       = "Tcp"
  frontend_port                  = 3306
  backend_port                   = 3306
  frontend_ip_configuration_name = "dbinternal"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.db.id
  probe_id                       = azurerm_lb_probe.db.id
}

resource "azurerm_lb_probe" "db" {
  resource_group_name = var.resource_group
  loadbalancer_id     = azurerm_lb.db.id
  name                = "app-tier-probe"
  port                = 3306
}
