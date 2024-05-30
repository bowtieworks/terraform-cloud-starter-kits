resource "azurerm_virtual_network" "vnet" {
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  count               = var.create_vnet ? 1 : 0
}

data "azurerm_virtual_network" "vnet_data" {
  resource_group_name = var.resource_group_name
  name                = var.create_vnet ? azurerm_virtual_network.vnet[0].name : var.vnet_name
}

resource "azurerm_subnet" "subnets" {
  resource_group_name  = var.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_data.name
  count                = length(var.subnet_address_prefixes)
  name                 = "${var.vnet_name}-subnet-${count.index + 1}"
  address_prefixes     = [var.subnet_address_prefixes[count.index]]

  depends_on = [azurerm_virtual_network.vnet]
}
