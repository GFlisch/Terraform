variable "tags" {
  type    = map(string)
  default = {}
}

variable "rootName" {
  type = string
}

locals {
  rgHubName    = "${var.rootName}-Hub-RG"
  keyVaultName = "${var.rootName}-kv"
  certFolder   = "${path.module}/certs"
}