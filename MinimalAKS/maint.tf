# rg ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
  suffix  = ["hub"]
}

# rg is required for resource modules
resource "azurerm_resource_group" "rg" {
  location = "westeurope" ##module.regions.regions[random_integer.region_index.result].name
  name     = local.rgHubName
}

module "network" {
  source = "./Modules/Hub"
  resource_group = azurerm_resource_group.rg
  rootName = var.rootName
  vnet_mask = "10.0.0.0/16"
  gtw_subnet_mask = "10.0.0.0/24"
  aks_subnet_mask = "10.0.1.0/24"
  other_subnet_mask = "10.0.2.0/24"
}

module "acr" {
  source = "./Modules/ACR"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  acrName = local.acrName
  containerRegistryUserAssignedIdentityName = local.aksAcrIdentityName
  // WARNING: ADMIN USER ENABLED FOR TEST PURPOSES
  adminEnabled = false
}

module "aks" {
  source = "./Modules/Aks"
  resource_group = azurerm_resource_group.rg
  aks_name = local.aksName
  additional_node_pool_name = "guidance"
  additional_node_pool_node_count = 3
}

module "keyVault" {
  source = "./Modules/KeyVault"
  keyVaultName = local.keyVaultName
  resourceGroupName = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  keyVaultUserAssignedIdentityName = local.keyVaultIdentityName
}

module "nginx" {
  source = "./Modules/Nginx"
  resource_group = azurerm_resource_group.rg
  aks_name = local.aksName
  keyVaultId = module.keyVault.keyVaultId
  cert_folder = local.certFolder
}

module "redis" {
  source = "./Modules/Redis"
  resource_group = azurerm_resource_group.rg
  redis_cache_name = "GuidanceCache"
}

module "kubemq" {
  source = "./Modules/KubeMQ"
  resource_group = azurerm_resource_group.rg
  aks_name = local.aksName
  kubemq_build = "https://deploy.kubemq.io/build/5923573806099130"
}