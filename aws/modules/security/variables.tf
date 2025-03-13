variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "security_group_id" {
  description = "ID of an existing security group to use instead of creating a new one"
  type        = string
  default     = ""
}

variable "create_security_group" {
  description = "Whether to create a new security group or use an existing one"
  type        = bool
  default     = false
}
