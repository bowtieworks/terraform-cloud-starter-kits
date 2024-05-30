variable "create_vpc" {
  description = "Whether to create a new VPC. If false, an existing VPC with the name provided will be used."
  type        = bool
}

variable "create_subnets" {
  description = "Whether to create new subnets. If false, existing subnets with the names provided will be used."
  type        = bool
}

variable "vpc_name" {
  description = "The name attribute of the tag associated with the VPC."
  type        = string
}

variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
}

variable "subnet_names" {
  description = "List of subnet names to create or use. Specify the name for existing subnets or new ones."
  type        = list(string)
}

variable "subnet_cidrs" {
  description = "List of IPv4 CIDR blocks to be associated with the listed subnets."
  type        = list(string)
}

variable "subnet_azs" {
  description = "The availability zones associated with the subnets to be used."
  type        = list(string)
}
