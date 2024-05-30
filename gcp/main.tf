provider "google" {
  project = var.project
  region  = var.region
}

resource "random_uuid" "site_id" {}

module "network" {
  source = "./modules/network"

  create_vpc     = var.create_vpc
  vpc_name       = var.vpc_name
  create_subnets = var.create_subnets
  subnet_names   = var.subnet_names
  subnet_cidrs   = var.subnet_cidrs
  subnet_regions = var.subnet_regions
}

module "security" {
  source = "./modules/security"

  vpc_name = module.network.vpc_id
}

module "compute" {
  source = "./modules/compute"

  machine_type     = var.machine_type
  network_tier     = var.network_tier
  vpc              = module.network.vpc_id
  subnets          = module.network.subnet_ids
  subnet_regions   = module.network.subnet_regions
  image_ver        = var.image_ver
  site_id          = resource.random_uuid.site_id.result
  sync_psk         = var.sync_psk
  user_credentials = var.user_credentials
  public_ssh_key   = var.public_ssh_key
  dns_zone_name    = var.dns_zone_name
  controller_name  = var.controller_name
  external_ips     = var.external_ips

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
