resource "azurerm_network_security_group" "netwoknsg" {
  name                = "ashishnsg"
  location            = var.resource_group_location 
  resource_group_name = var.resource_group_name 

security_rule {
  name                       = "allow-ssh"
  priority                   = 650
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

security_rule {
  name                       = "allow-http"
  priority                   = 652
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}
}