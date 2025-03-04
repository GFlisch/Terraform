data "azurerm_resource_group" "rg" {
  name     = local.rgHubName
}

data "azurerm_kubernetes_cluster" "k8s" {
  name                = local.aksName
  resource_group_name = data.azurerm_resource_group.rg.name
}

# provider "kubernetes" {
#   host                   = data.azurerm_kubernetes_cluster.k8s.kube_config[0].host
#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate)
# }

# kubectl create secret generic certificate --from-file=.
resource "null_resource" "register_secret" {
  provisioner "local-exec" {
    command = <<EOT
      kubectl create secret generic ${var.certificateName} --from-file=${local.certFolder} --namespace=${var.namespace}
          EOT
  }
}