variable "kube_config_file" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
