terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Variables
variable "environment" {
  default = "dev"
}

variable "location" {
  default = "Canada Central"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.environment}-01"
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.environment}-01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Subnet
resource "azurerm_subnet" "internal" {
  name                 = "subnet-${var.environment}-01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Network Interface
resource "azurerm_network_interface" "main" {
  name                = "nic-${var.environment}-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

# Public IP
resource "azurerm_public_ip" "main" {
  name                = "pip-${var.environment}-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = "nsg-${var.environment}-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Virtual Machine
resource "azurerm_virtual_machine" "main" {
  name                  = "vm-${var.environment}-01"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  vm_size               = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.main.id]

  storage_os_disk {
    name              = "osdisk-${var.environment}-01"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8-lvm-gen2"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vm-${var.environment}-01"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Output
output "azure_vm_public_ip" {
  value       = azurerm_public_ip.main.ip_address
  description = "Public IP address of the Azure VM"
}

output "azure_vm_id" {
  value       = azurerm_virtual_machine.main.id
  description = "ID of the Azure VM"
}
