resource "azurerm_virtual_network" "azure-vn" {
  name                = var.azurerm_virtual_network_name
  resource_group_name = azurerm_resource_group.azure.name
  location            = azurerm_resource_group.azure.location
  address_space       = [var.vnet_range[0]]
}

resource "azurerm_subnet" "azure-subnet" {
  name                 = var.azurerm_subnet_name
  resource_group_name  = azurerm_resource_group.azure.name
  virtual_network_name = azurerm_virtual_network.azure-vn.name
  address_prefixes     = [var.subnet_range[0]]
}

resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_public_ip" "azure-pip" {
  name                = var.azurerm_public_ip
  location            = azurerm_resource_group.azure.location
  resource_group_name = azurerm_resource_group.azure.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "azure-ni" {
  name                = "example-nic"
  location            = azurerm_resource_group.azure.location
  resource_group_name = azurerm_resource_group.azure.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.azure-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.azure-pip.id
  }
}

resource "azurerm_linux_virtual_machine" "azure-vm" {
  name                = var.computer_name
  location            = azurerm_resource_group.azure.location
  resource_group_name = azurerm_resource_group.azure.name
  network_interface_ids = [
    azurerm_network_interface.azure-ni.id,
  ]

  size = var.azurerm_vm_size

  admin_username = var.user_name
  admin_ssh_key {
    username   = var.user_name
    public_key = file("~/.ssh/id_rsa.pub") 
  }


  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }

  os_disk {
    name              = "${var.computer_name}-osdisk"
    caching           = "ReadWrite"
    storage_account_type = var.storage_account_type
  }
}