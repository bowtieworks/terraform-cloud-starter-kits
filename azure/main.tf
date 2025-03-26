terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    bowtie = {
      source  = "bowtieworks/bowtie"
      version = "0.6.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }
  }
}

# Determine the effective resource name prefix
locals {
  name_prefix = var.resource_group_name != "" ? var.resource_group_name : "bowtie"

  # Validate that admin credentials are provided when needed
  admin_credentials_check = var.join_existing_cluster ? true : (
    var.admin_email != null && var.admin_password_hash != null ? true :
    tobool("Admin email and password hash are required when not joining an existing cluster")
  )

  # Validate that join_existing_cluster_fqdn is provided when joining an existing cluster
  fqdn_check = !var.join_existing_cluster ? true : (
    var.join_existing_cluster_fqdn != null ? true :
    tobool("join_existing_cluster_fqdn is required when join_existing_cluster is true")
  )
}

# Using local values for validation
resource "null_resource" "validate_admin_credentials" {
  count = local.admin_credentials_check ? 0 : 1
}

resource "null_resource" "validate_fqdn" {
  count = local.fqdn_check ? 0 : 1
}

# Configure the Bowtie provider
provider "bowtie" {
  # The provider will become available only after the infrastructure is deployed
  host     = "https://${module.infrastructure.primary_fqdn}"
  username = var.bowtie_username
  password = var.bowtie_password
}

# Deploy Azure infrastructure
module "infrastructure" {
  source = "./modules/infrastructure"

  # Azure Configuration
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  location        = var.location

  # Resource Group Configuration
  create_resource_group = var.create_resource_group
  resource_group_name   = var.resource_group_name

  # Virtual Network Configuration
  create_vnet   = var.create_vnet
  vnet_name     = var.vnet_name
  address_space = var.address_space

  # Subnet Configuration
  create_subnet = var.create_subnet
  subnet_name   = var.subnet_name
  subnet_prefix = var.subnet_prefix

  # Network Security Group Configuration
  create_nsg = var.create_nsg
  nsg_name   = var.nsg_name

  # VM Configuration
  vm_size        = var.vm_size
  admin_username = var.admin_username
  admin_ssh_public_key_path = var.admin_ssh_public_key_path

  # Controller Configuration
  dns_zone_name              = var.dns_zone_name
  controller_name            = var.controller_name
  controller_count           = var.controller_count
  join_existing_cluster      = var.join_existing_cluster
  join_existing_cluster_fqdn = var.join_existing_cluster_fqdn

  # Public IP Configuration
  create_public_ips   = var.create_public_ips
  public_ip_addresses = var.public_ip_addresses
  allocation_method   = var.allocation_method

  # Cloud-Init Configuration
  site_id             = var.site_id
  sync_psk            = var.sync_psk
  admin_email         = var.admin_email
  admin_password_hash = var.admin_password_hash
  ssh_key             = var.ssh_key
  sso_config          = var.sso_config

  # DNS Configuration
  create_dns_records      = var.create_dns_records
  dns_zone_resource_group = var.dns_zone_resource_group
  dns_ttl                 = var.dns_ttl
  dns_propagation_wait    = var.dns_propagation_wait
}

# Configure Bowtie resources
module "bowtie" {
  source = "./modules/bowtie"

  # Wait for infrastructure to be ready
  depends_on = [module.infrastructure]
  infrastructure_ready = module.infrastructure.module_ready

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
