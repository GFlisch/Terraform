
resource "azurerm_key_vault" "keyvault" {
  name                            = var.keyVaultName
  resource_group_name             = var.resource_group.name
  location                        = var.resource_group.location
  sku_name                        = "standard"
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false
  public_network_access_enabled   = true
  enable_rbac_authorization       = true
  enabled_for_template_deployment = true
  tags                            = var.tags
}

# resource "azurerm_user_assigned_identity" "keyVaultUserAssignedIdentity" {
#   name                = var.keyVaultUserAssignedIdentityName
#   resource_group_name = var.resource_group.name
#   location            = var.resource_group.location
#   tags                = var.tags
# }

# resource "azurerm_role_assignment" "keyVaultCertificatesUserRoleAssignment" {
#   scope                = azurerm_key_vault.keyvault.id
#   role_definition_name = "Key Vault Certificate User"
#   principal_id         = azurerm_user_assigned_identity.keyVaultUserAssignedIdentity.principal_id
# }

resource "azurerm_role_assignment" "keyVaultSecretsUserRoleAssignment" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets User" # Read-only access to secrets
  principal_id         = var.aksIdentityPrincipalId
}

# enable user to read/write secrets 
# TODO remove for production
resource "azurerm_role_assignment" "keyVaultSecretsOfficerRoleAssignment" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# TODO remove for production
data "azurerm_client_config" "current" {}
