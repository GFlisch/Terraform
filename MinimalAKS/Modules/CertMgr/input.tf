
variable "kube_config_file" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}


variable "cert_version" {
  type    = string
  default = "1.17.0"
}

variable "email" {
  type = string
}

locals {
  cert_yaml_url = "https://github.com/cert-manager/cert-manager/releases/download/${var.cert_version}/cert-manager.yaml"
  issuer_yaml_content = templatefile("${path.module}/cert_issuer.yaml", {
    issuer_name = "letsencrypt",
    email       = var.email
  })
}