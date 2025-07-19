Set the subscription id via the environment.

-- bash command
 export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
or
 export ARM_SUBSCRIPTION_ID= " give the specific one"
 
-- powershell

 $env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv)
or
 $env:ARM_SUBSCRIPTION_ID = "give the specific one"

 Some help commands:
 terraform fmt -recursive
 terraform init --upgrade
 terraform plan -out your-plan-name.tfplan -state your-plan-name.tfstate -var="rootName=your-root-name" -var="salt=your-salt"
 
 terraform apply -state="your-plan-name.tfstate" your-plan-name.tfplan