variable "resource_group_name" {
  description = "The name which should be used for this Resource Group."
  type        = string
}

variable "resource_group_location" {
  description = "The Azure region where the Resource Group should exist."
  type        = string
}

variable "create_vnet" {
  description = "Whether to create a new Vnet. If false, an existing Vnet with the name provided will be used."
  type        = bool
}

variable "vnet_name" {
  description = "The name of the Vnet to create or use."
  type        = string
}

variable "vnet_address_space" {
  description = "The address prefixe to use for the Vnet."
  type        = list(string)
}

variable "subnet_address_prefixes" {
  description = "The address prefixes to use for each subnet."
  type        = list(string)
}

variable "private_ip_address_allocation" {
  description = "The allocation method for the private IP address."
  type        = string
  default     = "Dynamic"
}

variable "size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_D2as_v4"
}

variable "sync_psk" {
  description = "The BOWTIE_SYNC_PSK that is to be shared across the cluster."
  type        = string
}

variable "public_ssh_key" {
  description = "The public ssh key that is to be used with the controllers."
  type        = string
}

variable "user_credentials" {
  description = "The user credentials to be deployed upon initialization."
  type        = string
}

variable "dns_zone_name" {
  description = "The DNS name to be used as the root for the controller hostnames."
  type        = string
}

variable "controller_name" {
  description = "List of unique name identifiers to be prefixed on the dns_zone_name."
  type        = list(string)
}

variable "public_ips" {
  description = "List of Public IP Address names"
  type        = list(string)
}

variable "bowtie_username" {
  description = "The username for authenticating with the initialized Bowtie cluster."
  type        = string
}

variable "bowtie_password" {
  description = "The password for authenticating with the initialized Bowtie cluster."
  type        = string
  sensitive   = true
}

variable "ipv4_range" {
  description = "The ipv4 CIDR range to apply in the Bowtie site configuration."
  type        = string
}
