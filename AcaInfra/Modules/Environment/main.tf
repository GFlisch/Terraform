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



