variable "rootName"{
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "kubemq_init" {
  type    = string
  default = "https://deploy.kubemq.io/init"
}

variable "namespace" {
  type    = string
  default = "kubemq"
}
variable "kubemq_build" {
  type = string
}

locals {
  rgHubName = "${var.rootName}-RG"
  aksName = "${var.rootName}-aks"
}
