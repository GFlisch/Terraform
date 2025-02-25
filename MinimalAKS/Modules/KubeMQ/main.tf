
data "azurerm_kubernetes_cluster" "k8s" {
    name                = var.aks_name
    resource_group_name = var.resource_group.name
}

provider "kubectl" {
  host                   = data.azurerm_kubernetes_cluster.k8s.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate)
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.k8s.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate)
}

resource "local_file" "kubeconfig" {
  content  = data.azurerm_kubernetes_cluster.k8s.kube_config_raw
  filename = "${path.module}/temp/kubeconfig.yaml"
}

resource "kubernetes_namespace" "kubemq" {
  metadata {
    name = var.namespace
  }
}

resource "null_resource" "apply_kubectl_init" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${var.kubemq_init} --kubeconfig=${local_file.kubeconfig.filename}"
  }

  depends_on = [kubernetes_namespace.kubemq]
}

resource "null_resource" "apply_kubectl_build" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${var.kubemq_build} --kubeconfig=${local_file.kubeconfig.filename}"
  }

  depends_on = [kubernetes_namespace.kubemq]
}