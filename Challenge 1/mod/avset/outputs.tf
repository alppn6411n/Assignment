output "bastion_public_ip" {
  value = azurerm_public_ip.mgmt.ip_address
}