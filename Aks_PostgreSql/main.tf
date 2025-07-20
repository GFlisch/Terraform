data "azurerm_resource_group" "rg" {
  name     = local.rgHubName
}

data "azurerm_kubernetes_cluster" "cluster" {
  name                = local.aksName
  resource_group_name = data.azurerm_resource_group.rg.name
}
data "azurerm_user_assigned_identity" "uami" {
  name                = local.aksIdentityName
  resource_group_name = data.azurerm_resource_group.rg.name
}
resource "azurerm_storage_account" "primary" {
  name                     = local.primary_storage_account_name
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  account_kind             = "StorageV2"

  tags = var.tags
}

resource "azurerm_storage_container" "backup" {
  name                  = local.backup_container_name
  storage_account_id    = azurerm_storage_account.primary.id
  container_access_type = "private"
}

resource "kubernetes_namespace" "postgres" {
  metadata {
    name = var.namespace
  }
}

resource "null_resource" "apply_cnpg_operator" {
  provisioner "local-exec" {
    command = "kubectl apply --server-side -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.26/releases/cnpg-1.26.0.yaml"
  }
}

resource "null_resource" "create_postgres_admin_secret" {
  provisioner "local-exec" {
    command = "kubectl create secret generic postgres-admin -n ${var.namespace} --from-literal=username=admin --from-literal=password='${var.admin-password}' --kubeconfig='${var.kube_config_file}' || true"
  }
}

resource "null_resource" "create_postgres_appuser_secret" {
  provisioner "local-exec" {
    command = "kubectl create secret generic postgres-appuser -n ${var.namespace} --from-literal=username=appuser --from-literal=password='${var.db-user-password}' --kubeconfig='${var.kube_config_file}' || true"
  }
}

resource "local_file" "cnpg_cluster_manifest" {
  filename = "${path.module}/cnpg-cluster.yaml"
  content  = <<EOF
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: ${var.pg_primary_cluster_name}
spec:
  inheritedMetadata:
    annotations:
      service.beta.kubernetes.io/azure-dns-label-name: ${var.aks_primary_cluster_pg_dnsprefix}
    labels:
      azure.workload.identity/use: "true"

  instances: ${var.replicas}
  startDelay: 30
  stopDelay: 30
  minSyncReplicas: 1
  maxSyncReplicas: 1
  replicationSlots:
    highAvailability:
      enabled: true
    updateInterval: 30

  topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        cnpg.io/cluster: ${var.pg_primary_cluster_name}

  affinity:
    nodeSelector:
      workload: postgres

  resources:
    requests:
      memory: '1Gi'
      cpu: 2
    limits:
      memory: '2Gi'
      cpu: 2

  bootstrap:
    initdb:
      database: appdb
      owner: app
      secret:
        name: db-user-pass
      dataChecksums: true

  storage:
    size: 32Gi
    pvcTemplate:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 32Gi
      storageClassName: ${var.postgres_storage_class}

  walStorage:
    size: 32Gi
    pvcTemplate:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 32Gi
      storageClassName: ${var.postgres_storage_class}

  monitoring:
    enablePodMonitor: true

  postgresql:
    parameters:
      wal_compression: lz4
      max_wal_size: 6GB
      checkpoint_timeout: 15min
      checkpoint_flush_after: 2MB
      wal_writer_flush_after: 2MB
      min_wal_size: 4GB
      shared_buffers: 4GB
      effective_cache_size: 12GB
      work_mem: 62MB
      maintenance_work_mem: 1GB
      autovacuum_vacuum_cost_limit: "2400"
      random_page_cost: "1.1"
      effective_io_concurrency: "64"
      maintenance_io_concurrency: "64"
    pg_hba:
      - host all all all scram-sha-256

  serviceAccountTemplate:
    metadata:
      annotations:
        azure.workload.identity/client-id: "${data.azurerm_user_assigned_identity.uami.client_id}"
      labels:
        azure.workload.identity/use: "true"

  backup:
    barmanObjectStore:
      destinationPath: "https://${local.primary_storage_account_name}.blob.core.windows.net/backups"
      azureCredentials:
        inheritFromAzureAD: true
    retentionPolicy: '7d'
EOF
}

resource "null_resource" "apply_cnpg_cluster" {
  provisioner "local-exec" {
    command = "kubectl apply --context ${local.aksName} -n ${var.namespace} -v 9 -f ${local_file.cnpg_cluster_manifest.filename}"
  }
  depends_on = [local_file.cnpg_cluster_manifest]
}



