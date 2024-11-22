resource "azurerm_container_app_environment" "environment" {
  name = var.environment_name
  location = var.location
  resource_group_name = var.resource_group_name
  infrastructure_subnet_id = var.aca-subnet-id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  dynamic "workload_profile" {
    for_each = var.workloadProfiles

    content {
      name                  = workload_profile.value.name
      workload_profile_type = workload_profile.value.workload_profile_type
      minimum_count         = workload_profile.value.minimum_count
      maximum_count         = workload_profile.value.maximum_count
    }
  }
}



