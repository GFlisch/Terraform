terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.25.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {
}