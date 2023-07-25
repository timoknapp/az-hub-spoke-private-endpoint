resource "azurerm_virtual_machine_extension" "res-0" {
  auto_upgrade_minor_version = true
  name                       = "MDE.Linux"
  publisher                  = "Microsoft.Azure.AzureDefenderForServers"
  settings                   = "{\"autoUpdate\":true,\"azureResourceId\":\"/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/RG-HUB-SPOKE/providers/Microsoft.Compute/virtualMachines/client-vm-spoke-northeu\",\"forceReOnboarding\":false,\"vNextEnabled\":false}"
  type                       = "MDE.Linux"
  type_handler_version       = "1.0"
  virtual_machine_id         = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/RG-HUB-SPOKE/providers/Microsoft.Compute/virtualMachines/client-vm-spoke-northeu"
  depends_on = [
    azurerm_linux_virtual_machine.res-5,
  ]
}
resource "azurerm_virtual_machine_extension" "res-1" {
  auto_upgrade_minor_version = true
  name                       = "enablevmaccess"
  publisher                  = "Microsoft.OSTCExtensions"
  type                       = "VMAccessForLinux"
  type_handler_version       = "1.4"
  virtual_machine_id         = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/RG-HUB-SPOKE/providers/Microsoft.Compute/virtualMachines/client-vm-spoke-northeu"
  depends_on = [
    azurerm_linux_virtual_machine.res-5,
  ]
}
resource "azurerm_virtual_machine_extension" "res-2" {
  auto_upgrade_minor_version = true
  name                       = "MDE.Linux"
  publisher                  = "Microsoft.Azure.AzureDefenderForServers"
  settings                   = "{\"autoUpdate\":true,\"azureResourceId\":\"/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/RG-HUB-SPOKE/providers/Microsoft.Compute/virtualMachines/client-vm-westeu\",\"forceReOnboarding\":false,\"vNextEnabled\":false}"
  type                       = "MDE.Linux"
  type_handler_version       = "1.0"
  virtual_machine_id         = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/RG-HUB-SPOKE/providers/Microsoft.Compute/virtualMachines/client-vm-westeu"
  depends_on = [
    azurerm_linux_virtual_machine.res-6,
  ]
}
resource "azurerm_virtual_machine_extension" "res-3" {
  auto_upgrade_minor_version = true
  name                       = "OmsAgentForLinux"
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  settings                   = "{\"workspaceId\":\"0e1bb826-3302-4440-99c9-d055c3e8b1cc\"}"
  type                       = "OmsAgentForLinux"
  type_handler_version       = "1.0"
  virtual_machine_id         = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/RG-HUB-SPOKE/providers/Microsoft.Compute/virtualMachines/client-vm-westeu"
  depends_on = [
    azurerm_linux_virtual_machine.res-6,
  ]
}
resource "azurerm_resource_group" "res-4" {
  location = "westeurope"
  name     = "rg-hub-spoke"
}

variable vmPassword {
  type = string
  default = "P@ssw0rd1234"  
}

