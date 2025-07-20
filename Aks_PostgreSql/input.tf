variable "rootName"{
  type = string
}

variable "salt" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "namespace" {
  description = "Database namespace"
  type = string
}

variable "admin-password" {
  description = "Password for the Admin user."
  type = string
}

variable "db-user-password" {
  description = "Password for the db user."
  type = string
}

variable "db-name" {
  description = "Database name."
  type = string
}

variable "replicas" {
  description = "Number of replicas in the Cluster."
  type = number
  default = 3
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "kube_config_file" {
  description = "Path to the kubeconfig file to use with kubectl"
  type        = string
}

variable "cert_yaml_url" {
  description = "URL of the certificate YAML file to apply"
  type        = string
}

variable "cert_password" {
  description = "Password to be provided to the kubectl apply command (as ENV)"
  type        = string
  sensitive   = true
}

variable "pg_primary_cluster_name" {
  description = "CNPG primary cluster name"
  type        = string
}

variable "aks_primary_cluster_pg_dnsprefix" {
  description = "Azure DNS label for the PG cluster service"
  type        = string
}

variable "postgres_storage_class" {
  description = "PostgreSQL storage class name"
  type        = string
}


locals {
  cleanRootName        = replace(var.rootName, "/[^a-zA-Z0-9-]/", "-")
  rgHubName            = "${local.cleanRootName}-RG-${var.salt}"
  aksName              = lower("${local.cleanRootName}-aks-${var.salt}")
  aksIdentityName      = lower("${local.cleanRootName}-aks-identity-${var.salt}")
  primary_storage_account_name = "PorstgreSql-Backup-${var.db-name}"
  backup_container_name= "PorstgreSql-Backup-${var.db-name}-container"

}