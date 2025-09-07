variable "rg_name" {}
variable "location" {}
variable "vm_name" {}
variable "network_interface_ids" {
     description = "List of NIC IDs to attach to VM"
  type        = list(string)
}
variable "vm_size" {}
variable "publisher" {}
variable "offer" {}
variable "sku" {}
variable "admin_username" {}
variable "admin_password" {}
variable "computer_name" {}

variable "public_ip_address" {
  type = string
  description = "The public IP address to connect"
}
variable "host" {}
