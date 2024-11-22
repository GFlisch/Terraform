# Target Module (another_module/variables.tf)

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "rootName"{
    type = string
}

variable "vnet_mask" {
    type = string
}

variable "gtw_subnet_mask"{
    type = string
}

  

variable "aca_subnet_mask" {
  type = string
}

variable "other_subnet_mask" {
  type = string
}

locals {
  vnet_name = "${var.rootName}Vnet"
  first_private_gtw_ip = cidrhost(var.gtw_subnet_mask, 5)
}
