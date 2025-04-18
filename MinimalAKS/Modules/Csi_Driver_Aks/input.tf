variable "kube_config_file" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}

variable "key_vault_id" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "aks_principal_id" {
  type = string
}

variable "aks_client_id" {
  type = string
}

variable "sa_name" {
  type = string
}

locals {
  secret_class_provider = templatefile("${path.module}/Template/SecretClassProvider.yaml", {
    aks_identity   = var.aks_client_id,
    key_vault_name = var.key_vault_name,
    tenant_id      = data.azurerm_client_config.current.tenant_id
  })
  service_account = templatefile("${path.module}/Template/ServiceAccount.yaml", {
    aks_identity   = var.aks_client_id,
    sa_name        = var.sa_name,
  })  
}