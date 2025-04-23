variable "rootName"{
  type = string
}

variable "salt" {
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
}
variable "kubemq_build" {
  type = string
}

locals {
  cleanRootName        = replace(var.rootName, "/[^a-zA-Z0-9-]/", "-")
  rgHubName            = "${local.cleanRootName}-RG-${var.salt}"
  aksName              = lower("${local.cleanRootName}-aks-${var.salt}")
}
