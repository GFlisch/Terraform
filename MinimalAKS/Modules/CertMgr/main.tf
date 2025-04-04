resource "null_resource" "apply_kubectl_cert" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local.cert_yaml_url} --kubeconfig=${var.kube_config_file}"
  }
}

resource "local_file" "cert_issuer_yaml" {
  filename = "./output/cert_issuer.yaml" # Path to the output file
  content  = local.issuer_yaml_content               # Content to write to the file
}