resource "azurerm_subnet" "rohitsub1" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefixes
}

output "subnet_id" {
  value = azurerm_subnet.rohitsub1.id
}