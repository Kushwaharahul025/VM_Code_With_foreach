module "rg_resource" {
  for_each = var.rg1
  source   = "../Module/azure_resource_grp"
  rg_name  = each.value.rg_name 
  location = each.value.location
}

module"vnet" {
  for_each = var.vnet
  depends_on = [ module.rg_resource ]
  source = "../Module/azure_vnet"
  rg_name  = each.value.rg_name 
  location = each.value.location
  vnet_name = each.value.vnet_name
  address_space = each.value.address_space

}
module "frontendsub" {
  for_each = var.sub1
  depends_on = [ module.rg_resource,module.vnet ]
  source = "../Module/azure_subnet"
  subnet_name = each.value.subnet_name
  rg_name  = each.value.rg_name 
  vnet_name = each.value.vnet_name
  address_prefixes = each.value.address_prefixes


}

output "subnet_ids" {
  value = { for k, v in module.frontendsub : k => v.subnet_id }
}




module "rohitnsg" {
  for_each = var.nsg1
  depends_on = [module.rg_resource ]
  source = "../Module/azurerm_nsg"
  rg_name  = each.value.rg_name 
  location = each.value.location
  nsg_name = each.value.nsg_name
}

# output "nsg_id" {
#   value = module.rohitnsg["rohitnsg"].nsg_id
# }

module "frontnic" {
  for_each = var.nic
  depends_on = [ module.rg_resource,module.frontendsub,module.vnet ]
  source = "../Module/azurerm_nic"
    rg_name  = each.value.rg_name 
  location = each.value.location
  nic_name = each.value.nic_name
subnet_name = each.value.subnet_name
subnet_id = module.frontendsub[each.value.subnet_name].subnet_id
private_ip_address_allocation = each.value.private_ip_address_allocation
 public_ip_address_id = local.nic_pip_map[each.key]
 vnet_name = each.value.vnet_name
}


output "nic_ids" {
  description = "The IDs of the NICs"
  value       = { for k, v in module.frontnic : k => v.nic_id }
}

module "pip" {
  for_each = var.pip
  depends_on = [ module.rg_resource ]
  source = "../Module/azurerm_pip"
  rg_name  = each.value.rg_name
  location = each.value.location
  pip_name = each.value.pip_name
  allocation_method = each.value.allocation_method
  
}

output "pip_ip" {
  value = { for k, v in module.pip : k => v.pip_ip }
}

locals {
  vm_nic_map = {
    frontvm = "frontnic1"
    backvm  = "backnic1"
  }
  nic_pip_map = {
    frontnic1 = module.pip["frontpip"].pip_id
    backnic1  = module.pip["backpip"].pip_id
  }

  # 👇 NIC -> Public IP mapping (actual IP ke liye, remote-exec ya output ke liye)
  nic_ip_map = {
    frontnic1 = module.pip["frontpip"].pip_ip
    backnic1  = module.pip["backpip"].pip_ip
  }
}


module "asso" {
  for_each   = module.frontnic
  depends_on = [module.frontnic, module.rohitnsg]
  source     = "../Module/azurerm_association"

  nic_id = each.value.nic_id
  nsg_id = module.rohitnsg["rohitnsg"].nsg_id
}


module "frontvm" {
  for_each = var.vm1
  depends_on = [ module.rg_resource,module.vnet,module.frontnic,module.pip ]
  source = "../Module/azurerm_virtual_machine"
  rg_name  = each.value.rg_name
  location = each.value.location
   vm_name = each.value.vm_name
   network_interface_ids = [module.frontnic[each.value.nic_key].nic_id]
   vm_size               = each.value.vm_size
  publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    admin_username = each.value.admin_username
    admin_password = each.value.admin_password
   computer_name  = each.value.computer_name
   public_ip_address = local.nic_ip_map[local.vm_nic_map[each.key]]
   host = local.nic_ip_map[local.vm_nic_map[each.key]]
    

}



