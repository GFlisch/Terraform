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
