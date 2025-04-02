variable "tags" {
  type    = map(string)
  default = {}
}

variable "keyVaultId" {
  type = string
}
locals {
  certFolder = "${path.module}/certs"
}