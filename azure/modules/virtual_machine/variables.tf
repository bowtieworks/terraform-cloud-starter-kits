variable "resource_group_name" {
  description = "The name which should be used for this Resource Group."
  type        = string
}

variable "resource_group_location" {
  description = "The Azure Region where the Resource Group should exist."
  type        = string
}

variable "public_ips" {
  description = "Optional list of Public IP Address IDs. Leave empty if IPs should be created."
  type        = list(string)
  default     = []
}

variable "size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_D2as_v4"
}

variable "site_id" {
  description = "The SITE_ID that the controllers are to be instantiated within."
  type        = string
}

variable "sync_psk" {
  description = "The BOWTIE_SYNC_PSK that is to be shared across the cluster."
  type        = string
}

variable "public_ssh_key" {
  description = "The public ssh key that is to be used with the controllers."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs."
  type        = list(string)
}

variable "dns_zone_name" {
  description = "The DNS name to be used as the root for the controller hostnames."
  type        = string
}

variable "controller_name" {
  description = "List of unique name identifiers to be prefixed on the dns_zone_name."
  type        = list(string)
}

variable "user_credentials" {
  description = "The user credentials to be deployed upon initialization."
  type        = string
}
