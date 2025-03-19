variable "rootName"{
  type = string
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
}
