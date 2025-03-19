variable "rootName"{
  type = string
}

variable "namespace" {
  type = string
  description = "The namespace to deploy the secret" 
}

locals {
  rgHubName = "${var.rootName}-Hub-RG"
  acrName = "${replace(var.rootName, "-", "")}acr"
  aksName = "${var.rootName}-aks"
  keyVaultIdentityName = "${var.rootName}-kv-user-identity"
  aksAcrIdentityName = "${var.rootName}-acr-pull-identity" 
}

