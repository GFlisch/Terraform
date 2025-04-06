variable "rootName"{
  type = string
}

variable "salt" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "capacity" {
  type = number 
  default = 0
}

variable "sku_name" {
  type = string
  default = "Basic"
}

 locals {
  cleanRootName        = replace(var.rootName, "/[^a-zA-Z0-9-]/", "-")
  rgHubName            = "${local.cleanRootName}-RG-${var.salt}"
  redisCacheName       = "${local.cleanRootName}-Redis-${var.salt}"
 }