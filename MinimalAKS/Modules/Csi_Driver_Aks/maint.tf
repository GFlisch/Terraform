provider "helm" {
  kubernetes {
    config_path = var.kube_config_file
  }
}

resource "azurerm_key_vault_access_policy" "aks" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.aks_principal_id

  secret_permissions = ["Get", "List"]
}

resource "local_file" "cert_issuer_yaml" {
  filename = "./output/SecretClassProvider.yaml" # Path to the output file
  content  = local.secret_class_provider         # Content to write to the file
}

data "azurerm_client_config" "current" {}
