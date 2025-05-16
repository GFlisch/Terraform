terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.27"
    }
    azapi = {
      source = "azure/azapi"
      version = "~> 2.1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {
}