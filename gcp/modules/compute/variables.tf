variable "machine_type" {
  description = "Provides access to available Google Compute machine types in a zone for a given project."
  type        = string
}

variable "network_tier" {
  type        = string
  description = "The networking tier used for configuring this instance. This field can take the following values: PREMIUM, FIXED_STANDARD or STANDARD."
  default     = "STANDARD"
}

variable "vpc" {
  description = "The ID of the VPC."
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs."
  type        = list(string)
}

variable "subnet_regions" {
  description = "Regions associated with each subnet."
  type        = list(string)
}

variable "image_ver" {
  description = "Controller image to boot with the instance."
  type        = string
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

variable "external_ips" {
  description = "List of external IP addresses to pull from to assign to each instace. If left empty, new external addresses will be reserved and assigned."
  type        = list(string)
}
