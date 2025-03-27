data "azurerm_resource_group" "rg" {
  name     = local.rgHubName
}

data "azurerm_key_vault" "keyvault" {
  name                = local.keyVaultName
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each            = fileset(local.certFolder, "*") # Read all files in the folder
  name                = lower(replace(each.key, "/[^a-zA-Z0-9-]/", "-")) # Replace non-alphanumeric characters with dashes
  value               = file("${local.certFolder}/${each.key}") # Read the file content
  key_vault_id        = data.azurerm_key_vault.keyvault.id
}