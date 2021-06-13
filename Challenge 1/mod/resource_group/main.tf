resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-${terraform.workspace}"
  location = var.location
  tags = {
    env = "${terraform.workspace}"
  }
}
