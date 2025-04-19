variable "rootName"{
  type = string
}

variable "salt" {
  type = string
  description = "You have to provide a salt value to generate a unique name for the resource group"
}

variable "namespace" {
  type = string
  description = "The namespace to deploy the secret" 
}

locals {
  cleanRootName        = replace(var.rootName, "/[^a-zA-Z0-9-]/", "-")
  rgHubName            = "${local.cleanRootName}-RG-${var.salt}"
  vnetName             = "${local.cleanRootName}-Vnet-${var.salt}"
  acrName              = lower("${replace(var.rootName, "/[^a-zA-Z0-9-]/", "")}acr${var.salt}")
  aksName              = lower("${local.cleanRootName}-aks-${var.salt}")   
  keyVaultIdentityName = lower("${local.cleanRootName}-kv-user-identity-${var.salt}")
  aksAcrIdentityName   = lower("${local.cleanRootName}-acr-pull-identity-${var.salt}") 
}

