variable "rootName"{
  type = string
  default = "Aks-Arc4u"
}

locals {
  rgHubName = "${var.rootName}-Hub-RG"
  aksName = "${var.rootName}-aks"
  certFolder = "${path.module}/certs"  
}

variable certificateName {
  type = string
  default = "certificate"
}

variable "namespace" {
  type = string
  default = "nginx"
}
