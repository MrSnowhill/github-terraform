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
        key                  = "backend.terraform.tfstate"  
    }
}

provider "azurerm" {
    features {
        key_vault {
            purge_soft_delete_on_destroy   = true
            recover_soft_deleted_key_vaults = true
        }
    }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg-be-hso" {
    name     = format("rg-%s-%s", var.rg_name, var.base_name)
    location = var.location
}

resource "random_string" "random_string" {
    length  = 10
    special = false
    upper   = false
}

resource "azurerm_storage_account" "sa-be-hso" {
    name                     = "${lower(var.base_name)}${random_string.random_string.result}"
    resource_group_name      = azurerm_resource_group.rg-be-hso.name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc-be-hso" {
    name                  = var.sc_name
    storage_account_name  = azurerm_storage_account.sa-be-hso.name
    container_access_type = "private"
}

resource "azurerm_key_vault" "kv-be-hso" {
    name                        = "${lower(var.kv_name)}${random_string.random_string.result}"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.rg-be-hso.name
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    sku_name                    = "standard"
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false
    enabled_for_disk_encryption = true

    access_policy {
        tenant_id = data.azurerm_client_config.current.tenant_id
        object_id = data.azurerm_client_config.current.object_id

        key_permissions    = ["Get", "List", "Create"]
        secret_permissions = ["Get", "List", "Set"]
        storage_permissions = ["Get", "List", "Set"]
    }
}

resource "azurerm_key_vault_secret" "sa-backend-hso-git-key" {
    name         = var.sa_access_key_name
    value        = azurerm_storage_account.sa-be-hso.primary_access_key
    key_vault_id = azurerm_key_vault.kv-be-hso.id
}