// ------------------
// OUTPUTS
// ------------------

output "keyVaultId" {
  value = azurerm_key_vault.keyvault.id
}

output "keyVaultName" {
  value = azurerm_key_vault.keyvault.name
}

# output "keyVaultUserIdentityId" {
#   value = azurerm_user_assigned_identity.keyVaultUserAssignedIdentity.id
# }