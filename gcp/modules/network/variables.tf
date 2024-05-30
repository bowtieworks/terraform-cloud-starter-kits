variable "vpc_name" {
  description = "The name of the VPC to create or use."
  type        = string
}

variable "create_vpc" {
  description = "Whether to create a new VPC. If false, an existing VPC with the name provided will be used."
  type        = bool
}

variable "subnet_names" {
  description = "List of subnet names to create or use. Specify the name for existing subnets or new ones."
  type        = list(string)
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for the new subnets. Must be specified if creating new subnets."
  type        = list(string)
}

variable "create_subnets" {
  description = "Whether to create new subnets. If false, existing subnets with the names provided will be used."
  type        = bool
}

variable "subnet_regions" {
  description = "List of regions for each subnet; these should match the order of subnet names."
  type        = list(string)
}
