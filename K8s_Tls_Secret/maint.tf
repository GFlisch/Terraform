data "azurerm_resource_group" "rg" {
  name     = local.rgHubName
}

data "azurerm_kubernetes_cluster" "k8s" {
  name                = local.aksName
  resource_group_name = data.azurerm_resource_group.rg.name
}

# kubectl create secret tls certificate --cert=./certs/arc4u.net/cert.pem --key=./Certs/arc4u.net/privkey.pem
# resource "null_resource" "delete_secret" {
#   provisioner "local-exec" {
#     command = <<EOT
#       kubectl get secret ${var.certificateName} --namespace=${var.namespace} && kubectl delete secret ${var.certificateName} --namespace=${var.namespace} || exit 0
#           EOT
#   }
# }

resource "null_resource" "register_secret" {
  provisioner "local-exec" {
    command = <<EOT
      kubectl create secret tls ${var.certificateName} --cert=${local.certFolder}/${var.cert} --key=${local.certFolder}/${var.key} --namespace=${var.namespace}
          EOT
  }
}