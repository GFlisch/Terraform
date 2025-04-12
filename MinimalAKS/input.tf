variable "rootName" {
  type    = string
  default = "Aks-Guidance"
}

variable "base_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "issuer_email" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "salt" {
  type    = string
  default = ""
}

locals {
  cleanRootName        = replace(var.rootName, "/[^a-zA-Z0-9-]/", "-")
  salt                 = var.salt != "" ? var.salt : random_string.salt.result
  rgHubName            = "${local.cleanRootName}-RG-${local.salt}"
  vnetName             = "${local.cleanRootName}-Vnet-${local.salt}"
  acrName              = lower("${replace(var.rootName, "/[^a-zA-Z0-9-]/", "")}acr${local.salt}")
  storageName          = lower("${local.cleanRootName}-storage-${local.salt}")
  keyVaultName         = lower("${local.cleanRootName}-kv-${local.salt}")
  aksName              = lower("${local.cleanRootName}-aks-${local.salt}")
  keyVaultIdentityName = lower("${local.cleanRootName}-kv-user-identity-${local.salt}")
  aksAcrIdentityName   = lower("${local.cleanRootName}-acr-pull-identity-${local.salt}")
  aksIdentityName      = lower("${local.cleanRootName}-aks-identity-${local.salt}")
  certFolder           = "${path.module}/Modules/Nginx/certs"
}

