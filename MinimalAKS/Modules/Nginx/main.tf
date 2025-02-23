
data "azurerm_kubernetes_cluster" "k8s" {
    name                = var.aks_name
    resource_group_name = var.resource_group.name
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each    = local.cert_files
  name        = replace(each.key, "/[^a-zA-Z0-9-]/", "")
  value       = base64encode(file("${var.cert_folder}/${each.key}"))
  key_vault_id = var.keyVaultId
}

provider "kubectl" {
  host                   = data.azurerm_kubernetes_cluster.k8s.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.k8s.kube_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.k8s.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate)
}

resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }
}

resource "helm_release" "nginx" {
  name       = "nginx"
  namespace  = kubernetes_namespace.nginx.metadata[0].name
  chart      = "bitnami/nginx"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "13.2.16"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}
