terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    bowtie = {
      source  = "bowtieworks/bowtie"
      version = "0.6.0"
    }
  }
}

# Determine the effective vpc name
locals {
  vpc_name_effective = var.vpc_name != "" ? var.vpc_name : (
    var.vpc_id != "" ? var.vpc_id : "bowtie"
  )
}
# Configure the Bowtie provider
provider "bowtie" {
  # The provider will become available only after the infrastructure is deployed
  # This is handled implicitly since we reference the module.infrastructure.primary_fqdn value
  host     = "https://${module.infrastructure.primary_fqdn}"
  username = var.bowtie_username
  password = var.bowtie_password
}

# Deploy all AWS infrastructure
module "infrastructure" {
  source = "./modules/infrastructure"

  # AWS Configuration
  region  = var.region
  profile = var.profile

  # VPC Configuration
  create_vpc = var.create_vpc
  vpc_name   = var.vpc_name
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block

  # Subnet Configuration
  create_subnets = var.create_subnets
  subnet_id      = var.subnet_id
  subnet_names   = var.subnet_names
  subnet_cidrs   = var.subnet_cidrs
  subnet_azs     = var.subnet_azs

  # Security Configuration
  create_security_group = var.create_security_group
  security_group_id     = var.security_group_id

  # Instance Configuration
  instance_type         = var.instance_type
  iam_instance_profile  = var.iam_instance_profile
  owner_id              = var.owner_id
  dns_zone_name         = var.dns_zone_name
  controller_name       = var.controller_name
  controller_count      = var.controller_count
  join_existing_cluster = var.join_existing_cluster

  # EIP Configuration
  create_eips   = var.create_eips
  eip_addresses = var.eip_addresses
  eip_domain    = var.eip_domain

  # Cloud-Init Configuration
  site_id             = var.site_id
  sync_psk            = var.sync_psk
  admin_email         = var.admin_email
  admin_password_hash = var.admin_password_hash
  ssh_key             = var.ssh_key
  sso_config          = var.sso_config

  # DNS Configuration
  create_dns_records = var.create_dns_records
  route53_zone_id    = var.route53_zone_id
  dns_ttl            = var.dns_ttl
}

# Configure Bowtie resources 
module "bowtie" {
  source = "./modules/bowtie"

  # Wait for infrastructure to be ready
  depends_on = [module.infrastructure]

  # Bowtie Connection Settings
  primary_fqdn             = module.infrastructure.primary_fqdn
  controller_name          = module.infrastructure.controller_names
  dns_zone_name            = var.dns_zone_name
  bowtie_username          = var.bowtie_username
  bowtie_password          = var.bowtie_password
  site_id                  = var.site_id
  ipv4_range               = var.ipv4_range
  create_default_resources = var.create_default_resources
}
