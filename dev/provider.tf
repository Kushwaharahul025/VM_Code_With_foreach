terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.36.0"
    }
  }
  backend "azurerm" {
    resource_group_name ="testrg"
    storage_account_name = "testsg"
    container_name = "hello"
    key = "new.terraform.tfstate"
    
  }
}

provider "azurerm" {
  features {}
  subscription_id = "76095b6e-0585-402e-8e43-281835aebfd1"

}

