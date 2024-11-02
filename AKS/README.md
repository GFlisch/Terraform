Log to the subscription
az login --tenant 9c8f80a6-c648-4c20-90ff-5d267c8ae785
az account set --subscription "ADM Initiatives"

To run a Terraform script:
terraform init
terraform plan -out main.tfplan
terraform apply main.tfplan -auto-approve