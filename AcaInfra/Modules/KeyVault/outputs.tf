// ------------------
// OUTPUTS
// ------------------

output "keyVaultId" {
  value = azurerm_key_vault.keyvault.id
}

output "keyVaultName" {
  value = azurerm_key_vault.keyvault.name
}

output "keyVaultCertificatesUserIdentity" {
  value = azurerm_user_assigned_identity.keyVaultUserAssignedIdentity.id
}