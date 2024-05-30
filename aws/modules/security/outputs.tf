output "security_group_ids" {
  value = [data.aws_security_group.sg_data.id]
}