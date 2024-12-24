variable "resourceGroupName" {
  type = string
}

variable "location" {
  type = string
}

variable "storageAccountName" {
  type = string
}

variable "fileShareName" {
  type = string
  default = "settings"
}
