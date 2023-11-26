variable "base_name" {
  type = string
  description = "value to be used as a base for all resources"
}

variable "rg_name" {
  type = string
  description = "value to be used as a name for the resource group"
}

variable "location" {
  type = string
  description = "value to be used as a location for all resources"
}

variable "sa_name" {
  type = string
  description = "value to be used as a name for the storage account"
}

variable "sc_name" {
  type = string
  description = "value to be used as a name for the storage container"
}

variable "kv_name" {
  type = string
  description = "value to be used as a name for the key vault"  
}

variable "sa_access_key_name" {
  type = string
  description = "value to be used as a name for the storage account access key"
}
