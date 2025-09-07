resource "azurerm_linux_virtual_machine" "vm1" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.rg_name
  size                = var.vm_size

  network_interface_ids = var.network_interface_ids

  admin_username = var.admin_username
  admin_password = var.admin_password
  computer_name  = var.computer_name
disable_password_authentication = false
  

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type     = "ssh"
      host     = var.host
      user     = var.admin_username
      password = var.admin_password
      
    }
  }
}
