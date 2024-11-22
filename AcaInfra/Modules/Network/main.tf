# Create the VNet

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  address_space       = [var.vnet_mask]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# # Subnet Gtw
# resource "azurerm_subnet" "gtw_subnet" {
#   name                 = "gtw-subnet"
#   resource_group_name  = var.resource_group.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = [var.gtw_subnet_mask]
# }

# resource "azurerm_network_security_group" "gtw-nsg" {
#   name                = "gtw-nsg"
#   location            = var.resource_group.location
#   resource_group_name = var.resource_group.name
# }

# resource "azurerm_subnet_network_security_group_association" "gtw-nsg-group" {
#   subnet_id                 = azurerm_subnet.gtw_subnet.id
#   network_security_group_id = azurerm_network_security_group.gtw-nsg.id
# }

# resource "azurerm_public_ip" "gtw-ip" {
#   name                = "gtw-pip"
#   location            = var.resource_group.location
#   resource_group_name = var.resource_group.name
#   allocation_method   = "Static"

# }

# resource "azurerm_network_interface" "gtw-nic" {
#   name                = "gtw-nic"
#   location            = var.resource_group.location
#   resource_group_name = var.resource_group.name

#   ip_configuration {
#     name                          = "internet"
#     subnet_id                     = azurerm_subnet.gtw_subnet.id
#     private_ip_address_allocation = "Static"
#     public_ip_address_id          = azurerm_public_ip.gtw-ip.id
#     private_ip_address            = local.first_private_gtw_ip
#   }
# }

# Subnet Aca
resource "azurerm_subnet" "aca-subnet" {
  name                 = "aca-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.aca_subnet_mask]
  
  delegation {
    name = "Microsoft.App/environments"
    service_delegation {
      name = "Microsoft.App/environments"
      actions = [ 
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_network_security_group" "aca-nsg" {
  name                = "aca-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "aca-nsg-group" {
  subnet_id                 = azurerm_subnet.aca-subnet.id
  network_security_group_id = azurerm_network_security_group.aca-nsg.id
}

# Subnet other
resource "azurerm_subnet" "other_subnet" {
  name                 = "other-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.other_subnet_mask]
}

resource "azurerm_network_security_group" "other-nsg" {
  name                = "other-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "other-nsg-group" {
  subnet_id                 = azurerm_subnet.other_subnet.id
  network_security_group_id = azurerm_network_security_group.other-nsg.id
}

