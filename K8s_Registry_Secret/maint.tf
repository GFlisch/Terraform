data "azurerm_resource_group" "rg" {
  name     = local.rgHubName
}

data "azurerm_container_registry" "acr" {
  name                = local.acrName
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_kubernetes_cluster" "k8s" {
  name                = local.aksName
  resource_group_name = data.azurerm_resource_group.rg.name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.k8s.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate)
}

resource "kubernetes_secret" "acr_auth" {
  metadata {
    name      = "acr-secret"
    namespace = var.namespace
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      "auths" = {
        "${data.azurerm_container_registry.acr.login_server}" = {
          "username" = data.azurerm_container_registry.acr.admin_username
          "password" = data.azurerm_container_registry.acr.admin_password
          "auth"     = base64encode("${data.azurerm_container_registry.acr.admin_username}:${data.azurerm_container_registry.acr.admin_password}")
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}
