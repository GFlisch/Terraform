variable "rgLzName" {
  type    = string
  default = "Aks-AVM-LZ-RG"
}

variable "vnetLzName" {
  type    = string
  default = "vnet-lz"
}
variable "rgHubName" {
  type    = string
  default = "Aks-AVM-Hub-RG"
}


variable "location" {
  type    = string
  default = "westeurope"
}

variable "vnetHubName" {
  type    = string
  default = "vnet-hub"
}

variable "acrName" {
  type    = string
  default = "guidanceCR"
}

variable "akvName" {
  type    = string
  default = "guidanceKV"

}

variable "adminGroupObjectIds" {
  type    = string
  default = "73a05fb9-2aab-4bcc-883c-b0633dbc9ac2"
}

