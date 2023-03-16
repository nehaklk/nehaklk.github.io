provider "azurerm" {
  features {}
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-dev-${var.location}-001"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_grp
  lifecycle {
    create_before_destroy = true
  }
}
resource "azurerm_public_ip" "public_ip"{
    name                = "acceptanceTestPublicIp1"
  resource_group_name = var.resource_grp
  location            = var.location
  allocation_method   = "Static"
}
resource "azurerm_subnet" "snet" {
  name                 = "subnet-dev-${var.location}-001"
  address_prefixes     = var.snet_address_space
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_grp
}
resource "azurerm_network_interface" "nic" {
  name                = "nic-01-${var.servername}"
  resource_group_name = var.resource_grp
  location            = var.location
  
  ip_configuration {
    name                          = "niccfg-01-${var.servername}"
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.servername
  resource_group_name = var.resource_grp
  location            = var.location
  size                = lookup(var.vm_size, var.location, "Standard_B1s")
  admin_username      = var.admin_user
  admin_password = var.admin_pass
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = var.admin_user
    public_key = file("/workspaces/nehaklk.github.io/terraformlab/mykey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = lookup(var.storage_account_type, var.location)
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "acceptanceTestSecurityGroup1"
  resource_group_name = var.resource_grp
  location            = var.location

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.snet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}