Set the subscription id via the environment.

-- bash command
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
 
 -- powershell

 $env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv)

 $env:ARM_SUBSCRIPTION_ID = "give the specific one"

 Some help commands:
 terraform fmt -recursive
 terraform init --upgrade
 terraform plan -out guidance.tfplan -state guidance.tfstate -var="rootName=aks-guidance" -var="salt=arc4u"
 terraform apply -state="guidance.tfstate" guidance.tfplan