variable "aks_name" {
  type = string
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
    id       = string
  })
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "additional_node_pool_name" {
  description = "The name of the additional node pool."
  type        = string
  default     = "applicationpool"
}

variable "additional_node_pool_vm_size" {
  description = "The VM size for the additional node pool."
  type        = string
  default     = "Standard_D2as_v5"
}

variable "additional_windows_node_pool_name" {
  description = "The name of the additional node pool, maximum 6 characters."
  type        = string
  default     = "win"
}

variable "additional_windows_node_pool_vm_size" {
  description = "The VM size for the additional node pool."
  type        = string
  default     = "Standard_D2as_v5"
}

variable "additional_windows_node_pool_node_count" {
  description = "The number of nodes in the additional node pool."
  type        = number
  default     = 0
}


variable "additional_node_pool_node_count" {
  description = "The number of nodes in the additional node pool."
  type        = number
  default     = 2
}

variable "aks_subnet" {
  type = object({
    name = string
    id   = string
  })
}

variable "app_max_node_pool" {
  type    = number
  default = 10
}

variable "acr" {
  type = object({
    name           = string
    id             = string
    login_server   = string
    admin_username = string
    admin_password = string
  })
}

variable "aksIdentityName" {
  type = string
}

locals {
  managed_resource_group = format("MC_%s_%s_%s", var.resource_group.name, var.aks_name, var.resource_group.location)
}
