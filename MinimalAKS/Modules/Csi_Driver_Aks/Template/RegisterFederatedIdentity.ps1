$issuerUrl = $(az aks show --resource-group ${resource_group} --name ${aks_name} --query "oidcIssuerProfile.issuerUrl" --output tsv)

$namespace = Read-Host "Please enter the namespace?"
$namespaceLower = $namespace.ToLower()

az identity federated-credential create `
  --name "${root_name}-$namespaceLower-fic" `
  --resource-group ${resource_group} `
  --identity-name "workload-identity" `
  --issuer $issuerUrl `
  --subject "system:serviceaccount:$namespaceLower:aks-guidance-sa" `
  --audience "api://AzureADTokenExchange"