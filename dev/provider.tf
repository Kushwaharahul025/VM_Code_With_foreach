terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.36.0"
    }
  }
  backend "azurerm" {
    resource_group_name ="rahulrg"
    storage_account_name = "rahulstg"
    container_name = "hello1"
    key = "new.terraform.tfstate"
    
  }
}

provider "azurerm" {
  features {}
  subscription_id = "dfad8f6a-4ed1-4448-b795-d396ad2c60db"

}

