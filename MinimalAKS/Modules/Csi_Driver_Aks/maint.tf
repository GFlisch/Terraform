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

# resource "helm_release" "secrets_store_csi_driver" {
#   name       = "csi-secrets-store"
#   namespace  = "kube-system"
#   repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
#   chart      = "secrets-store-csi-driver"

#   # Optional: Specify the version of the chart if needed
#   # version = "x.x.x"

#   # Optional: Add values if you need to customize the installation
#   values = []

#   # Force Helm to take ownership of existing resources
#   force_update = true
#   recreate_pods = true

#   # Cleanup on failure to avoid resource conflicts
#   cleanup_on_fail = true
# }

data "azurerm_client_config" "current" {}
