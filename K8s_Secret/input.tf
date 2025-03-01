variable "rootName"{
  type = string
  default = "Aks-Arc4u"
}

locals {
  rgHubName = "${var.rootName}-Hub-RG"
  acrName = "${replace(var.rootName, "-", "")}acr"
  aksName = "${var.rootName}-aks"
  keyVaultIdentityName = "${var.rootName}-kv-user-identity"
  aksAcrIdentityName = "${var.rootName}-acr-pull-identity" 
}

