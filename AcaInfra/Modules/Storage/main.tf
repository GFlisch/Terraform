resource "azurerm_storage_account" "stacc" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Premium"
  account_replication_type = "LRS"
  account_kind             = "FileStorage"
}

resource "azurerm_storage_share" "share" {
  name                 = "settings"
  quota                = "5"
  storage_account_name = azurerm_storage_account.storage.name
  depends_on           = [azurerm_storage_account.storage]
}