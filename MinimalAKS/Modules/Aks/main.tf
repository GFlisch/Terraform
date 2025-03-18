resource "azurerm_user_assigned_identity" "aksUserAssignedIdentity" {
  name                = local.aksIdentityName
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}


# resource "azurerm_kubernetes_cluster_extension" "k8sRouting" {
#   name = "httpApplicationRouting"
#   cluster_id = azurerm_kubernetes_cluster.k8s.id
#   extension_type = "HttpApplicationRouting"
# }

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = var.resource_group.location
  name                = var.aks_name
  resource_group_name = var.resource_group.name
  oidc_issuer_enabled = true
  dns_prefix          = "arc4u"
  # install nginx
  http_application_routing_enabled = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aksUserAssignedIdentity.id]
  }


  default_node_pool {
    name                         = "agentpool"
    vm_size                      = "Standard_D2as_v5"
    os_sku                       = "AzureLinux"
    min_count                    = 1
    max_count                    = 3
    auto_scaling_enabled         = true
    max_pods                     = 110
    only_critical_addons_enabled = true
    vnet_subnet_id               = var.aks_subnet.id
    zones                        = []
  }

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }

  auto_scaler_profile {
    scale_down_unneeded        = "1m"
    scale_down_delay_after_add = "1m"
    scale_down_unready         = "1m"
    // deployment will always be done in the additional node pool. Not the default node pool
    skip_nodes_with_system_pods = true
  }

  // need more explanation
  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"
    network_policy      = "cilium"
    service_cidr        = "10.255.255.0/24"
    dns_service_ip      = "10.255.255.253"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  name                  = var.additional_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = var.additional_node_pool_vm_size
  os_sku                = "AzureLinux"
  min_count             = var.additional_node_pool_node_count
  max_count             = var.app_max_node_pool
  auto_scaling_enabled  = true
  max_pods              = 250
  mode                  = "User"
  orchestrator_version  = azurerm_kubernetes_cluster.k8s.kubernetes_version
  vnet_subnet_id        = var.aks_subnet.id
  zones                 = []
  node_labels = {
    "pool" = "application"
  }

  lifecycle {
    ignore_changes = [node_count]
  }
}