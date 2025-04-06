// ------------------
// OUTPUTS
// ------------------

# output "acrId" {
#   value = azurerm_container_registry.acr.id
# }

# output "acrName" {
#   value = azurerm_container_registry.acr.name
# }

output "containerRegistryUserAssignedIdentityId" {
  value = azurerm_user_assigned_identity.containerRegistryUserAssignedIdentity.id
}

output "acr" {
  value = azurerm_container_registry.acr
}

# Extract registry name
output "acr_name" {
  value = azurerm_container_registry.acr.name
}

# Extract admin username
output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

# Extract admin password
output "acr_admin_password" {
  value = azurerm_container_registry.acr.admin_password
}