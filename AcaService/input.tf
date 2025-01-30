variable "rootName" {
  type = string
  description = "Name of the root" 
  default = "Aca-Arc4u" 
}

variable "acaName" {
  type = string
  description = "Name of the ACA"
}

variable "ingressEnabled" {
  type = bool
  description = "Enable ingress for the ACA"  
}

variable "ingressPort" {
  type = number
  description = "Port for ingress"  
}

variable "containerName" {
  type = string
  description = "Name of the container"
}

variable "containerImage" {
  type = string
  description = "Image of the container"
}

locals {
  resourceGroupName = "${var.rootName}-Spoke-RG"
  acrName = "${replace(var.rootName, "-", "")}acr"
  acrPullIdentityName = "${var.rootName}-acr-pull-identity"
  acaEnvName = "${var.rootName}-environment"
  
}

variable "environmentVariables" {
  description = "Environment Variables for the Container"
  type = list(object({
    key   = string
    value = string
  }))
  default = []
}