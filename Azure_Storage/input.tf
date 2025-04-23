variable "rootName"{
  type = string
}

variable "salt" {
  type = string
}

variable "azure_secret_name" {
  type = string
  default = "azure-storage"
}

locals {
  cleanRootName        = replace(var.rootName, "/[^a-zA-Z0-9-]/", "-")
  rgHubName            = "${local.cleanRootName}-RG-${var.salt}"
  storageName          = lower(replace("${local.cleanRootName}st${var.salt}", "-", ""))
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "file_shares" {
  type = map(number)  # Map of share_name = quota_in_gb
  default = {
  }
}

variable "retention_days" {
  type = number
  default = 100
}

variable "namespace" {
  type = string
}