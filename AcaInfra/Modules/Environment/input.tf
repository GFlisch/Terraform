variable "resource_group_name" {
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
    name                  = string
    workload_profile_type = string
    minimum_count         = optional(number)
    maximum_count         = optional(number)
  }))
  default = [
    {
      maximum_count         = 0 
      minimum_count         = 0
      name                  = "Consumption"
      workload_profile_type = "Consumption"
    }
  ]
}

variable "environment_name" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}