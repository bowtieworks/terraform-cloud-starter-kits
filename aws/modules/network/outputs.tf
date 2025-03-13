locals {
  vpc_id = var.create_vpc ? (length(aws_vpc.vpc) > 0 ? aws_vpc.vpc[0].id : "") : var.vpc_id
  
  subnet_ids = var.create_subnets ? [for subnet in aws_subnet.subnets : subnet.id] : (
    var.subnet_id != "" ? [var.subnet_id] : []
  )
}

output "vpc_id" {
  value = local.vpc_id
}

output "subnet_ids" {
  value = local.subnet_ids
}
