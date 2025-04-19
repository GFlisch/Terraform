variable "keyVaultName" {
  description = "The name of the Key Vault"
  type        = string

}

variable "resource_group" {
  type = object({
    name     = string
    location = string
    id       = string
  })
}

variable "tags" {
  description = "The SKU of the Key Vault"
  type        = map(string)
  default     = {}

}

variable "aksIdentityPrincipalId" {
  description = "The name of the user assigned identity"
  type        = string
}
