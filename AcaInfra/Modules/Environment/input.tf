# variable "resource_group_name" {
#   type = string
# }

variable "resource_group_id" {
  type = string  
}

variable "location" {
  type = string
}

variable "aca-subnet-id"{
    type = string
}

variable "workloadProfiles" {
  description = "Optional, the workload profiles required by the end user. The default is 'Consumption', and is automatically added whether workload profiles are specified or not."
  type = list(object({
    name                 = string
    workloadProfileType  = string
    minimumCount         = optional(number)
    maximumCount         = optional(number)
  }))
  default = [
    {
      name                 = "Consumption"
      workloadProfileType  = "Consumption"
    }
  ]
}

variable "environment_name" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "infrastructure_resource_group_name" {
  type = string
}

variable "keyVault_certificates_user_identity_id" {
  type = string
}