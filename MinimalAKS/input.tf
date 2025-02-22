variable "rootName"{
  type = string
  default = "Aks-Arc4u"
}

locals {
  rgHubName = "${var.rootName}-Hub-RG"
  acrName = "${replace(var.rootName, "-", "")}acr"
  keyVaultName = "${var.rootName}-kv"
  aksName = "${var.rootName}-aks"
  keyVaultIdentityName = "${var.rootName}-kv-user-identity"
  aksAcrIdentityName = "${var.rootName}-acr-pull-identity" 
  certFolder = "${path.module}/Modules/Nginx/certs"   
}

