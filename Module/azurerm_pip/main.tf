
resource "azurerm_public_ip" "pip1" {
  name                = var.pip_name
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method = var.allocation_method
  sku                 = "Standard"

 
}

output "pip_ip" {
  value = azurerm_public_ip.pip1.ip_address
}
output "pip_id" {
  value = azurerm_public_ip.pip1.id
}
