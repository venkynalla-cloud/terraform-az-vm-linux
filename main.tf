/*data "azurerm_resource_group" "rg" {
  name = "rg-storage-prod-001"
}

resource "azurerm_storage_account" "sa" {
  name                     = "stlistofheroes002"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

}*/

data "azurerm_resource_group" "rg-compute-vm-prod-001" {
  name = "rg-compute-vm-prod-001"
}

data "azurerm_subnet" "snet-001" {
  resource_group_name  = "rg-network-prod-001"
  virtual_network_name = "vnet-prod-cancentral-002"
  name                 = "snet-001"
}

resource "azurerm_network_interface" "nic-ubuntu-002" {
  resource_group_name = data.azurerm_resource_group.rg-compute-vm-prod-001.name
  location            = data.azurerm_resource_group.rg-compute-vm-prod-001.location
  name                = "nic-ubuntu-002"
  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.snet-001.id
  }
}

resource "azurerm_linux_virtual_machine" "vm-ubuntu002" {
  admin_username = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.public_key
  }
  name                = "vm-ubuntu002"
  size                = "Standard_B1s"
  resource_group_name = data.azurerm_resource_group.rg-compute-vm-prod-001.name
  location            = data.azurerm_resource_group.rg-compute-vm-prod-001.location
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  network_interface_ids = [azurerm_network_interface.nic-ubuntu-002.id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

}
