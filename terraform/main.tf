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
        key                  = "rg.terraform.tfstate"  
    }
}

provider "azurerm" {
    features {}  
}

