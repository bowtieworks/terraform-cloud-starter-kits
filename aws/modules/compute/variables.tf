variable "instance_type" {
  description = "Instance type to use for the instance."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "The VPC security group ID to associate with each instance."
  type        = list(string)
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

variable "eip_addresses" {
  description = "List of elastic IP addresses to pull from to assign to each instace."
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

variable "join_controller_hostname" {
  description = "Hostname of a controller to join these controllers with"
  type        = string
  default     = ""
}