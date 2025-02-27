resource "azurerm_key_vault_secret" "secrets" {
  for_each    = local.cert_files
  name        = replace(each.key, "/[^a-zA-Z0-9-]/", "")
  value       = base64encode(file("${var.cert_folder}/${each.key}"))
  key_vault_id = var.keyVaultId
}

provider "kubectl" {
  host                   = var.kube_config[0].host
  client_certificate     = base64decode(var.kube_config[0].client_certificate)
  client_key             = base64decode(var.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(var.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = var.kube_config[0].host
    client_certificate     = base64decode(var.kube_config[0].client_certificate)
    client_key             = base64decode(var.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(var.kube_config[0].cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = var.kube_config[0].host
  client_certificate     = base64decode(var.kube_config[0].client_certificate)
  client_key             = base64decode(var.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(var.kube_config[0].cluster_ca_certificate)
}

resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }
}

resource "helm_release" "nginx" {
  name       = "ingress-nginx"
  wait       = true
  timeout    = 600
  namespace  = kubernetes_namespace.nginx.metadata[0].name
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = "4.12.0"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.loadBalancerIP"
    value = var.public_ip_addrress
  }
}
