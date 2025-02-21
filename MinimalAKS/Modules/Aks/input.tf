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
