resource "null_resource" "apply_kubectl_cert" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local.cert_yaml_url} --kubeconfig=${var.kube_config_file}"
  }
}
