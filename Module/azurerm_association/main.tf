resource "azurerm_network_interface_security_group_association" "nic_nsg_attach" {
  network_interface_id      = var.nic_id       # NIC ID from module.frontnic
  network_security_group_id = var.nsg_id 
  
        # NSG ID from module.rohitnsg
}