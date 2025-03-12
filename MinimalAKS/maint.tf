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
  source            = "./Modules/VNet"
  resource_group    = azurerm_resource_group.rg
  rootName          = var.rootName
  vnet_mask         = var.base_cidr
  gtw_subnet_mask   = cidrsubnet(var.base_cidr, 12, 0)
  aks_subnet_mask   = cidrsubnet(var.base_cidr, 8, 1)
  other_subnet_mask = cidrsubnet(var.base_cidr, 8, 2)
}

module "acr" {
  source                                    = "./Modules/ACR"
  resource_group_name                       = azurerm_resource_group.rg.name
  location                                  = azurerm_resource_group.rg.location
  acrName                                   = local.acrName
  containerRegistryUserAssignedIdentityName = local.aksAcrIdentityName
  // Even with the AcrPull right, this is not possible to deploy a pod from the acr
  // without admin credentials. How to do this?
  adminEnabled = true
}

module "aks" {
  source                          = "./Modules/Aks"
  resource_group                  = azurerm_resource_group.rg
  aks_name                        = local.aksName
  additional_node_pool_name       = "guidance"
  additional_node_pool_node_count = 3
  aks_subnet                      = module.network.aks_subnet
  acr                             = module.acr.acr
}

module "keyVault" {
  source                           = "./Modules/KeyVault"
  keyVaultName                     = local.keyVaultName
  resourceGroupName                = azurerm_resource_group.rg.name
  location                         = azurerm_resource_group.rg.location
  keyVaultUserAssignedIdentityName = local.keyVaultIdentityName
}

# module "nginx" {
#   source         = "./Modules/Nginx"
#   resource_group = azurerm_resource_group.rg
#   aks_name       = local.aksName
#   keyVaultId     = module.keyVault.keyVaultId
#   cert_folder    = local.certFolder
#   kube_config    = module.aks.kube_config
# }

# module "redis" {
#   source = "./Modules/Redis"
#   resource_group = azurerm_resource_group.rg
#   redis_cache_name = "GuidanceCache"
# }

# module "kubemq" {
#   source = "./Modules/KubeMQ"
#   resource_group = azurerm_resource_group.rg
#   aks_name = local.aksName
#   kubemq_build = "https://deploy.kubemq.io/build/2738749728506952"
#   kube_config = module.aks.kube_config
#   kube_config_raw = module.aks.kube_config_raw
# }