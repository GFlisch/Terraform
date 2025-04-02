resource "null_resource" "apply_kubectl_cert" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local.cert_yaml_url} --kubeconfig=${var.kube_config_file}"
  }
}

resource "null_resource" "apply_cert_issuer" {
  provisioner "local-exec" {
    command     = <<EOT
      if not exist temp mkdir temp
      echo '${local.issuer_yaml_content}' > temp\issuer.yaml
      kubectl apply -f temp\issuer.yaml
    EOT
    interpreter = ["cmd", "/c"]
  }
}