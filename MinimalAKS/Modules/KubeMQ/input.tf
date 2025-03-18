variable "aks_name" {
  type = string
}

variable "kube_config_file" {
  type = string
}


variable "tags" {
  type    = map(string)
  default = {}
}

variable "kubemq_init" {
  type    = string
  default = "https://deploy.kubemq.io/init"
}

variable "namespace" {
  type    = string
  default = "kubemq"
}
variable "kubemq_build" {
  type = string
}