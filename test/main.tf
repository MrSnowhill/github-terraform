terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "3.74.0"
        }
    }
    backend "azurerm" {
        resource_group_name  = "rg-be-tfstate-hso"
        storage_account_name = "hsofu6ccntc2j"
        container_name       = "tfstate"
        key                  = "web.terraform.tfstate"  
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "rg-test-be-hso" {
    name     = var.rg_name
    location = var.location
}