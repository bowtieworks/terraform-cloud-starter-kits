provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

resource "random_uuid" "site_id" {}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

output "id" {
  value = data.azurerm_resource_group.rg.id
}

module "network" {
  source = "./modules/network"

  resource_group_name     = data.azurerm_resource_group.rg.name
  resource_group_location = data.azurerm_resource_group.rg.location
  create_vnet             = var.create_vnet
  vnet_name               = var.vnet_name
  vnet_address_space      = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes
}

module "security" {
  source = "./modules/security"

  resource_group_name     = data.azurerm_resource_group.rg.name
  resource_group_location = data.azurerm_resource_group.rg.location
  subnet_ids              = module.network.subnet_ids

  depends_on = [
    module.network
  ]
}

module "virtual_machine" {
  source = "./modules/virtual_machine"

  resource_group_name     = data.azurerm_resource_group.rg.name
  resource_group_location = data.azurerm_resource_group.rg.location
  subnet_ids              = module.network.subnet_ids
  size                    = var.size
  site_id                 = resource.random_uuid.site_id.result
  sync_psk                = var.sync_psk
  user_credentials        = var.user_credentials
  public_ssh_key          = var.public_ssh_key
  dns_zone_name           = var.dns_zone_name
  controller_name         = var.controller_name
  public_ips              = var.public_ips

  depends_on = [
    module.network,
    module.security
  ]
}

module "bowtie" {
  source = "./modules/bowtie"

  instance_names  = module.virtual_machine.instance_names
  dns_zone_name   = var.dns_zone_name
  controller_name = var.controller_name
  bowtie_username = var.bowtie_username
  bowtie_password = var.bowtie_password
  site_id         = resource.random_uuid.site_id.result
  ipv4_range      = var.ipv4_range
}
