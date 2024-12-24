# resource "azurerm_container_app_environment" "environment" {
#   name = var.environment_name
#   location = var.location
#   resource_group_name = var.resource_group_name
#   infrastructure_subnet_id = var.aca-subnet-id
#   log_analytics_workspace_id = var.log_analytics_workspace_id
#   infrastructure_resource_group_name = var.infrastructure_resource_group_name
#   dynamic "workload_profile" {
#     for_each = var.workloadProfiles

#     content {
#       name                  = workload_profile.value.name
#       workload_profile_type = workload_profile.value.workload_profile_type
#       minimum_count         = workload_profile.value.minimum_count
#       maximum_count         = workload_profile.value.maximum_count
#     }
#   }
# }

resource "azapi_resource" "env" {
  type = "Microsoft.App/managedEnvironments@2024-10-02-preview"
  
  name = var.environment_name
  location = var.location
  parent_id = var.resource_group_id

  identity {
    type = "UserAssigned"
    identity_ids = [ 
      var.keyVault_certificates_user_identity_id
    ]
  }

  body = {
    properties = {
      infrastructureResourceGroup = var.infrastructure_resource_group_name
      vnetConfiguration = {
        infrastructureSubnetId = var.aca-subnet-id
      }
      workloadProfiles = var.workloadProfiles
    }
  }
}



