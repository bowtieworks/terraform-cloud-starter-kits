output "vpc_id" {
  description = "The ID of the VPC"
  value       = var.create_vpc ? aws_vpc.vpc[0].id : var.vpc_id
}

output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = var.create_subnets ? [for subnet in aws_subnet.subnets : subnet.id] : [var.subnet_id]
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = data.aws_security_group.sg_data.id
}

output "instance_ids" {
  description = "The IDs of the EC2 instances"
  value       = [for instance in aws_instance.instance : instance.id]
}

output "instance_names" {
  description = "The names of the EC2 instances"
  value       = [for instance in aws_instance.instance : instance.tags["Name"]]
}

output "controller_names" {
  description = "The controller names used for the Bowtie configuration"
  value       = local.generated_controller_names
}

output "public_ips" {
  description = "The public IP addresses of the controllers"
  value       = var.create_eips ? [for eip in aws_eip.controller_eips : eip.public_ip] : var.eip_addresses
}

output "fqdns" {
  description = "The fully qualified domain names of the controllers"
  value       = [for name in local.generated_controller_names : "${name}.${var.dns_zone_name}"]
}

output "primary_fqdn" {
  description = "The fully qualified domain name of the primary controller"
  value       = "${local.generated_controller_names[0]}.${var.dns_zone_name}"
}

output "healthcheck_id" {
  description = "The ID of the health check"
  value       = checkmate_http_health.healthcheck.id
}

output "deployment_ready" {
  description = "Indicates if the deployment has passed initialization checks"
  value       = true # We assume if terraform completes successfully, the deployment is ready
}

output "dns_records" {
  description = "The Route53 DNS records created (if enabled)"
  value       = var.create_dns_records && var.route53_zone_id != "" ? [for record in aws_route53_record.controller_records : record.fqdn] : []
}
