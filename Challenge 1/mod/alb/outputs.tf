output "lb_public_ip" {
  value = azurerm_public_ip.web.ip_address
}