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

resource "local_file" "kubeconfig" {
  content  = module.aks.kube_config_raw
  filename = "${path.module}/temp/kubeconfig.yaml"
}

module "keyVault" {
  source                           = "./Modules/KeyVault"
  keyVaultName                     = local.keyVaultName
  resourceGroupName                = azurerm_resource_group.rg.name
  location                         = azurerm_resource_group.rg.location
  keyVaultUserAssignedIdentityName = local.keyVaultIdentityName
}

# module "csi_driver_aks" {
#   source           = "./Modules/Csi_Driver_Aks"
#   kube_config_file = local_file.kubeconfig.filename
# }

module "cert_manager" {
  source           = "./Modules/CertMgr"
  kube_config_file = local_file.kubeconfig.filename
  cert_version     = "v1.17.0"
  email            = var.issuer_email
}

module "key_vault_secrets" {
  source         = "./Modules/AzureKV_Register_Secrets"
  rootName = var.rootName
}

# module "nginx" {
#   source         = "./Modules/Nginx"
#   resource_group = azurerm_resource_group.rg
#   aks_name       = local.aksName
#   keyVaultId     = module.keyVault.keyVaultId
#   cert_folder    = local.certFolder
#   kube_config    = module.aks.kube_config
# }