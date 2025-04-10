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
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzmNAuy2gppwJ3sZBWtguRi/e9uTWJwaERK6ScZBGI0ZA8ZbMMj+vLrEyAKs5OXA3Zq536x5jzYP5lqzg3hg4KEWF/pn2Evim9VDUmCim+wRp+SybVxkuQfLHPPC+zQRvreYvqFvlL8sWtpTcqEfCr7DdKazxml0SrzSYM7jG7U76JuinijutrlWO3j0CVzkGK0NdcRcI36yripMvj348lLWy5AUciDmj87Pz7GK4edAZfQZQ7FZpcXr8EzUABnZCq3sn471HbgW4mZauEgZFD2z0vEnIvdrqUoO2KrXtCso3Up6Ik32Hx2iITUvXTZVkezuGJ/n1yl/00AdKgtfiPtl/A//nPK1Vpl1APzH1fKHZXZU79vafnu/JchkVpu83S9Q22DVZF9jaEQ6RcK+8liXowXTRuTuWA4S89PXi6x3/QY8dm8vuCy0UiRG4op9Fn69bcouQ9G0GXi/wP6mvRGhlxKAZH/UE7BhwjaA9FLKW9MATjpczusRKRckptQhk= generated-by-azure"
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
