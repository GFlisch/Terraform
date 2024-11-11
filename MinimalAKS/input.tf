variable "rootName"{
  type = string
  default = "Aks-Arc4u"
}

locals {
  rgHubName = "${var.rootName}-Hub-RG"
}

