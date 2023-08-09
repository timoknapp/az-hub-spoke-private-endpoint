output "snet_id_spoke1" {
    value = data.azurerm_subnet.snet-spoke1.id
    description = "Resource ID of Subnet spoke 1."
}

output "snet_id_spoke2" {
    value = data.azurerm_subnet.snet-spoke2.id
    description = "Resource ID of Subnet spoke 2."
}