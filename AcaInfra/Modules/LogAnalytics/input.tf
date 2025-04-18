variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "rootName"{
    type = string
}

variable "workspaceName" {
  type    = string
  validation {
    condition     = length(var.workspaceName) >= 4 && length(var.workspaceName) <= 63
    error_message = "Name must be greater than 4 characters and not longer than 63 characters."
  }
}

variable "retentionInDays" {
  default = 90
  type    = number
  validation {
    condition     = var.retentionInDays <= 730
    error_message = "Value can't be more than 730 days."
  }
}

variable "sku" {
  default = "PerGB2018"
  type    = string
  validation {
    condition = anytrue([
      var.sku == "Free",
      var.sku == "Standalone",
      var.sku == "PerNode",
      var.sku == "PerGB2018"
    ])
    error_message = "SKU must be Free, Standalone, PerNode, or PerGB2018."
  }
}

variable "ingestionEnabled" {
  default = true
  type    = bool
}

variable "internetQueryEnabled" {
  default = true
  type    = bool

}

variable "allowResourceOnlyPermissions" {
  default = true
  type    = bool
}
