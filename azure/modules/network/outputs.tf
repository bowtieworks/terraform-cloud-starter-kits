output "subnet_ids" {
  value = [for s in azurerm_subnet.subnets : s.id]
}
