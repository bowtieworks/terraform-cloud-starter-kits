# AWS Configuration
variable "region" {
  description = "The AWS region the resources will be created within."
  type        = string
}

variable "profile" {
  description = "The AWS profile to use for authentication."
  type        = string
  default     = ""
}

# VPC Configuration
variable "create_vpc" {
  description = "Whether to create a new VPC. If false, an existing VPC with the provided ID will be used."
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "The name of the VPC to create. Also used as prefix for resource naming."
  type        = string
  default     = "bowtie"
}

variable "vpc_id" {
  description = "The ID of a pre-existing VPC to use if create_vpc is false."
  type        = string
  default     = ""
}

variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.10.0.0/16"
}

# Subnet Configuration
variable "create_subnets" {
  description = "Whether to create new subnets. If false, an existing subnet with the provided ID will be used."
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "The ID of a pre-existing subnet to use if create_subnets is false."
  type        = string
  default     = ""
}

variable "subnet_names" {
  description = "List of subnet names to create."
  type        = list(string)
  default     = ["subnet-1"]
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for the subnets."
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "subnet_azs" {
  description = "List of availability zones for the subnets."
  type        = list(string)
  default     = []
}
# Security Configuration
variable "create_security_group" {
  description = "Whether to create a new security group or use an existing one."
  type        = bool
  default     = true
}

variable "security_group_id" {
  description = "ID of an existing security group to use if create_security_group is false."
  type        = string
  default     = ""
}

# Instance Configuration
variable "instance_type" {
  description = "The EC2 instance type to use for Bowtie controllers."
  type        = string
  default     = "t2.large"
}

variable "iam_instance_profile" {
  description = "IAM profile to attach to the instances."
  type        = string
  default     = null
}

variable "owner_id" {
  description = "The owner ID to be used for fetching the AMI."
  type        = list(string)
  default     = ["055761336000"]
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

# EIP Configuration
variable "create_eips" {
  description = "Whether to create elastic IP addresses instead of using existing ones."
  type        = bool
  default     = true
}

variable "eip_addresses" {
  description = "List of elastic IP addresses to assign to each instance if create_eips is false."
  type        = list(string)
  default     = []
}

variable "eip_domain" {
  description = "Domain for the elastic IP address (vpc or standard)."
  type        = string
  default     = "vpc"
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
  default     = "admin@bowtie.example.com"
}

variable "admin_password_hash" {
  description = "Hashed admin password for initialization."
  type        = string
  sensitive   = true
}

variable "ssh_key" {
  description = "SSH public key for root access."
  type        = string
  default     = "ssh-ed25519 AAAA example-key"
}

variable "sso_config" {
  description = "Optional SSO configuration."
  type        = string
  default     = ""
}

# DNS Configuration
variable "create_dns_records" {
  description = "Whether to create Route53 DNS records for the controllers."
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "The ID of the Route53 hosted zone where DNS records will be created."
  type        = string
  default     = ""
}

variable "dns_ttl" {
  description = "The TTL for the DNS records (in seconds)."
  type        = number
  default     = 300
}

variable "dns_propagation_wait" {
  description = "Time to wait (in seconds) for DNS records to propagate before creating instances"
  type        = number
  default     = 60
}

# Bowtie Configuration
variable "bowtie_username" {
  description = "The username for authenticating with the Bowtie cluster."
  type        = string
}

variable "bowtie_password" {
  description = "The password for authenticating with the Bowtie cluster."
  type        = string
  sensitive   = true
}

variable "ipv4_range" {
  description = "The IPv4 CIDR range to apply in the Bowtie site configuration."
  type        = string
}

variable "create_default_resources" {
  description = "Whether to create default resources like IPv4/IPv6 resources, resource groups, managed domain, and DNS blocklist."
  type        = bool
  default     = false
}
