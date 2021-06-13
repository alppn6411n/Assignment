output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

output "websubnet_id" {
  value = azurerm_subnet.web.id
}

output "appsubnet_id" {
  value = azurerm_subnet.app.id
}

output "dbsubnet_id" {
  value = azurerm_subnet.db.id
}

output "mgmtsubnet_id" {
  value = azurerm_subnet.mgmt.id
}