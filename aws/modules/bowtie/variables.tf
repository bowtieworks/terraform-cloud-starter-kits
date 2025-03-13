variable "instance_names" {
  description = "Using instance_names as a method for creating a dependency on the instances being created."
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

variable "bowtie_username" {
  description = "The username for authenticating with the initialized Bowtie cluster."
  type        = string
}

variable "bowtie_password" {
  description = "The password for authenticating with the initialized Bowtie cluster."
  type        = string
  sensitive   = true
}

variable "site_id" {
  description = "The SITE_ID that the controllers are to be instantiated within."
  type        = string
}

variable "ipv4_range" {
  description = "The ipv4 CIDR range to apply in the Bowtie site configuration."
  type        = string
}

variable "create_default_resources" {
  description = "Whether to create default resources like IPv4/IPv6 resources, resource groups, managed domain, and DNS blocklist"
  type        = bool
  default     = false
}
