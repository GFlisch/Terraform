resource "azurerm_private_dns_zone" "dns" {
  name                = "dns.arc4u.io"
  resource_group_name = var.resource_group.name
}

resource "azurerm_user_assigned_identity" "aksUserAssignedIdentity" {
  name                = local.aksIdentityName
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "aksRoleAssignment" {
  scope                = azurerm_private_dns_zone.dns.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aksUserAssignedIdentity.principal_id
}


resource "azurerm_kubernetes_cluster" "k8s" {
  location            = var.resource_group.location
  name                = var.aks_name
  resource_group_name = var.resource_group.name
  dns_prefix          = local.dns_prefix

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aksUserAssignedIdentity.id]
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.node_count
  }
  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  depends_on = [
    azurerm_role_assignment.aksRoleAssignment,
  ]
}