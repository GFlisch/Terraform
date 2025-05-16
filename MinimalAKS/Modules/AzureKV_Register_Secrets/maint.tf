
resource "azurerm_key_vault_secret" "secrets" {
  for_each     = fileset(local.certFolder, "*")                   # Read all files in the folder
  name         = lower(replace(each.key, "/[^a-zA-Z0-9-]/", "-")) # Replace non-alphanumeric characters with dashes
  value        = file("${local.certFolder}/${each.key}")          # Read the file content
  key_vault_id = var.keyVaultId
  tags         = var.tags
  lifecycle {
    ignore_changes = [value] # Ignore changes to the value of the secret
  }
}
