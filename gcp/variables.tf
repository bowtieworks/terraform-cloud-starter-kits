variable "project" {
  description = "The default project to manage resources in."
  type        = string
}

variable "region" {
  description = "The GCP region to manage resources in."
  type        = string
  default     = "us-central1"
}

variable "create_vpc" {
  description = "Whether to create a new VPC. If false, an existing VPC with the name provided will be used."
  type        = bool
}

variable "create_subnets" {
  description = "Whether to create new subnets. If false, existing subnets with the names provided will be used."
  type        = bool
}

variable "vpc_name" {
  description = "The name of the VPC to create or use."
  type        = string
}

variable "subnet_names" {
  description = "List of subnet names to create or use."
  type        = list(string)
}

variable "subnet_cidrs" {
  description = "The address prefixes to use for each subnet."
  type        = list(string)
}

variable "subnet_regions" {
  description = "List of regions for each subnet; these should match the order of subnet names."
  type        = list(string)
}

variable "image_ver" {
  description = "Controller image to boot with the instance."
  type        = string
}

variable "machine_type" {
  description = "Provides access to available Google Compute machine types in a zone for a given project."
  type        = string
}

variable "network_tier" {
  type        = string
  description = "The networking tier used for configuring this instance. This field can take the following values: PREMIUM, FIXED_STANDARD or STANDARD."
  default     = "STANDARD"
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
  description = "Optional static external IP addresses to assign to the instances."
  type        = list(string)
  default     = []
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
