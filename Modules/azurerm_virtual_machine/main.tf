resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = data.azurerm_public_ip.pip.id

  }
}

resource "azurerm_linux_virtual_machine" "vm1" {
   name           = var.vm_name
  resource_group_name = var.resource_group_name
   location  = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

custom_data = base64encode(<<EOF
#!/bin/bash
apt update
apt install -y nginx
systemctl enable nginx
systemctl start nginx
EOF
  )
}
