output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "aks_subnet" {
  value = azurerm_subnet.aks_subnet
}

output "public_ip_address"{
  value = azurerm_public_ip.gtw-ip.ip_address
}