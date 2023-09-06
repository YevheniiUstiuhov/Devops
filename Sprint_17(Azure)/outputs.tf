output "resource_group_name" {
  value = azurerm_resource_group.azure.name
}

output "azure_vm_name" {
  value = azurerm_linux_virtual_machine.azure-vm.name
}

output "azure_vm_location" {
  value = azurerm_linux_virtual_machine.azure-vm.location
}

output "vm_size" {
  value = azurerm_linux_virtual_machine.azure-vm.size
}

output "azure_os_disk_name" {
  value = azurerm_linux_virtual_machine.azure-vm.os_disk[0].name
}

output "public_ip_address" {
  value = azurerm_public_ip.azure-pip.ip_address
}







