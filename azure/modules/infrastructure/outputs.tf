output "resource_group_name" {
  description = "The name of the resource group"
  value       = local.resource_group_name
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = local.vnet_id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = local.subnet_id
}

output "network_security_group_id" {
  description = "The ID of the network security group"
  value       = local.nsg_id
}

output "vm_ids" {
  description = "The IDs of the Azure VMs"
  value       = [for vm in azurerm_linux_virtual_machine.vm : vm.id]
}

output "vm_names" {
  description = "The names of the Azure VMs"
  value       = [for vm in azurerm_linux_virtual_machine.vm : vm.name]
}

output "controller_names" {
  description = "The controller names used for the Bowtie configuration"
  value       = local.generated_controller_names
}

output "public_ips" {
  description = "The public IP addresses of the controllers"
  value       = var.create_public_ips ? [for pip in azurerm_public_ip.public_ip : pip.ip_address] : var.public_ip_addresses
}

output "fqdns" {
  description = "The fully qualified domain names of the controllers"
  value       = [for name in local.generated_controller_names : "${name}.${var.dns_zone_name}"]
}

output "primary_fqdn" {
  description = "The fully qualified domain name of the primary controller"
  value       = "${local.generated_controller_names[0]}.${var.dns_zone_name}"
}

output "dns_records" {
  description = "The Azure DNS records created (if enabled)"
  value       = var.create_dns_records && var.dns_zone_resource_group != "" ? [for record in azurerm_dns_a_record.dns_record : record.fqdn] : []
}

output "module_ready" {
  description = "Indicates if the infrastructure module is ready (including health check)"
  value       = "ready"
  depends_on  = [null_resource.health_check, time_sleep.wait_for_bowtie_startup]
}
