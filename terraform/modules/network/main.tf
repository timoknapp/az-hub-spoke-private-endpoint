# Create virtual networks and subnets
resource "azurerm_virtual_network" "hub" {
    address_space = ["10.5.0.0/24"]
    location = var.hub_location
    name = "vnet-hub-${var.hub_location}-001"
    resource_group_name = var.resource_group_name
    subnet {
        address_prefix = "10.5.0.0/25"
        # id = "snet-hub"
        name = "snet-hub"
        # service_endpoints = ["Microsoft.Sql"]
        security_group = "${azurerm_network_security_group.nsg-hub-default.id}"
    }

    subnet {
        address_prefix = "10.5.0.128/26"
        # id = "snet-bastion"
        name = "AzureBastionSubnet"
        security_group = "${azurerm_network_security_group.nsg-hub-bastion.id}"
    }
}

data "azurerm_subnet" "snet-hub" {
    name = "snet-hub"
    virtual_network_name = azurerm_virtual_network.hub.name
    resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "snet-bastion" {
    name = "AzureBastionSubnet"
    virtual_network_name = azurerm_virtual_network.hub.name
    resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "spoke1" {
    address_space = ["10.20.0.0/24"]
    location = var.spoke1_location
    name = "vnet-spoke-${var.spoke1_location}-001"
    resource_group_name = var.resource_group_name
    subnet {
        address_prefix = "10.20.0.0/25"
        # id = "snet-spoke1"
        name = "snet-vm"
        security_group = "${azurerm_network_security_group.nsg-snet-spoke1.id}"
    }
}

data "azurerm_subnet" "snet-spoke1" {
    name = "snet-vm"
    virtual_network_name = azurerm_virtual_network.spoke1.name
    resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "spoke2" {
    address_space = ["10.10.0.0/24"]
    location = var.spoke2_location
    name = "vnet-spoke-${var.spoke2_location}-001"
    resource_group_name = var.resource_group_name
    subnet {
        address_prefix = "10.10.0.0/25"
        # id = "snet-spoke2"
        name = "snet-vm"
        security_group = "${azurerm_network_security_group.nsg-snet-spoke2.id}"
    }
}

data "azurerm_subnet" "snet-spoke2" {
    name = "snet-vm"
    virtual_network_name = azurerm_virtual_network.spoke2.name
    resource_group_name = var.resource_group_name
}

# Create Network Security Groups
resource "azurerm_network_security_group" "nsg-hub-default" {
    location = var.hub_location
    name = "nsg-snet-hub-${var.hub_location}-001"
    resource_group_name = var.resource_group_name

    security_rule {
        access = "Allow"
        description = "CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "*"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowCorpnet"
        priority = 2700
        protocol = "*"
        source_address_prefix = "CorpNetPublic"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }

    security_rule {
        access = "Allow"
        description = "CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "*"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowSAW"
        priority = 2701
        protocol = "*"
        source_address_prefix = "CorpNetSaw"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }
}

resource "azurerm_network_security_group" "nsg-hub-bastion" {
    location = var.hub_location
    name = "nsg-snet-hub-bastion-${var.hub_location}-001"
    resource_group_name = var.resource_group_name

    security_rule {
        access = "Allow"
        description = "Allow GatewayManager"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "443"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowGatewayManager"
        priority = 2702
        protocol = "TCP"
        source_address_prefix = "GatewayManager"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }

    security_rule {
        access = "Allow"
        description = "Allow HTTPs"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "443"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowHttpsInBound"
        priority = 2703
        protocol = "TCP"
        source_address_prefix = "Internet"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }

    security_rule {
        access = "Allow"
        description = "Allow LB"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "443"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowAzureLoadBalancerInbound"
        priority = 2704
        protocol = "TCP"
        source_address_prefix = "AzureLoadBalancer"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }

    security_rule {
        access = "Allow"
        description = "Allow Bastion Host"
        destination_address_prefix = "VirtualNetwork"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = ""
        destination_port_ranges = [5701, 8080]
        direction = "Inbound"
        name = "AllowBastionHostCommunication"
        priority = 2705
        protocol = "*"
        source_address_prefix = "VirtualNetwork"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }

    security_rule {
        access = "Allow"
        description = "CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "*"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowCorpnet"
        priority = 2700
        protocol = "*"
        source_address_prefix = "CorpNetPublic"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }

    security_rule {
        access = "Allow"
        description = "CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "*"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowSAW"
        priority = 2701
        protocol = "*"
        source_address_prefix = "CorpNetSaw"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }
    
    security_rule {
        access = "Allow"
        description = "Allow SSH Outbound"
        destination_address_prefix = "VirtualNetwork"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = ""
        destination_port_ranges = [22, 3389]
        direction = "Outbound"
        name = "AllowSshRdpOutbound"
        priority = 100
        protocol = "*"
        source_address_prefix = "*"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }

    security_rule {
        access = "Allow"
        description = "Allow Azure Outbound"
        destination_address_prefix = "AzureCloud"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "443"
        destination_port_ranges = []
        direction = "Outbound"
        name = "AllowAzureCloudOutbound"
        priority = 110
        protocol = "TCP"
        source_address_prefix = "*"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }

    security_rule {
        access = "Allow"
        description = "Allow Bastion"
        destination_address_prefix = "VirtualNetwork"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "443"
        destination_port_ranges = []
        direction = "Outbound"
        name = "AllowBastionCommunication"
        priority = 120
        protocol = "*"
        source_address_prefix = "VirtualNetwork"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }

    security_rule {
        access = "Allow"
        description = "Allow HTTP Outbound"
        destination_address_prefix = "Internet"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "80"
        destination_port_ranges = []
        direction = "Outbound"
        name = "AllowHttpOutbound"
        priority = 130
        protocol = "*"
        source_address_prefix = "*"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }
}

resource "azurerm_network_security_group" "nsg-snet-spoke1" {
    location = var.spoke1_location
    name = "nsg-snet-spoke-vm-${var.spoke1_location}-001"
    resource_group_name = var.resource_group_name

    security_rule {
        access = "Allow"
        description = "CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "*"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowCorpnet"
        priority = 2700
        protocol = "*"
        source_address_prefix = "CorpNetPublic"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }

    security_rule {
        access = "Allow"
        description = "CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "*"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowSAW"
        priority = 2701
        protocol = "*"
        source_address_prefix = "CorpNetSaw"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }

    security_rule {
        access = "Allow"
        description = "Allow SSH Inbound"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "22"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowTagSSHInbound"
        priority = 2711
        protocol = "TCP"
        source_address_prefix = "VirtualNetwork"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }
}

resource "azurerm_network_security_group" "nsg-snet-spoke2" {
    location = var.spoke2_location
    name = "nsg-snet-spoke-vm-${var.spoke2_location}-001"
    resource_group_name = var.resource_group_name

    security_rule {
        access = "Allow"
        description = "CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "*"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowCorpnet"
        priority = 2700
        protocol = "*"
        source_address_prefix = "CorpNetPublic"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }

    security_rule {
        access = "Allow"
        description = "CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "*"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowSAW"
        priority = 2701
        protocol = "*"
        source_address_prefix = "CorpNetSaw"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }

    security_rule {
        access = "Allow"
        description = "Allow SSH Inbound"
        destination_address_prefix = "*"
        destination_address_prefixes = []
        destination_application_security_group_ids = []
        destination_port_range = "22"
        destination_port_ranges = []
        direction = "Inbound"
        name = "AllowTagSSHInbound"
        priority = 2711
        protocol = "TCP"
        source_address_prefix = "VirtualNetwork"
        source_address_prefixes = []
        source_application_security_group_ids = []
        source_port_range = "*"
        source_port_ranges = []
    }
}

# Create Virtual Network Peering
resource "azurerm_virtual_network_peering" "hub-to-spoke1" {
    name = "spoke-1"
    remote_virtual_network_id = azurerm_virtual_network.spoke1.id
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.hub.name
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "hub-to-spoke2" {
    name = "spoke-2"
    remote_virtual_network_id = azurerm_virtual_network.spoke2.id
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.hub.name
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "spoke1-to-hub" {
    name = "hub"
    remote_virtual_network_id = azurerm_virtual_network.hub.id
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.spoke1.name
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "spoke2-to-hub" {
    name = "hub"
    remote_virtual_network_id = azurerm_virtual_network.hub.id
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.spoke2.name
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
}

# Create Private DNS Zone
resource "azurerm_private_dns_zone" "privatedns" {
    name = "privatelink.database.windows.net"
    resource_group_name = var.resource_group_name
}

# Link Private DNS Zone to Virtual Network Hub
resource "azurerm_private_dns_zone_virtual_network_link" "privatednslinkhub" {
    name = "hub"
    private_dns_zone_name = azurerm_private_dns_zone.privatedns.name
    resource_group_name = var.resource_group_name
    virtual_network_id = azurerm_virtual_network.hub.id
}

# Link Private DNS Zone to Virtual Network Spoke 1
resource "azurerm_private_dns_zone_virtual_network_link" "privatednslinkspoke1" {
    name = "spoke-1"
    private_dns_zone_name = azurerm_private_dns_zone.privatedns.name
    resource_group_name = var.resource_group_name
    virtual_network_id = azurerm_virtual_network.spoke1.id
}

# Link Private DNS Zone to Virtual Network Spoke 2
resource "azurerm_private_dns_zone_virtual_network_link" "privatednslinkspoke2" {
    name = "spoke-2"
    private_dns_zone_name = azurerm_private_dns_zone.privatedns.name
    resource_group_name = var.resource_group_name
    virtual_network_id = azurerm_virtual_network.spoke2.id
}

# Create Private Endpoint for Azure SQL
resource "azurerm_private_endpoint" "privatesql" {
    location = var.hub_location
    name = "pe-sql-${var.hub_location}-001"
    resource_group_name = var.resource_group_name
    subnet_id = data.azurerm_subnet.snet-hub.id

    private_service_connection {
        name = "pe-connection-sql-${var.hub_location}-001"
        private_connection_resource_id = var.sql_server_id
        subresource_names = ["sqlServer"]
        is_manual_connection = false
    }

    private_dns_zone_group {
        name = "default"
        private_dns_zone_ids = [azurerm_private_dns_zone.privatedns.id]
    }
}

# Create Bastion Host
resource "azurerm_public_ip" "ip-bastion" {
    location = var.hub_location
    name = "pip-vnet-hub-${var.hub_location}-001"
    resource_group_name = var.resource_group_name
    allocation_method = "Static"
    sku = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
    location = var.hub_location
    name = "bst-hub-${var.hub_location}-001"
    resource_group_name = var.resource_group_name
    ip_configuration {
        name = "IpConf"
        public_ip_address_id = azurerm_public_ip.ip-bastion.id
        subnet_id = data.azurerm_subnet.snet-bastion.id
    }
}
