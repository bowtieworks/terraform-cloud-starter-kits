variable "resource_group_name" {
  description = "The Name which should be used for this Resource Group."
  type        = string
}

variable "resource_group_location" {
  description = "The Azure Region where the Resource Group should exist."
  type        = string
}

variable "create_vnet" {
  description = "Whether to create a new Vnet. If false, an existing Vnet with the name provided will be used."
  type        = bool
}

variable "vnet_name" {
  description = "The name given to the first vnet provisioned."
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
