Set the subscription id via the environment.

-- bash command
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
 
 -- powershell

 $env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv)

 $env:ARM_SUBSCRIPTION_ID = "give the specific one"