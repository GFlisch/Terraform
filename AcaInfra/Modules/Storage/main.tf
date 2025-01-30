resource "azurerm_storage_account" "storage" {
  name                     = var.storageAccountName
  resource_group_name      = var.resourceGroupName
  location                 = var.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_share" "share" {
  name                 = var.fileShareName
  quota                = 5
  storage_account_name = azurerm_storage_account.storage.name
  depends_on           = [azurerm_storage_account.storage]
}
