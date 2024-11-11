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