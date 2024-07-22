locals {
  vpc_id = var.create_vpc ? aws_vpc.vpc[0].id : data.aws_vpc.existing_vpc[0].id
}

output "vpc_id" {
  value = local.vpc_id
}

output "subnet_ids" {
  value = var.create_subnets ? [for subnet in aws_subnet.subnets : subnet.id] : (var.subnet_id != "" ? [data.aws_subnet.existing_subnet[0].id] : [for subnet in data.aws_subnet.default_subnets : subnet.id])
}