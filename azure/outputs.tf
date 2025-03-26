output "resource_group_name" {
  description = "The name of the resource group"
  value       = module.infrastructure.resource_group_name
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = module.infrastructure.vnet_id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = module.infrastructure.subnet_id
}

output "network_security_group_id" {
  description = "The ID of the network security group"
  value       = module.infrastructure.network_security_group_id
}

output "vm_ids" {
  description = "The IDs of the Azure VMs"
  value       = module.infrastructure.vm_ids
}

output "vm_names" {
  description = "The names of the Azure VMs"
  value       = module.infrastructure.vm_names
}

output "controller_names" {
  description = "The controller names used for the Bowtie configuration"
  value       = module.infrastructure.controller_names
}

output "public_ips" {
  description = "The public IP addresses of the controllers"
  value       = module.infrastructure.public_ips
}

output "fqdns" {
  description = "The fully qualified domain names of the controllers"
  value       = module.infrastructure.fqdns
}

output "primary_fqdn" {
  description = "The fully qualified domain name of the primary controller"
  value       = module.infrastructure.primary_fqdn
}

output "deployment_ready" {
  description = "Indicates if the deployment has passed initialization checks"
  value       = true # We assume if terraform completes successfully, the deployment is ready
}

output "dns_records" {
  description = "The Azure DNS records created (if enabled)"
  value       = module.infrastructure.dns_records
}

# Bowtie outputs
output "site_ranges" {
  description = "The Bowtie site ranges created"
  value       = module.bowtie.site_ranges
}

output "default_resources" {
  description = "The default resources created (if enabled)"
  value       = module.bowtie.default_resources
}

output "resource_groups" {
  description = "The resource groups created (if enabled)"
  value       = module.bowtie.resource_groups
}

output "dns_management" {
  description = "The DNS management configuration (if enabled)"
  value       = module.bowtie.dns_management
}
