data "azurerm_resource_group" "rg" {
  name = local.rgHubName
}

resource "azurerm_storage_account" "storage" {
  name                     = lower(replace("${local.rgHubName}storage", "-", ""))
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Enable File Share support
  share_properties {
    retention_policy {
      days = var.retention_days
    }
  }

  tags = var.tags
}

# Create File Shares
resource "azurerm_storage_share" "shares" {
  for_each             = var.file_shares
  name                 = each.key
  storage_account_name = azurerm_storage_account.storage.name
  quota                = each.value

  acl {
    id = "GuestAccess"
    
    access_policy {
      permissions = "rwdl"
    }
  }
}

resource "null_resource" "register_secret" {
  provisioner "local-exec" {
    command = <<EOT
      kubectl create secret generic azure-secret --from-literal=azurestorageaccountname=${azurerm_storage_account.storage.name}  --from-literal=azurestorageaccountkey=${azurerm_storage_account.storage.primary_access_key}  --namespace=${var.namespace}
    EOT
  }

  depends_on = [azurerm_storage_account.storage, azurerm_storage_share.shares]
}
