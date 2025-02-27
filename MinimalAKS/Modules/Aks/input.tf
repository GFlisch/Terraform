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
  type = map(string)
  default = {}
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 3
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}

locals {
  dns_prefix = "dns"
  ssh_key_name = "${var.aks_name}-ssh"
  aksIdentityName = "${var.aks_name}-aks-identity"    
}

variable "additional_node_pool_name" {
  description = "The name of the additional node pool."
  type        = string
  default     = "additionalpool"
}

variable "additional_node_pool_vm_size" {
  description = "The VM size for the additional node pool."
  type        = string
  default     = "Standard_D2_v2"
}

variable "additional_node_pool_node_count" {
  description = "The number of nodes in the additional node pool."
  type        = number
  default     = 1
}

variable "vnet_name" {
  description = "The virtual network object from the Hub module"
  type        = string
}

variable "cidr_vnet" {
  description = "The virtual network used internally for the pods"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dns_service_ip" {
  description = "The IP address of the DNS service"
  type        = string
  default     = "10.1.0.10"
}

variable "aks_subnet" {
  type = object({
    name     = string
    id       = string
  })
}

variable "app_max_node_pool"{
  type = number
  default = 10
}