resource "azurerm_linux_virtual_machine" "res-5" {
  admin_password                  = var.vmPassword
  admin_username                  = "azureuser"
  disable_password_authentication = false
  location                        = "northeurope"
  name                            = "client-vm-spoke-northeu"
  network_interface_ids           = ["/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/networkInterfaces/client-vm-spoke-northeu33_z1"]
  resource_group_name             = "rg-hub-spoke"
  size                            = "Standard_B1ls"
  zone                            = "1"
  boot_diagnostics {
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.res-9,
  ]
}
resource "azurerm_linux_virtual_machine" "res-6" {
  admin_password                  = var.vmPassword
  admin_username                  = "azureuser"
  disable_password_authentication = false
  location                        = "westeurope"
  name                            = "client-vm-westeu"
  network_interface_ids           = ["/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/networkInterfaces/client-vm-westeu116_z1"]
  resource_group_name             = "rg-hub-spoke"
  size                            = "Standard_B1ls"
  zone                            = "1"
  boot_diagnostics {
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.res-11,
  ]
}
resource "azurerm_virtual_machine_extension" "res-7" {
  auto_upgrade_minor_version = true
  name                       = "enablevmaccess"
  publisher                  = "Microsoft.OSTCExtensions"
  type                       = "VMAccessForLinux"
  type_handler_version       = "1.4"
  virtual_machine_id         = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Compute/virtualMachines/client-vm-westeu"
  depends_on = [
    azurerm_linux_virtual_machine.res-6,
  ]
}
resource "azurerm_bastion_host" "res-8" {
  location            = "westeurope"
  name                = "bst-hub"
  resource_group_name = "rg-hub-spoke"
  sku                 = "Standard"
  ip_configuration {
    name                 = "IpConf"
    public_ip_address_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/publicIPAddresses/vnet-hub-001-ip"
    subnet_id            = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-hub-001/subnets/AzureBastionSubnet"
  }
  depends_on = [
    azurerm_public_ip.res-43,
    # One of azurerm_subnet.res-45,azurerm_subnet_network_security_group_association.res-46 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_network_interface" "res-9" {
  location            = "northeurope"
  name                = "client-vm-spoke-northeu33_z1"
  resource_group_name = "rg-hub-spoke"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-spoke-northeu-001/subnets/snet-vm"
  }
  depends_on = [
    # One of azurerm_subnet.res-52,azurerm_subnet_network_security_group_association.res-53 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_network_interface_security_group_association" "res-10" {
  network_interface_id      = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/networkInterfaces/client-vm-spoke-northeu33_z1"
  network_security_group_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/networkSecurityGroups/client-vm-spoke-northeu-nsg"
  depends_on = [
    azurerm_network_interface.res-9,
    azurerm_network_security_group.res-14,
  ]
}
resource "azurerm_network_interface" "res-11" {
  location            = "westeurope"
  name                = "client-vm-westeu116_z1"
  resource_group_name = "rg-hub-spoke"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-spoke-westeu-001/subnets/snet-vm"
  }
  depends_on = [
    # One of azurerm_subnet.res-56,azurerm_subnet_network_security_group_association.res-57 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_network_interface_security_group_association" "res-12" {
  network_interface_id      = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/networkInterfaces/client-vm-westeu116_z1"
  network_security_group_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/networkSecurityGroups/client-vm-westeu-nsg"
  depends_on = [
    azurerm_network_interface.res-11,
    azurerm_network_security_group.res-16,
  ]
}
resource "azurerm_network_interface" "res-13" {
  location            = "westeurope"
  name                = "pe-sql-nic"
  resource_group_name = "rg-hub-spoke"
  ip_configuration {
    name                          = "privateEndpointIpConfig.fa803a40-8fbd-4673-9f43-b84aea118ddd"
    private_ip_address_allocation = "Static"
    subnet_id                     = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-hub-001/subnets/snet-hub"
  }
  depends_on = [
    # One of azurerm_subnet.res-47,azurerm_subnet_network_security_group_association.res-48 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_network_security_group" "res-14" {
  location            = "northeurope"
  name                = "client-vm-spoke-northeu-nsg"
  resource_group_name = "rg-hub-spoke"
  depends_on = [
    azurerm_resource_group.res-4,
  ]
}
resource "azurerm_network_security_rule" "res-15" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "AllowTagSSHInbound"
  network_security_group_name = "client-vm-spoke-northeu-nsg"
  priority                    = 100
  protocol                    = "Tcp"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-14,
  ]
}
resource "azurerm_network_security_group" "res-16" {
  location            = "westeurope"
  name                = "client-vm-westeu-nsg"
  resource_group_name = "rg-hub-spoke"
  depends_on = [
    azurerm_resource_group.res-4,
  ]
}
resource "azurerm_network_security_rule" "res-17" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "AllowTagSSHInbound"
  network_security_group_name = "client-vm-westeu-nsg"
  priority                    = 100
  protocol                    = "Tcp"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-16,
  ]
}
resource "azurerm_network_security_group" "res-18" {
  location            = "westeurope"
  name                = "vnet-hub-001-AzureBastionSubnet-nsg-westeurope"
  resource_group_name = "rg-hub-spoke"
  depends_on = [
    azurerm_resource_group.res-4,
  ]
}
resource "azurerm_network_security_rule" "res-19" {
  access                      = "Allow"
  destination_address_prefix  = "AzureCloud"
  destination_port_range      = "443"
  direction                   = "Outbound"
  name                        = "AllowAzureCloudOutbound"
  network_security_group_name = "vnet-hub-001-AzureBastionSubnet-nsg-westeurope"
  priority                    = 110
  protocol                    = "Tcp"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-18,
  ]
}
resource "azurerm_network_security_rule" "res-20" {
  access                      = "Allow"
  description                 = "CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "AllowCorpnet"
  network_security_group_name = "vnet-hub-001-AzureBastionSubnet-nsg-westeurope"
  priority                    = 2700
  protocol                    = "*"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "CorpNetPublic"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-18,
  ]
}
resource "azurerm_network_security_rule" "res-21" {
  access                      = "Allow"
  description                 = "Allow GatewayManager"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  direction                   = "Inbound"
  name                        = "AllowGatewayManager"
  network_security_group_name = "vnet-hub-001-AzureBastionSubnet-nsg-westeurope"
  priority                    = 2702
  protocol                    = "*"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "GatewayManager"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-18,
  ]
}
resource "azurerm_network_security_rule" "res-22" {
  access                      = "Allow"
  description                 = "Allow HTTPs"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  direction                   = "Inbound"
  name                        = "AllowHttpsInBound"
  network_security_group_name = "vnet-hub-001-AzureBastionSubnet-nsg-westeurope"
  priority                    = 2703
  protocol                    = "*"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "Internet"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-18,
  ]
}
resource "azurerm_network_security_rule" "res-23" {
  access                      = "Allow"
  description                 = "CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "AllowSAW"
  network_security_group_name = "vnet-hub-001-AzureBastionSubnet-nsg-westeurope"
  priority                    = 2701
  protocol                    = "*"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "CorpNetSaw"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-18,
  ]
}
resource "azurerm_network_security_rule" "res-24" {
  access                      = "Allow"
  destination_address_prefix  = "VirtualNetwork"
  destination_port_ranges     = ["22", "3389"]
  direction                   = "Outbound"
  name                        = "AllowSshRdpOutbound"
  network_security_group_name = "vnet-hub-001-AzureBastionSubnet-nsg-westeurope"
  priority                    = 100
  protocol                    = "*"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-18,
  ]
}
resource "azurerm_network_security_group" "res-25" {
  location            = "westeurope"
  name                = "vnet-hub-001-snet-hub-nsg-westeurope"
  resource_group_name = "rg-hub-spoke"
  depends_on = [
    azurerm_resource_group.res-4,
  ]
}
resource "azurerm_network_security_rule" "res-26" {
  access                      = "Allow"
  description                 = "CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "AllowCorpnet"
  network_security_group_name = "vnet-hub-001-snet-hub-nsg-westeurope"
  priority                    = 2700
  protocol                    = "*"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "CorpNetPublic"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-25,
  ]
}
resource "azurerm_network_security_rule" "res-27" {
  access                      = "Allow"
  description                 = "CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "AllowSAW"
  network_security_group_name = "vnet-hub-001-snet-hub-nsg-westeurope"
  priority                    = 2701
  protocol                    = "*"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "CorpNetSaw"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-25,
  ]
}
resource "azurerm_network_security_group" "res-28" {
  location            = "northeurope"
  name                = "vnet-spoke-northeu-001-snet-vm-nsg-northeurope"
  resource_group_name = "rg-hub-spoke"
  depends_on = [
    azurerm_resource_group.res-4,
  ]
}
resource "azurerm_network_security_rule" "res-29" {
  access                      = "Allow"
  description                 = "CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "AllowCorpnet"
  network_security_group_name = "vnet-spoke-northeu-001-snet-vm-nsg-northeurope"
  priority                    = 2700
  protocol                    = "*"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "CorpNetPublic"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-28,
  ]
}
resource "azurerm_network_security_rule" "res-30" {
  access                      = "Allow"
  description                 = "CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "AllowSAW"
  network_security_group_name = "vnet-spoke-northeu-001-snet-vm-nsg-northeurope"
  priority                    = 2701
  protocol                    = "*"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "CorpNetSaw"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-28,
  ]
}
resource "azurerm_network_security_rule" "res-31" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "AllowTagSSHInbound"
  network_security_group_name = "vnet-spoke-northeu-001-snet-vm-nsg-northeurope"
  priority                    = 2711
  protocol                    = "Tcp"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-28,
  ]
}
resource "azurerm_network_security_group" "res-32" {
  location            = "westeurope"
  name                = "vnet-spoke-westeu-001-snet-vm-nsg-westeurope"
  resource_group_name = "rg-hub-spoke"
  depends_on = [
    azurerm_resource_group.res-4,
  ]
}
resource "azurerm_network_security_rule" "res-33" {
  access                      = "Allow"
  description                 = "CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "AllowCorpnet"
  network_security_group_name = "vnet-spoke-westeu-001-snet-vm-nsg-westeurope"
  priority                    = 2700
  protocol                    = "*"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "CorpNetPublic"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-32,
  ]
}
resource "azurerm_network_security_rule" "res-34" {
  access                      = "Allow"
  description                 = "CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "AllowSAW"
  network_security_group_name = "vnet-spoke-westeu-001-snet-vm-nsg-westeurope"
  priority                    = 2701
  protocol                    = "*"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "CorpNetSaw"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-32,
  ]
}
resource "azurerm_network_security_rule" "res-35" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "AllowTagSSHInbound"
  network_security_group_name = "vnet-spoke-westeu-001-snet-vm-nsg-westeurope"
  priority                    = 2711
  protocol                    = "Tcp"
  resource_group_name         = "rg-hub-spoke"
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-32,
  ]
}
resource "azurerm_private_dns_zone" "res-36" {
  name                = "privatelink.database.windows.net"
  resource_group_name = "rg-hub-spoke"
  depends_on = [
    azurerm_resource_group.res-4,
  ]
}
resource "azurerm_private_dns_a_record" "res-37" {
  name                = "azsqltk"
  records             = ["10.5.0.5"]
  resource_group_name = "rg-hub-spoke"
  tags = {
    creator = "created by private endpoint pe-sql with resource guid 37e57078-4e55-463b-b6b4-0ec692fd5f3e"
  }
  ttl       = 10
  zone_name = "privatelink.database.windows.net"
  depends_on = [
    azurerm_private_dns_zone.res-36,
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-39" {
  name                  = "spoke-northeu"
  private_dns_zone_name = "privatelink.database.windows.net"
  registration_enabled  = true
  resource_group_name   = "rg-hub-spoke"
  virtual_network_id    = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-spoke-northeu-001"
  depends_on = [
    azurerm_private_dns_zone.res-36,
    azurerm_virtual_network.res-51,
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-40" {
  name                  = "spoke-westeu"
  private_dns_zone_name = "privatelink.database.windows.net"
  registration_enabled  = true
  resource_group_name   = "rg-hub-spoke"
  virtual_network_id    = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-spoke-westeu-001"
  depends_on = [
    azurerm_private_dns_zone.res-36,
    azurerm_virtual_network.res-55,
  ]
}
resource "azurerm_private_endpoint" "res-41" {
  custom_network_interface_name = "pe-sql-nic"
  location                      = "westeurope"
  name                          = "pe-sql"
  resource_group_name           = "rg-hub-spoke"
  subnet_id                     = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-hub-001/subnets/snet-hub"
  ip_configuration {
    name               = "pe-sql"
    private_ip_address = "10.5.0.5"
    subresource_name   = "sqlServer"
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/privateDnsZones/privatelink.database.windows.net"]
  }
  private_service_connection {
    is_manual_connection           = false
    name                           = "pe-sql"
    private_connection_resource_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Sql/servers/azsqltk"
    subresource_names              = ["sqlServer"]
  }
  depends_on = [
    azurerm_private_dns_zone.res-36,
    azurerm_mssql_server.res-59,
    # One of azurerm_subnet.res-47,azurerm_subnet_network_security_group_association.res-48 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_public_ip" "res-43" {
  allocation_method   = "Static"
  location            = "westeurope"
  name                = "vnet-hub-001-ip"
  resource_group_name = "rg-hub-spoke"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.res-4,
  ]
}
resource "azurerm_virtual_network" "res-44" {
  address_space       = ["10.5.0.0/24"]
  location            = "westeurope"
  name                = "vnet-hub-001"
  resource_group_name = "rg-hub-spoke"
  depends_on = [
    azurerm_resource_group.res-4,
  ]
}
resource "azurerm_subnet" "res-45" {
  address_prefixes     = ["10.5.0.128/26"]
  name                 = "AzureBastionSubnet"
  resource_group_name  = "rg-hub-spoke"
  virtual_network_name = "vnet-hub-001"
  depends_on = [
    azurerm_virtual_network.res-44,
  ]
}
resource "azurerm_subnet_network_security_group_association" "res-46" {
  network_security_group_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/networkSecurityGroups/vnet-hub-001-AzureBastionSubnet-nsg-westeurope"
  subnet_id                 = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-hub-001/subnets/AzureBastionSubnet"
  depends_on = [
    azurerm_network_security_group.res-18,
    azurerm_subnet.res-45,
  ]
}
resource "azurerm_subnet" "res-47" {
  address_prefixes     = ["10.5.0.0/25"]
  name                 = "snet-hub"
  resource_group_name  = "rg-hub-spoke"
  service_endpoints    = ["Microsoft.Sql"]
  virtual_network_name = "vnet-hub-001"
  depends_on = [
    azurerm_virtual_network.res-44,
  ]
}
resource "azurerm_subnet_network_security_group_association" "res-48" {
  network_security_group_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/networkSecurityGroups/vnet-hub-001-snet-hub-nsg-westeurope"
  subnet_id                 = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-hub-001/subnets/snet-hub"
  depends_on = [
    azurerm_network_security_group.res-25,
    azurerm_subnet.res-47,
  ]
}
resource "azurerm_virtual_network_peering" "res-49" {
  name                      = "spoke-northeu"
  remote_virtual_network_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-spoke-northeu-001"
  resource_group_name       = "rg-hub-spoke"
  virtual_network_name      = "vnet-hub-001"
  depends_on = [
    azurerm_virtual_network.res-44,
    azurerm_virtual_network.res-51,
  ]
}
resource "azurerm_virtual_network_peering" "res-50" {
  name                      = "spoke-westeu"
  remote_virtual_network_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-spoke-westeu-001"
  resource_group_name       = "rg-hub-spoke"
  virtual_network_name      = "vnet-hub-001"
  depends_on = [
    azurerm_virtual_network.res-44,
    azurerm_virtual_network.res-55,
  ]
}
resource "azurerm_virtual_network" "res-51" {
  address_space       = ["10.10.0.0/24"]
  location            = "northeurope"
  name                = "vnet-spoke-northeu-001"
  resource_group_name = "rg-hub-spoke"
  depends_on = [
    azurerm_resource_group.res-4,
  ]
}
resource "azurerm_subnet" "res-52" {
  address_prefixes     = ["10.10.0.0/25"]
  name                 = "snet-vm"
  resource_group_name  = "rg-hub-spoke"
  virtual_network_name = "vnet-spoke-northeu-001"
  depends_on = [
    azurerm_virtual_network.res-51,
  ]
}
resource "azurerm_subnet_network_security_group_association" "res-53" {
  network_security_group_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/networkSecurityGroups/vnet-spoke-northeu-001-snet-vm-nsg-northeurope"
  subnet_id                 = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-spoke-northeu-001/subnets/snet-vm"
  depends_on = [
    azurerm_network_security_group.res-28,
    azurerm_subnet.res-52,
  ]
}
resource "azurerm_virtual_network_peering" "res-54" {
  name                      = "hub"
  remote_virtual_network_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-hub-001"
  resource_group_name       = "rg-hub-spoke"
  virtual_network_name      = "vnet-spoke-northeu-001"
  depends_on = [
    azurerm_virtual_network.res-44,
    azurerm_virtual_network.res-51,
  ]
}
resource "azurerm_virtual_network" "res-55" {
  address_space       = ["10.20.0.0/24"]
  location            = "westeurope"
  name                = "vnet-spoke-westeu-001"
  resource_group_name = "rg-hub-spoke"
  depends_on = [
    azurerm_resource_group.res-4,
  ]
}
resource "azurerm_subnet" "res-56" {
  address_prefixes     = ["10.20.0.0/25"]
  name                 = "snet-vm"
  resource_group_name  = "rg-hub-spoke"
  virtual_network_name = "vnet-spoke-westeu-001"
  depends_on = [
    azurerm_virtual_network.res-55,
  ]
}
resource "azurerm_subnet_network_security_group_association" "res-57" {
  network_security_group_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/networkSecurityGroups/vnet-spoke-westeu-001-snet-vm-nsg-westeurope"
  subnet_id                 = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-spoke-westeu-001/subnets/snet-vm"
  depends_on = [
    azurerm_network_security_group.res-32,
    azurerm_subnet.res-56,
  ]
}
resource "azurerm_virtual_network_peering" "res-58" {
  name                      = "hub"
  remote_virtual_network_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-hub-001"
  resource_group_name       = "rg-hub-spoke"
  virtual_network_name      = "vnet-spoke-westeu-001"
  depends_on = [
    azurerm_virtual_network.res-44,
    azurerm_virtual_network.res-55,
  ]
}
resource "azurerm_mssql_server" "res-59" {
  administrator_login           = "sqluser"
  administrator_login_password = var.vmPassword
  location                      = "westeurope"
  name                          = "azsqltk"
  public_network_access_enabled = false
  resource_group_name           = "rg-hub-spoke"
  version                       = "12.0"
  azuread_administrator {
    login_username = "timo.knapp_microsoft.com#EXT#@fdpo.onmicrosoft.com"
    object_id      = "91bf285c-b3de-4482-873d-a57edafb15e9"
  }
  depends_on = [
    azurerm_resource_group.res-4,
  ]
}
resource "azurerm_sql_active_directory_administrator" "res-60" {
  login               = "timo.knapp_microsoft.com#EXT#@fdpo.onmicrosoft.com"
  object_id           = "91bf285c-b3de-4482-873d-a57edafb15e9"
  resource_group_name = "rg-hub-spoke"
  server_name         = "azsqltk"
  tenant_id           = "16b3c013-d300-468d-ac64-7eda0820b6d3"
  depends_on = [
    azurerm_mssql_server.res-59,
  ]
}
resource "azurerm_mssql_database" "res-71" {
  name                 = "db"
  server_id            = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Sql/servers/azsqltk"
  storage_account_type = "Local"
  depends_on = [
    azurerm_mssql_server.res-59,
  ]
}
resource "azurerm_mssql_database_extended_auditing_policy" "res-82" {
  database_id            = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Sql/servers/azsqltk/databases/db"
  enabled                = false
  log_monitoring_enabled = false
  depends_on = [
    azurerm_mssql_database.res-71,
  ]
}
resource "azurerm_mssql_database_extended_auditing_policy" "res-91" {
  database_id            = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Sql/servers/azsqltk/databases/master"
  enabled                = false
  log_monitoring_enabled = false
}
resource "azurerm_mssql_server_microsoft_support_auditing_policy" "res-97" {
  enabled                = false
  log_monitoring_enabled = false
  server_id              = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Sql/servers/azsqltk"
  depends_on = [
    azurerm_mssql_server.res-59,
  ]
}
resource "azurerm_mssql_server_transparent_data_encryption" "res-98" {
  server_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Sql/servers/azsqltk"
  depends_on = [
    azurerm_mssql_server.res-59,
  ]
}
resource "azurerm_mssql_server_extended_auditing_policy" "res-99" {
  log_monitoring_enabled          = false
  retention_in_days               = 60
  server_id                       = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Sql/servers/azsqltk"
  storage_account_subscription_id = "6b76ff87-a921-49fe-a04a-92aebd1ac6fa"
  storage_endpoint                = "https://mcapsgovcsqlauditstorage.blob.core.windows.net/"
  depends_on = [
    azurerm_mssql_server.res-59,
  ]
}
resource "azurerm_mssql_server_security_alert_policy" "res-102" {
  resource_group_name = "rg-hub-spoke"
  server_name         = "azsqltk"
  state               = "Enabled"
  depends_on = [
    azurerm_mssql_server.res-59,
  ]
}
resource "azurerm_mssql_virtual_network_rule" "res-104" {
  name      = "vnet-hub-rule"
  server_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Sql/servers/azsqltk"
  subnet_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Network/virtualNetworks/vnet-hub-001/subnets/snet-hub"
  depends_on = [
    azurerm_mssql_server.res-59,
    # One of azurerm_subnet.res-47,azurerm_subnet_network_security_group_association.res-48 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_mssql_server_vulnerability_assessment" "res-105" {
  server_security_alert_policy_id = "/subscriptions/08af9d7a-c4a4-4858-827f-2a27ef8b6245/resourceGroups/rg-hub-spoke/providers/Microsoft.Sql/servers/azsqltk/securityAlertPolicies/Default"
  storage_container_path          = ""
  depends_on = [
    azurerm_mssql_server_security_alert_policy.res-102,
  ]
}
