resource "azurerm_container_registry" "acr" {
  name                = var.acrName
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku = "Premium"

  admin_enabled                 = false
  public_network_access_enabled = true
  network_rule_bypass_option    = "AzureServices"
}

resource "azurerm_user_assigned_identity" "containerRegistryUserAssignedIdentity" {
  name                = var.containerRegistryUserAssignedIdentityName
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "containerRegistryPullRoleAssignment" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.containerRegistryUserAssignedIdentity.principal_id
}