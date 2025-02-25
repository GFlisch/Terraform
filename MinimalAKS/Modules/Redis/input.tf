variable "redis_cache_name" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
    id       = string
  })
}

variable "capacity" {
  type = number 
  default = 0
}

variable "sku_name" {
  type = string
  default = "Basic"
}

