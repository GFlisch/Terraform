variable "rootName"{
  type = string
  default = "Aks-Arc4u"
}

locals {
  rgHubName = "${var.rootName}-Hub-RG"
}

variable "redis_cache_name" {
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
