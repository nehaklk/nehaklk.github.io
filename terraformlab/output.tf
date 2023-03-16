output "public_addresses"{
    value = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "private_ip"{
    description = "Private ip"
    value = azurerm_network_interface.nic.private_ip_address
}

output "rg_ip"{
    value = azurerm_public_ip.public_ip.ip_address
}