resource "null_resource" "apply_kubectl_cert" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local.cert_yaml_url} --kubeconfig=${var.kube_config_file}"
  }
}

resource "null_resource" "apply_cert_issuer" {
  provisioner "local-exec" {
    command = <<EOT
      echo '${local.issuer_yaml_content}' > issuer.yaml
      kubectl apply -f issuer.yaml
      rm issuer.yaml
    EOT
  }
}