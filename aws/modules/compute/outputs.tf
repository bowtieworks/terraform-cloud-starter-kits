output "instance_names" {
  value = [for ec2 in aws_instance.instance : ec2.tags["Name"]]
}
