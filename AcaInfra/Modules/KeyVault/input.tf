variable "keyVaultName" {
  description = "The name of the Key Vault"
  type        = string
  
}

variable "resourceGroupName" {
  description = "The name of the resource group"
  type        = string
  
}

variable "location" {
  description = "The location of the Key Vault"
  type        = string
  
}

variable "tags" {
  description = "The SKU of the Key Vault"
  type        = map(string)
  default = {}
  
}

variable "keyVaultUserAssignedIdentityName" {
  description = "The name of the user assigned identity"
  type        = string
}