provider "kubernetes" {
  config_path = var.kube_config_file
}

resource "kubernetes_namespace" "kubemq" {
  metadata {
    name = var.namespace
  }
}

resource "null_resource" "apply_kubectl_init" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${var.kubemq_init} --kubeconfig=${var.kube_config_file}"
  }

  depends_on = [kubernetes_namespace.kubemq]
}

resource "null_resource" "apply_kubectl_build" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${var.kubemq_build} --kubeconfig=${var.kube_config_file}"
  }

  depends_on = [kubernetes_namespace.kubemq]
}