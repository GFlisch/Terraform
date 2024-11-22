variable "acaName" {
  description = "Name of the ACA"
  type        = string
}

variable "resourceGroupName" {
  description = "Name of the Resource Group"
  type        = string
}

variable "containerAppsEnvironmentId" {
  description = "ID of the Container Apps Environment"
  type        = string
}

variable "tags" {
  description = "Tags for the ACA"
  type        = map(string)
  default = {}
}

variable "workloadProfileName" {
    description = "Name of the Workload Profile"
    type        = string
    default = "Consumption"
}

variable "containerRegistryUserAssignedIdentityId" {
    description = "ID of the User Assigned Identity for the Container Registry"
    type        = string 
}

variable "ingressEnabled" {
    description = "Enable Ingress"
    type        = bool
}

variable "ingressPort" {
    description = "ID of the Subnet for Ingress"
    type        = string
}

variable "containerName" {
    description = "Name of the Container"
    type        = string  
    default = "container"
}

variable "cpu" {
    description = "CPU for the Container"
    type        = string
    default = "0.5"
}

variable "memory" {
    description = "Memory for the Container"
    type        = string
    default = "1Gi"
}

variable "containerImage" {
    description = "Image for the Container"
    type        = string
}

variable "environmentVariables" {
    description = "Environment Variables for the Container"
    type        = map(string) 
    default = {} 
}

variable "acrLoginServer" {
    description = "URL of the ACR"
    type        = string
}