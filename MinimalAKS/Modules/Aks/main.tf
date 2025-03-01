
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

resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr.id
  role_definition_name = "AcrPull"
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
    name                         = "agentpool"
    vm_size                      = "Standard_D2_v2"
    min_count                    = 1
    max_count                    = var.node_count
    enable_auto_scaling          = true
    max_pods                     = 110
    only_critical_addons_enabled = true
    vnet_subnet_id               = var.aks_subnet.id
  }

  auto_scaler_profile {
    balance_similar_node_groups = true
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
    service_cidr = var.cidr_vnet
    dns_service_ip = var.dns_service_ip
  }

  depends_on = [
    azurerm_role_assignment.aksRoleAssignment,
    var.acr,
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  name                  = var.additional_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = var.additional_node_pool_vm_size
  os_sku                = "Ubuntu"  
  min_count             = var.additional_node_pool_node_count
  max_count             = var.app_max_node_pool
  enable_auto_scaling   = true
  max_pods              = 250
  mode                  = "User"
  orchestrator_version  = azurerm_kubernetes_cluster.k8s.kubernetes_version
  vnet_subnet_id = var.aks_subnet.id
  node_labels = {
    "pool" = "guidance"
  }
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.k8s.kube_config[0].host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate)
}

resource "kubernetes_secret" "acr_auth" {
  metadata {
    name      = "acr-secret"
    namespace = "default"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      "auths" = {
        "${var.acr.login_server}" = {
          "username" = var.acr.admin_username
          "password" = var.acr.admin_password
          "auth"     = base64encode("${var.acr.admin_username}:${var.acr.admin_password}")
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}