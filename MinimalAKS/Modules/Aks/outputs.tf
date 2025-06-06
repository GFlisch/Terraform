output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.k8s.name
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config
  sensitive = true
}

output "kube_config_raw" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config_raw
  sensitive = true
}

output "aksUserAssignedIdentityPrincipalId" {
  value = azurerm_user_assigned_identity.aksUserAssignedIdentity.principal_id
}

output "aksUserAssignedIdentityId" {
  value = azurerm_user_assigned_identity.aksUserAssignedIdentity.client_id
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.k8s.oidc_issuer_url
}