variable "rootName"{
  type = string
  default = "Aca-Arc4u"
}

locals {
  rgSpokeName = "${var.rootName}-Spoke-RG"
  acrName = "${replace(var.rootName, "-", "")}acr"
  acaAcrIdentityName = "${var.rootName}-acr-pull-identity"
  acaEnvironmentName = "${var.rootName}-environment"
  logAnalyticsWorkspaceName = "${var.rootName}-law"
  keyVaultName = "${var.rootName}-kv"
  keyVaultIdentityName = "${var.rootName}-kv-user-identity"
  storageAccountName = "${lower(replace(var.rootName, "-", ""))}storage"
  infrastructure_resource_group_name = "${var.rootName}-env-infra-rg"
}