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

locals {
  rgHubName            = "${var.rootName}-Hub-RG"
  acrName              = "${replace(var.rootName, "-", "")}acr"
  keyVaultName         = "${var.rootName}-kv"
  aksName              = "${var.rootName}-aks"
  keyVaultIdentityName = "${var.rootName}-kv-user-identity"
  aksAcrIdentityName   = "${var.rootName}-acr-pull-identity"
  certFolder           = "${path.module}/Modules/Nginx/certs"
}

