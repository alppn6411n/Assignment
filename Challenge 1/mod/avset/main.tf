resource "azurerm_network_interface" "web-nic" {
  count               = var.webcount
  name                = "web-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group
  ip_configuration {
    name                          = "webip"
    subnet_id                     = var.web_subnet_id
    private_ip_address_allocation = "dynamic"
  }
  tags = {
    env  = "${terraform.workspace}"
    tier = "web"
  }
}

resource "azurerm_network_interface" "app-nic" {
  count               = var.appcount
  name                = "app-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group
  ip_configuration {
    name                          = "appip"
    subnet_id                     = var.app_subnet_id
    private_ip_address_allocation = "dynamic"
  }
  tags = {
    env  = "${terraform.workspace}"
    tier = "app"
  }
}

resource "azurerm_network_interface" "db-nic" {
  count               = var.dbcount
  name                = "db-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group
  ip_configuration {
    name                          = "dbip"
    subnet_id                     = var.db_subnet_id
    private_ip_address_allocation = "dynamic"
  }
  tags = {
    env  = "${terraform.workspace}"
    tier = "db"
  }
}

resource "azurerm_network_interface" "mgmt-nic" {
  name                = "bastion-nic"
  location            = var.location
  resource_group_name = var.resource_group
  ip_configuration {
    name                          = "mgmtpubip"
    private_ip_address_allocation = "dynamic"
    subnet_id                     = var.mgmt_subnet_id
    public_ip_address_id          = azurerm_public_ip.mgmt.id
  }
  tags = {
    env  = "${terraform.workspace}"
    tier = "mgmt"
  }
}

resource "azurerm_public_ip" "mgmt" {
  name                = "mgmt-pubip"
  location            = "eastus"
  resource_group_name = var.resource_group
  allocation_method   = "Dynamic"
  tags = {
    env  = "${terraform.workspace}"
    tier = "mgmt"
  }
}

resource "azurerm_availability_set" "web" {
  name                = "web-avset"
  location            = var.location
  resource_group_name = var.resource_group
  tags = {
    env  = "${terraform.workspace}"
    tier = "web"
  }
}

resource "azurerm_availability_set" "app" {
  name                = "app-avset"
  location            = var.location
  resource_group_name = var.resource_group
  tags = {
    env  = "${terraform.workspace}"
    tier = "app"
  }
}

resource "azurerm_availability_set" "db" {
  name                = "db-avset"
  location            = var.location
  resource_group_name = var.resource_group
  tags = {
    env  = "${terraform.workspace}"
    tier = "db"
  }
}

resource "azurerm_virtual_machine" "web" {
  count                 = var.webcount
  name                  = "web-${count.index}"
  location              = var.location
  availability_set_id   = azurerm_availability_set.web.id
  resource_group_name   = var.resource_group
  network_interface_ids = [element(azurerm_network_interface.web-nic.*.id, count.index)]
  vm_size               = "Standard_B1S"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "webdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "web-${count.index}"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    env  = "${terraform.workspace}"
    tier = "web"
  }
}

resource "azurerm_virtual_machine" "app" {
  count                 = var.appcount
  name                  = "app-${count.index}"
  location              = var.location
  availability_set_id   = azurerm_availability_set.app.id
  resource_group_name   = var.resource_group
  network_interface_ids = [element(azurerm_network_interface.app-nic.*.id, count.index)]
  vm_size               = "Standard_B1S"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "appdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "app-${count.index}"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    env  = "${terraform.workspace}"
    tier = "app"
  }
}

resource "azurerm_virtual_machine" "db" {
  count                 = var.dbcount
  name                  = "db-${count.index}"
  location              = var.location
  availability_set_id   = azurerm_availability_set.db.id
  resource_group_name   = var.resource_group
  network_interface_ids = [element(azurerm_network_interface.db-nic.*.id, count.index)]
  vm_size               = "Standard_B1S"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "dbdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "web-${count.index}"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    env  = "${terraform.workspace}"
    tier = "db"
  }
}


resource "azurerm_virtual_machine" "mgmt" {
  name                  = "bastion"
  location              = var.location
  resource_group_name   = var.resource_group
  network_interface_ids = [azurerm_network_interface.mgmt-nic.id]
  vm_size               = "Standard_B1S"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "mgmtdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "bastion"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    env  = "${terraform.workspace}"
    tier = "mgmt"
  }
}