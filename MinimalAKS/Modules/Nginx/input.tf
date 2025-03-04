variable "aks_name" {
  type = string
}


variable "kubernetes_secret_name" {
  type = string
  default = "certificates"
}

variable "kube_config" {
  type = any
  sensitive = true
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
    id       = string
  })
}

variable "cert_folder" {
  type = string
}

variable "keyVaultId" {
  type = string
}

locals {
  cert_files = fileset(var.cert_folder, "*.*")
}

variable "tags" {
  type = map(string)
  default = {}
}
