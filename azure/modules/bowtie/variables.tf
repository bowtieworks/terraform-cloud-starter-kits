variable "primary_fqdn" {
  description = "The fully qualified domain name of the primary controller"
  type        = string
}

variable "controller_name" {
  description = "List of controller names"
  type        = list(string)
}

variable "dns_zone_name" {
  description = "The DNS zone name to be used for the controller"
  type        = string
}

variable "bowtie_username" {
  description = "The username for authenticating with the Bowtie cluster"
  type        = string
}

variable "bowtie_password" {
  description = "The password for authenticating with the Bowtie cluster"
  type        = string
  sensitive   = true
}

variable "site_id" {
  description = "The SITE_ID of the Bowtie deployment"
  type        = string
}

variable "ipv4_range" {
  description = "The IPv4 CIDR range to apply in the Bowtie site configuration"
  type        = string
}

variable "create_default_resources" {
  description = "Whether to create default resources like IPv4/IPv6 resources, resource groups, managed domain, and DNS blocklist"
  type        = bool
  default     = false
}

variable "infrastructure_ready" {
  description = "Signal from infrastructure module that it's ready"
  type        = string
  default     = ""
}
