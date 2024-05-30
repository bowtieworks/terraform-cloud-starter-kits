output "instance_names" {
  value = [for vm in azurerm_linux_virtual_machine.virtual_machine : vm.name]
}
