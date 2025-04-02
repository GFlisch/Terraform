variable "rootName"{
  type = string
}

locals {
  rgHubName = "${var.rootName}-RG"
  aksName = "${var.rootName}-aks"
  certFolder = "${path.module}/certs"  
}

variable certificateName {
  type = string
  default = "certificates"
}

variable "namespace" {
  type = string
}

variable "cert" {
  type = string
}

variable "key" {
  type = string
}