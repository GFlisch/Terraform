provider "helm" {
  kubernetes {
    config_path = var.kube_config_file
  }
}

resource "azurerm_user_assigned_identity" "aksUserAssignedIdentity" {
  name                = var.aksIdentityName
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location                  = var.resource_group.location
  name                      = var.aks_name
  resource_group_name       = var.resource_group.name
  oidc_issuer_enabled       = true
  workload_identity_enabled = true # Enable workload identity
  dns_prefix                = "arc4u"
  azure_policy_enabled             = true

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2h"
  }

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
    # network_data_plane  = var.additional_windows_node_pool_node_count == 0 ? "cilium" : "azure"
    # network_policy      = var.additional_windows_node_pool_node_count == 0 ? "cilium" : "azure"
    network_data_plane  = "azure"
    network_policy      = "azure"
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

resource "azurerm_kubernetes_cluster_node_pool" "additionalWindows" {
  count                 = var.additional_windows_node_pool_node_count > 0 ? 1 : 0
  name                  = var.additional_windows_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = var.additional_windows_node_pool_vm_size
  os_type               = "Windows"
  min_count             = var.additional_windows_node_pool_node_count
  max_count             = var.app_max_node_pool
  auto_scaling_enabled  = true
  max_pods              = 250
  mode                  = "User"
  orchestrator_version  = azurerm_kubernetes_cluster.k8s.kubernetes_version
  vnet_subnet_id        = var.aks_subnet.id
  zones                 = []
  node_labels = {
    "pool" = "windows-application"
  }

  lifecycle {
    ignore_changes = [node_count]
  }
}