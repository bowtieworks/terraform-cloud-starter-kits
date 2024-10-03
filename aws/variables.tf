variable "region" {
  description = "The AWS region the resources will be created within."
  type        = string
  default     = ""
}

variable "create_vpc" {
  description = "Whether to create a new VPC. If false, an existing VPC with the name provided will be used."
  type        = bool
  default     = false
}

variable "create_subnets" {
  description = "Whether to create new subnets. If false, existing subnets with the names provided will be used."
  type        = bool
  default     = false
}

variable "vpc_name" {
  description = "The name of the VPC to create or use."
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The ID of a pre-existing VPC to use."
  type        = string
  default     = ""
}

variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = ""
}

variable "subnet_names" {
  description = "List of subnet names to create."
  type        = list(string)
  default     = [""]
}

variable "subnet_id" {
  description = "The ID of a pre-existing subnet to use."
  type        = string
  default     = ""
}

variable "subnet_cidrs" {
  description = "The address prefixes to use for each subnet."
  type        = list(string)
  default     = [""]
}

variable "subnet_azs" {
  description = "List of availability zones for each subnet; these should match the order of the subnet names."
  type        = list(string)
  default     = [""]
}

variable "instance_type" {
  description = "Instance type to use for the instance."
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM profile to attach to the instance"
  type        = string
  default     = null
}

variable "dns_zone_name" {
  description = "The DNS name to be used as the root for the controller hostnames."
  type        = string
}

variable "controller_name" {
  description = "List of unique name identifiers to be prefixed on the dns_zone_name."
  type        = list(string)
}

variable "eip_addresses" {
  description = "List of elastic IP addresses to assign to each instace."
  type        = list(string)
}

variable "owner_id" {
  description = "The ID of the owner of the AMI to be used"
  type        = list(string)
  default     = ["055761336000"]
}

variable "join_existing_cluster" {
  description = "Flag to indicate if the deployment is to join an existing cluster"
  type        = bool
  default     = false
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

variable "site_id" {
  description = "The SITE_ID that the controllers are to be instantiated within."
  type        = string
}
