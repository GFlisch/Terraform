data "azurerm_resource_group" "rg" {
  name     = local.rgHubName
}

resource "azurerm_redis_cache" "redis" {
  name                = local.redisCacheName
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  capacity            = var.capacity
  family              = "C"
  sku_name            = var.sku_name
  tags                = var.tags
  non_ssl_port_enabled = false

  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }

patch_schedule {
    day_of_week        = "Saturday"
    start_hour_utc     = 0
    maintenance_window = "PT5H"
  }

  patch_schedule {
    day_of_week        = "Sunday"
    start_hour_utc     = 0
    maintenance_window = "PT5H"
  }

}
