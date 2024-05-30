variable "resource_group_name" {
  description = "The Name which should be used for this Resource Group."
  type        = string
}

variable "resource_group_location" {
  description = "The Azure Region where the Resource Group should exist."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs."
  type        = list(string)
}
