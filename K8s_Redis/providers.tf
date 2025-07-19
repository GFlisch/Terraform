terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.27.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {
}