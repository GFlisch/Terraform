data "azurerm_resource_group" "rg" {
  name = local.resourceGroupName
}

data "azurerm_container_registry" "acr" {
  name                = local.acrName
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_user_assigned_identity" "acrPullIdentity" {
  name                = local.acrPullIdentityName
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_container_app_environment" "acaEnv" {
  name                = local.acaEnvName
  resource_group_name = data.azurerm_resource_group.rg.name
}

# data "azurerm_key_vault"

module "aca" {
  source = "./Modules/App"
  acaName = var.acaName
  resource_group_id = data.azurerm_resource_group.rg.id
  containerAppsEnvironmentId = data.azurerm_container_app_environment.acaEnv.id
  keyVault_certificates_user_identity_id = data.azurerm_user_assigned_identity.acrPullIdentity.id
  ingressEnabled = var.ingressEnabled
  ingressPort = var.ingressPort
  containerName = var.containerName
  containerImage = var.containerImage
  acrLoginServer = data.azurerm_container_registry.acr.login_server
  environmentVariables = var.environmentVariables
  location = data.azurerm_resource_group.rg.location
}