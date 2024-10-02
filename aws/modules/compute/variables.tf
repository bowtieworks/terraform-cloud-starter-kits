variable "instance_type" {
  description = "Instance type to use for the instance."
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM profile to attach to the instance"
  type = string
  default = null
}

variable "vpc_security_group_ids" {
  description = "The VPC security group ID to associate with each instance."
  type        = list(string)
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

variable "cloud_init_first_instance" {
  description = "cloud-init to be used when deploying a new cluster"
  type        = string
  default     = "cloud-init-first-instance.yaml"
}

variable "cloud_init_join_cluster" {
  description = "cloud-init to be used when joining an existing cluster"
  type        = string
  default     = "cloud-init-join-cluster.yaml"
}
