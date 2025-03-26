# Azure Configuration
variable "subscription_id" {
  description = "The Azure subscription ID where resources will be created."
  type        = string
}

variable "tenant_id" {
  description = "The Azure tenant ID for authentication."
  type        = string
  default     = ""
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "eastus"
}

# Resource Group Configuration
variable "create_resource_group" {
  description = "Whether to create a new resource group. If false, an existing resource group with the provided name will be used."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "The name of the resource group to create or use."
  type        = string
  default     = "bowtie-rg"
}

# Virtual Network Configuration
variable "create_vnet" {
  description = "Whether to create a new virtual network. If false, an existing virtual network with the provided name will be used."
  type        = bool
  default     = true
}

variable "vnet_name" {
  description = "The name of the virtual network to create or use."
  type        = string
  default     = "bowtie-vnet"
}

variable "address_space" {
  description = "The address space for the virtual network."
  type        = string
  default     = "10.10.0.0/16"
}

# Subnet Configuration
variable "create_subnet" {
  description = "Whether to create a new subnet. If false, an existing subnet will be used."
  type        = bool
  default     = true
}

variable "subnet_name" {
  description = "The name of the subnet to create or use."
  type        = string
  default     = "bowtie-subnet"
}

variable "subnet_prefix" {
  description = "The address prefix for the subnet."
  type        = string
  default     = "10.10.1.0/24"
}

# Network Security Group Configuration
variable "create_nsg" {
  description = "Whether to create a new network security group. If false, an existing NSG will be used."
  type        = bool
  default     = true
}

variable "nsg_name" {
  description = "The name of the network security group to create or use."
  type        = string
  default     = "bowtie-nsg"
}

# VM Configuration
variable "vm_size" {
  description = "The size of the Azure VMs for Bowtie controllers."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "The username for the VM admin user."
  type        = string
  default     = "bowtieadmin"
}

variable "admin_ssh_public_key_path" {
  description = "Path to the SSH public key file for VM authentication"
  type        = string
}

# Controller Configuration
variable "dns_zone_name" {
  description = "The DNS zone name suffix for controller FQDNs (e.g., bowtie.example.com)."
  type        = string
}

variable "controller_name" {
  description = "List of unique name identifiers to be prefixed on the dns_zone_name. If empty and controller_count > 0, names will be automatically generated."
  type        = list(string)
  default     = []
}

variable "controller_count" {
  description = "Number of controllers to create. If specified, overrides the length of controller_name list."
  type        = number
  default     = 1
}

variable "join_existing_cluster" {
  description = "Flag to indicate if the deployment is to join an existing cluster."
  type        = bool
  default     = false
}

variable "join_existing_cluster_fqdn" {
  description = "The full FQDN of the existing primary controller to join when join_existing_cluster is true."
  type        = string
  default     = null
}

# Cloud-Init Configuration
variable "cloud_init_first_instance" {
  description = "Template to use for the first instance's cloud-init configuration."
  type        = string
  default     = "cloud-init-first-instance.tftpl"
}

variable "cloud_init_join_cluster" {
  description = "Template to use for joining instances' cloud-init configuration."
  type        = string
  default     = "cloud-init-join-cluster.tftpl"
}

# Public IP Configuration
variable "create_public_ips" {
  description = "Whether to create new public IPs instead of using existing ones."
  type        = bool
  default     = true
}

variable "public_ip_addresses" {
  description = "List of public IP addresses to assign to each VM if create_public_ips is false."
  type        = list(string)
  default     = []
}

variable "allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic."
  type        = string
  default     = "Static"
}

# Cloud-Init Configuration
variable "site_id" {
  description = "The site ID to use in cloud-init configuration."
  type        = string
}

variable "sync_psk" {
  description = "The pre-shared key for synchronization between controllers."
  type        = string
  sensitive   = true
}

variable "admin_email" {
  description = "Admin email address for initialization."
  type        = string
  default     = null
}

variable "admin_password_hash" {
  description = "Hashed admin password for initialization."
  type        = string
  sensitive   = true
  default     = null
}

variable "ssh_key" {
  description = "SSH public key for root access."
  type        = string
}

variable "sso_config" {
  description = "Optional SSO configuration."
  type        = string
  default     = ""
}

# DNS Configuration
variable "create_dns_records" {
  description = "Whether to create Azure DNS records for the controllers."
  type        = bool
  default     = false
}

variable "dns_zone_resource_group" {
  description = "The resource group of the Azure DNS zone where DNS records will be created."
  type        = string
  default     = ""
}

variable "dns_ttl" {
  description = "The TTL for the DNS records (in seconds)."
  type        = number
  default     = 300
}

variable "dns_propagation_wait" {
  description = "Time to wait (in seconds) for DNS records to propagate before creating VMs."
  type        = number
  default     = 60
}
