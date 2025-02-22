
data "azurerm_kubernetes_cluster" "k8s" {
    name                = var.aks_name
    resource_group_name = var.resource_group.name
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
