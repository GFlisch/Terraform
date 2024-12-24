output "containerAppsEnvironmentName" {
  value = azapi_resource.env.name
}

output "containerAppsEnvironmentId" {
  value = azapi_resource.env.id
}

# output "containerAppsEnvironmentDefaultDomain" {
#   value = azurerm_container_app_environment.environment.default_domain
# }

# output "containerAppsEnvironmentLoadBalancerIP" {
#   value = azurerm_container_app_environment.environment.static_ip_address
# }