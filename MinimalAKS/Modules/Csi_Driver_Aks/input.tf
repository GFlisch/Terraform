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

variable "workload_client_id" {
  type = string
}

variable "sa_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "root_name" {
  type = string
}

variable "aks_name" {
  type = string
}

locals {
  secret_class_provider = templatefile("${path.module}/Template/SecretProviderClass.yaml", {
    workload_identity = var.workload_client_id,
    key_vault_name    = var.key_vault_name,
    tenant_id         = data.azurerm_client_config.current.tenant_id
  })
  service_account = templatefile("${path.module}/Template/ServiceAccount.yaml", {
    workload_identity = var.workload_client_id,
    tenant_id         = data.azurerm_client_config.current.tenant_id,
    sa_name           = var.sa_name,
  })
  federated_identity = templatefile("${path.module}/Template/RegisterFederatedIdentity.ps1", {
    resource_group = var.resource_group_name,
    aks_name       = var.aks_name,
    root_name      = var.root_name,
  })
}