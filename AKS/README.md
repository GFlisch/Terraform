Log to the subscription
az login --tenant 9c8f80a6-c648-4c20-90ff-5d267c8ae785
az account set --subscription "ADM Initiatives"

To run a Terraform script:
terraform init
terraform plan -out main.tfplan
terraform apply main.tfplan -auto-approve

Prepare the subscription

az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.OperationalInsights
az feature register --namespace "Microsoft.ContainerService" --name "AKS-AzureKeyVaultSecretsProvider"
az feature register --namespace Microsoft.Compute --name EncryptionAtHost

az feature list -o table --query "[?contains(properties.state, 'Registering')].{Name:name}"
az feature list -o table --query "[?contains(properties.state, 'Registereds')].{Name:name}"
