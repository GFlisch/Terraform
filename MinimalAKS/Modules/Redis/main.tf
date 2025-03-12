
resource "azurerm_redis_cache" "redis" {
  name                 = var.redis_cache_name
  location             = var.resource_group.location
  resource_group_name  = var.resource_group.name
  capacity             = var.capacity
  family               = "C"
  sku_name             = var.sku_name
  tags                 = var.tags
  non_ssl_port_enabled = true

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

