variable "rootName"{
  type = string
}

variable "azure_secret_name" {
  type = string
  default = "azure-storage"
}

locals {
  rgHubName = "${var.rootName}-RG"
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "file_shares" {
  type = map(number)  # Map of share_name = quota_in_gb
  default = {
    "production"  = 50
    "staging"     = 50
  }
}

variable "retention_days" {
  type = number
  default = 100
}

variable "namespace" {
  type = string
}