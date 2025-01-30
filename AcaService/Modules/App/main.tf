resource "azapi_resource" "app" {
  type      = "Microsoft.App/containerApps@2024-10-02-preview"
  name      = var.acaName
  location  = var.location
  parent_id = var.resource_group_id
  tags      = var.tags

identity {
    type = "UserAssigned"
    identity_ids = [ 
      var.keyVault_certificates_user_identity_id
    ]
  }
  body = {
    properties = {
      managedEnvironmentId = var.containerAppsEnvironmentId
      configuration = {
        ingress = {
          external = var.ingressEnabled
          targetPort = var.ingressPort
          transport = "auto"
          allowInsecure = false
          traffic = [{
            latestRevision = true
            percentage = 100
          }]
        }
        registries = [{
          server = var.acrLoginServer
          identity = var.keyVault_certificates_user_identity_id
        }]
      }
      template = {
        containers = [{
          name  = var.containerName
          image = var.containerImage
          resources = {
            cpu    = var.cpu
            memory = var.memory
          }
          env = [
            for env_var in var.environmentVariables : {
              name  = env_var.key
              value = env_var.value
            }
          ]
        }]
        scale = {
          minReplicas = 1
          maxReplicas = 10
        }
      }
    }
}
}