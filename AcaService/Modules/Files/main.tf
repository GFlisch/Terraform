resource "azurerm_storage_share_file" "example" {
  name             = var.file_destination_path
  storage_share_id = azurerm_storage_share.example.id
  source           = var.file_source_path
}