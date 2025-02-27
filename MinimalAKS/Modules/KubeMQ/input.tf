variable "aks_name" {
  type = string
}

variable "kube_config" {
  type = any
  sensitive = true
}

variable "kube_config_raw" {
  type = string
  sensitive = true
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

variable "kubemq_init" {
  type = string
  default = "https://deploy.kubemq.io/init"
}

variable "namespace" {
  type = string
  default = "kubemq"
}
variable "kubemq_build" {
  type = string
}