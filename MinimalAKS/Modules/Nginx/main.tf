
data "azurerm_kubernetes_cluster" "k8s" {
    name                = var.aks_name
    resource_group_name = var.resource_group.name
}


resource "azurerm_key_vault_certificate" "certificates" {
  for_each    = local.cert_files
  name        = replace(each.key, "/[^a-zA-Z0-9-]/", "")
  key_vault_id = var.keyVaultId

  certificate {
    contents = file("${var.cert_folder}/${each.key}")
  }
}

# resource "null_resource" "kubectl_create_tls_secret" {
#     provisioner "local-exec" {
#         command = <<EOT
#         kubectl create secret generic ${var.kubernetes_secret_name} \
#             --from-file=${var.cert_folder} \
#             --kubeconfig=${data.azurerm_kubernetes_cluster.k8s.kube_config_raw}
#         EOT
#     }
# }
