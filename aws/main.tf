provider "aws" {
  region  = var.region
  profile = "AdministratorAccess-055769116956"
}

resource "random_uuid" "site_id" {}

module "network" {
  source = "./modules/network"

  create_vpc     = var.create_vpc
  create_subnets = var.create_subnets
  vpc_name       = var.vpc_name
  vpc_id         = var.vpc_id
  subnet_id      = var.subnet_id
  cidr_block     = var.cidr_block
  subnet_names   = var.subnet_names
  subnet_cidrs   = var.subnet_cidrs
  subnet_azs     = var.subnet_azs
}

module "security" {
  source = "./modules/security"

  vpc_id = module.network.vpc_id
}

module "compute" {
  source = "./modules/compute"

  owner_id                 = var.owner_id
  instance_type            = var.instance_type
  vpc_security_group_ids   = module.security.security_group_ids
  subnet_ids               = module.network.subnet_ids
  site_id                  = resource.random_uuid.site_id.result
  sync_psk                 = var.sync_psk
  user_credentials         = var.user_credentials
  public_ssh_key           = var.public_ssh_key
  dns_zone_name            = var.dns_zone_name
  controller_name          = var.controller_name
  eip_addresses            = var.eip_addresses
  join_existing_cluster    = var.join_existing_cluster
  join_controller_hostname = var.join_controller_hostname

  depends_on = [
    module.network,
    module.security
  ]

}

module "bowtie" {
  source = "./modules/bowtie"

  instance_names  = module.compute.instance_names
  dns_zone_name   = var.dns_zone_name
  controller_name = var.controller_name
  bowtie_username = var.bowtie_username
  bowtie_password = var.bowtie_password
  site_id         = resource.random_uuid.site_id.result
  ipv4_range      = var.ipv4_range
}
