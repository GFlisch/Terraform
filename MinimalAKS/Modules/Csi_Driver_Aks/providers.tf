terraform {
  required_providers {
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "~> 3.71"
    # }
    # azapi = {
    #   source = "azure/azapi"
    #   version = "~> 2.1.0"
    # }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.19.0"
    }
    #helm = {
    #  source  = "hashicorp/helm"
    #  version = "~> 2.17.0"
    #}
    # null = {
    #   source = "hashicorp/null"
    #   version = "~> 3.0"
    # }
  }
}

# provider "azurerm" {
#   features {}
# }

# provider "azapi" {
# }