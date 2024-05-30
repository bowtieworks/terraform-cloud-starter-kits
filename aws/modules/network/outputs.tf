locals {
  vpc_id = var.create_vpc ? aws_vpc.vpc[0].id : tolist(data.aws_vpc.vpc_data.*.id)[0]
}

output "vpc_id" {
  value = local.vpc_id
}

output "subnet_ids" {
  value = var.create_subnets ? [for subnet in aws_subnet.subnets : subnet.id] : [for subnet in data.aws_subnet.subnets_data : subnet.id]
}