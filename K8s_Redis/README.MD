# Install Azure Redis Cache

After ou have created a Minimal Aks setup, if you need a redis cache in azure for you application that need to run in the same Resource Group.

Execute those commands:
terraform init
terraform plan -var="redis_cache_name=my-redis" -var="salt=wxyz" -out=tfplan
terraform apply tfplan