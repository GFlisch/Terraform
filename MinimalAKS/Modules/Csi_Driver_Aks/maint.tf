
resource "local_file" "service_class_provider_yaml" {
  filename = "./output/SecretClassProvider.yaml" # Path to the output file
  content  = local.secret_class_provider         # Content to write to the file
}

resource "local_file" "service_account_yaml" {
  filename = "./output/ServiceAccount.yaml" # Path to the output file
  content  = local.service_account          # Content to write to the file
}

resource "local_file" "federated_identity_ps1" {
  filename = "./output/RegisterFederatedIdentity.ps1" # Path to the output file
  content  = local.federated_identity                 # Content to write to the file
}

data "azurerm_client_config" "current" {}
