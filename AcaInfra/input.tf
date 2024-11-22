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
  
}