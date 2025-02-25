
resource "azurerm_redis_cache" "redis" {
  name                = var.redis_cache_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  capacity            = var.capacity
  family              = "C"
  sku_name            = var.sku_name
  tags                = var.tags
  enable_non_ssl_port = true

  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }
}

