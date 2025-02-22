variable "aks_name" {
  type = string
}

variable "kubernetes_secret_name" {
  type = string
  default = "certificates"
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

# variable "tags" {
#   type = map(string)
#   default = {}
# }

# variable "client_certificate" {
#   type      = string
#   sensitive = true
# }

# variable "client_key" {
#   type      = string
#   sensitive = true
# }

# variable "cluster_ca_certificate" {
#   type      = string
#   sensitive = true
# }


