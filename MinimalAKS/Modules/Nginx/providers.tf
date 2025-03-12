terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.19.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17.0"
    }
    # null = {
    #   source = "hashicorp/null"
    #   version = "~> 3.2.3"
    # }
  }
}

