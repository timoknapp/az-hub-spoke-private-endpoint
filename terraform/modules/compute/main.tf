# Create a Ubuntu based VM in Spoke 1
resource "azurerm_virtual_machine" "vm_spoke1" {
    name                  = "vm-client-spoke-${var.spoke1_location}"
    resource_group_name   = var.resource_group_name
    location              = var.spoke1_location
    network_interface_ids = [azurerm_network_interface.nic_vm1.id]
    vm_size               = "Standard_DS1_v2"

    storage_image_reference {
        publisher = "canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts-gen2"
        version   = "latest"
    }

    storage_os_disk {
        name              = "disk-vm-client-spoke-${var.spoke1_location}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
        os_type           = "Linux"
    }

    os_profile {
        computer_name  = "vm-client-spoke-${var.spoke1_location}"
        admin_username = var.vm_username
        admin_password = var.vm_password
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }
}

# Create VM Extension CustomScript for VM 1
resource "azurerm_virtual_machine_extension" "vm_extension_vm1" {
    name                 = "install_mssql"
    virtual_machine_id   = azurerm_virtual_machine.vm_spoke1.id
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.1"

    protected_settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/timoknapp/az-hub-spoke-private-endpoint/master/util/install_mssql.sh"],
        "commandToExecute": "sh install_mssql.sh"
    }
    SETTINGS
}

# Create NIC for VM in Spoke 1
resource "azurerm_network_interface" "nic_vm1" {
    name                = "nic-vm-spoke-${var.spoke1_location}-001"
    location            = var.spoke1_location
    resource_group_name = var.resource_group_name

    ip_configuration {
        name                          = "ipconfig1"
        subnet_id                     = "${var.snet_id_spoke1}"
        private_ip_address_allocation = "Dynamic"
    }
}

# Create NSG for NIC in Spoke 1
resource "azurerm_network_security_group" "nsg_vm1" {
    name                = "nsg-nic-spoke-vm-${var.spoke1_location}"
    location            = var.spoke1_location
    resource_group_name = var.resource_group_name

    security_rule {
        access = "Allow"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "22"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowTagSSHInbound"
        priority = 100
        protocol = "TCP"
        source_address_prefix = "VirtualNetwork"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }
}

# Associate NSG to NIC 1
resource "azurerm_network_interface_security_group_association" "nsg-nic-vm1" {
    network_interface_id      = azurerm_network_interface.nic_vm1.id
    network_security_group_id = azurerm_network_security_group.nsg_vm1.id
}