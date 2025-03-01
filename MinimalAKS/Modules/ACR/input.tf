variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "containerRegistryUserAssignedIdentityName" {
  type = string
}

variable "containerRegistryPullRoleGuid" {
  default = "7f951dda-4ed3-4680-a7ca-43fe172d538d"
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "acrName" {
  type = string
}

variable "adminEnabled" {
  type = bool
  default = true  
}