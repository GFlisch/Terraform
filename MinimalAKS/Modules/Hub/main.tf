# Create the VNet

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  address_space       = [var.vnet_mask]
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

# Subnet Gtw
resource "azurerm_subnet" "gtw_subnet" {
  name                 = "gtw-subnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.gtw_subnet_mask]
}

resource "azurerm_network_security_group" "gtw-nsg" {
  name                = "gtw-nsg"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

resource "azurerm_subnet_network_security_group_association" "gtw-nsg" {
  subnet_id                 = azurerm_subnet.gtw_subnet.id
  network_security_group_id = azurerm_network_security_group.gtw-nsg.id
}

# Subnet Aks
resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.aks_subnet_mask]
}

# Subnet other
resource "azurerm_subnet" "my_terraform_subnet_2" {
  name                 = "other-subnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.other_subnet_mask]
}

