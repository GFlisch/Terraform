provider "helm" {
  kubernetes {
    config_path = var.kube_config_file
  }
}

resource "helm_release" "secrets_store_csi_driver" {
  name       = "csi-secrets-store"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"

  # Optional: Specify the version of the chart if needed
  # version = "x.x.x"

  # Optional: Add values if you need to customize the installation
  values = []

  # Force Helm to take ownership of existing resources
  force_update = true
  recreate_pods = true

  # Cleanup on failure to avoid resource conflicts
  cleanup_on_fail = true
}
