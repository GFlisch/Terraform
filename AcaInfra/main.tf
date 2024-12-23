# rg ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  suffix  = ["hub"]
}

# rg is required for resource modules
resource "azurerm_resource_group" "rg" {
  location = "westeurope" ##module.regions.regions[random_integer.region_index.result].name
  name     = local.rgSpokeName
}

module "network" {
  source = "./Modules/Network"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  rootName = var.rootName
  vnet_mask = "10.0.0.0/16"
  gtw_subnet_mask = "10.0.0.0/24"
  aca_subnet_mask = "10.0.1.0/24"
  other_subnet_mask = "10.0.2.0/24"
}

module "acr" {
  source = "./Modules/ACR"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  acrName = local.acrName
  containerRegistryUserAssignedIdentityName = local.acaAcrIdentityName
  // WARNING: ADMIN USER ENABLED FOR TEST PURPOSES
  adminEnabled = true
}

module "acaEnvironment" {
  source = "./Modules/Environment"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  aca-subnet-id = module.network.aca-subnet-id 
  log_analytics_workspace_id = module.logAnalytics.workspaceId
  environment_name = local.acaEnvironmentName
}

module "logAnalytics" {
  source = "./Modules/LogAnalytics"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  workspaceName = local.logAnalyticsWorkspaceName
  rootName = var.rootName
}

module "keyVault" {
  source = "./Modules/KeyVault"
  keyVaultName = local.keyVaultName
  resourceGroupName = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  keyVaultUserAssignedIdentityName = local.keyVaultIdentityName
}
