terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.71"
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