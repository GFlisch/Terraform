data "azurerm_resource_group" "rg" {
  name     = local.rgHubName
}

data "azurerm_kubernetes_cluster" "k8s" {
  name                = local.aksName
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "local_file" "kubeconfig" {
  content  = data.azurerm_kubernetes_cluster.k8s.kube_config_raw
  filename = "${path.module}/temp/kubeconfig.yaml"
}

provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}

resource "kubernetes_namespace" "kubemq" {
  metadata {
    name = var.namespace
  }
}

resource "null_resource" "apply_kubectl_init" {
  provisioner "local-exec" {
        command = <<EOT
      kubectl apply -f ${var.kubemq_init} --kubeconfig=${local_file.kubeconfig.filename}
          EOT
  }

  depends_on = [kubernetes_namespace.kubemq]
}

resource "null_resource" "apply_kubectl_build" {
  provisioner "local-exec" {
        command = <<EOT
      kubectl apply -f ${var.kubemq_build} --kubeconfig=${local_file.kubeconfig.filename}
          EOT    
  }

  depends_on = [kubernetes_namespace.kubemq]
}