# Target Module (another_module/variables.tf)
variable "resource_group" {
  type = object({
    name     = string
    location = string
    id       = string
  })
}
variable "rootName"{
    type = string
}

locals {
  vnet_name = "${var.rootName}Vnet"
}

variable "vnet_mask" {
    type = string
}

variable "gtw_subnet_mask"{
    type = string
}

variable "aks_subnet_mask" {
  type = string
}

variable "other_subnet_mask" {
  type = string
}
