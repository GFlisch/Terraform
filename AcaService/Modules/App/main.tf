resource "azurerm_container_app" "app" {
#   count                        = var.deployApp ? 1 : 0
  name                         = var.acaName
  resource_group_name          = var.resourceGroupName
  container_app_environment_id = var.containerAppsEnvironmentId
  tags                         = var.tags
  workload_profile_name        = var.workloadProfileName

  identity {
    type         = "UserAssigned"
    identity_ids = [var.containerRegistryUserAssignedIdentityId]
  }

  registry {
    server = var.acrLoginServer
    identity = var.containerRegistryUserAssignedIdentityId
  }

  revision_mode = "Single"

  ingress {
    allow_insecure_connections = false
    external_enabled           = var.ingressEnabled
    target_port                = var.ingressPort
    transport                  = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    container {
      name   = var.containerName
      cpu    = var.cpu
      memory = var.memory
      image  = var.containerImage
    }

    dynamic "env" {
      for_each = var.environmentVariables
      content {
        name  = env.key
        value = env.value
      }
    }

    min_replicas = 1
    max_replicas = 10
  }
}
