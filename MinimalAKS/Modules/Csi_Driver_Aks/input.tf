variable "kube_config_file" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}

  variable "key_vault_id" {
    type = string
  } 

  variable "aks_principal_id" {
    type = string
    
  }