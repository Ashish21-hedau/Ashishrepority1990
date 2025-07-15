module "resource_group" {
  source = "../Modules/azurerm_resource_group"
resource_group_name     = "rg-nginx"
resource_group_location = "WestEurope"
}


  module "resource_group" {
  source = "../Modules/azurerm_resource_group"
resource_group_name     = "rg-ashish"
resource_group_location = "Westus"
}

module "resource_group" {
  source = "../Modules/azurerm_resource_group"
resource_group_name     = "rg-kalu1190"
resource_group_location = "WestEurope"
}

module "resource_group" {
  source = "../Modules/azurerm_resource_group"
resource_group_name     = "rg-finalcode"
resource_group_location = "WestEurope"
}

module "virtual_network" {
  depends_on           = [module.resource_group]
  source               = "../Modules/azurerm_virtual_network"
  virtual_network_name = "nginx-vnet"
  location             = "WestEurope"
  resource_group_name  = "rg-nginx"
  address_space        = ["10.0.0.0/16"]
}

module "frontend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../Modules/azurerm_subnet"
 subnet_name        = "frontend-subnet"
  resource_group_name  = "rg-nginx"
  virtual_network_name = "nginx-vnet"
  address_prefixes     = ["10.0.2.0/24"]
}

module "backend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../Modules/azurerm_subnet"
 subnet_name        = "backed-subnet"
  resource_group_name  = "rg-nginx"
  virtual_network_name = "nginx-vnet"
  address_prefixes     = ["10.0.4.0/24"]
}

module "public_ip" {
    depends_on = [ module.resource_group ]
  source = "../Modules/azurerm_public_ip"
   public_ip_name          = "nginxpip"
  resource_group_name = "rg-nginx"
  resource_group_location   = "WestEurope"
  allocation_method   = "Static"
}

module "vmmachine" {
  depends_on = [ module.frontend_subnet,module.public_ip ]
  source = "../Modules/azurerm_virtual_machine"
  resource_group_name ="rg-nginx"
  subnet_name = "frontend-subnet"
  virtual_network_name = "nginx-vnet"
  public_ip_name = "nginxpip"
  nic_name = "nicashish"
  location = "WestEurope"
  vm_name = "ashishvm21"
  admin_username ="Ashish51"
  admin_password ="Megha@#21051990"
  image_publisher ="canonical"
  image_offer ="0001-com-ubuntu-server-jammy"
  image_sku = "22_04-lts"
  image_version = "latest"
  vm_size = "Standard_F2"

}

module "nsg" {
  source = "../Modules/azurerm_nsg"
  depends_on = [ module.resource_group ]
  resource_group_location = "WestEurope"
  resource_group_name = "rg-nginx"
}
