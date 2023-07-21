param locationHub string = 'westeurope'
param locationSpoke1 string = 'westeurope'
param locationSpoke2 string = 'northeurope'

param vmUser string = 'azureuser'
@secure()
param vmPassword string

param sqlUser string = 'sqluser'
@secure()
param sqlPassword string

// param vmSize string = 'Standard_DS1_v2'
param vmSize string = 'Standard_B2s'

var nicNameVMSpoke1 = 'nic-vm-spoke-${locationSpoke1}-001'
var nicNameVMSpoke2 = 'nic-vm-spoke-${locationSpoke2}-001'
var nsgNameNicVMSpoke1 = 'nsg-nic-spoke-vm-${locationSpoke1}'
var nsgNameNicVMSpoke2 = 'nsg-nic-spoke-vm-${locationSpoke2}'
var nsgNameSnetHubBastion = 'nsg-snet-hub-azurebastion-${locationHub}-001'
var nsgNameSnetHub = 'nsg-snet-hub-${locationHub}-001'
var nsgNameSnetVMSpoke1 = 'nsg-snet-spoke-vm-${locationSpoke1}-001'
var nsgNameSnetVMSpoke2 = 'nsg-snet-spoke-vm-${locationSpoke2}-001'
var privateDnsZoneName = 'privatelink${environment().suffixes.sqlServerHostname}'
var peNameSQL = 'pe-sql'
var pipNameHub = 'pip-vnet-hub-${locationHub}-001'
var sqlServerName = 'sql${take(uniqueString(resourceGroup().id), 4)}'
var bstNameHub = 'bst-hub-${locationHub}-001'
var vmNameSpoke1 = 'vm-client-spoke-${locationSpoke1}'
var vmNameSpoke2 = 'vm-client-spoke-${locationSpoke2}'
var vnetNameHub = 'vnet-hub-${locationHub}-001'
var vnetNameSpoke1 = 'vnet-spoke-${locationSpoke1}-001'
var vnetNameSpoke2 = 'vnet-spoke-${locationSpoke2}-001'
var snetNameHubDefault = 'snet-hub'
var snetNameBastion = 'AzureBastionSubnet'

var mssqlInstallScript = 'https://raw.githubusercontent.com/timoknapp/az-hub-spoke-private-endpoint/master/util/install_mssql.sh'

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  location: 'global'
  name: privateDnsZoneName
}

resource pipHub 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  location: locationHub
  name: pipNameHub
  properties: {
    idleTimeoutInMinutes: 4
    ipTags: []
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
}

resource sqlServer 'Microsoft.Sql/servers@2022-08-01-preview' = {
  location: locationHub
  name: sqlServerName
  properties: {
    administratorLogin: sqlUser
    administratorLoginPassword: sqlPassword
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
    restrictOutboundNetworkAccess: 'Disabled'
    version: '12.0'
  }
}

resource vmSpoke2 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  location: locationSpoke2
  name: vmNameSpoke2
  properties: {
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    hardwareProfile: {
      vmSize: vmSize
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicVMSpoke2.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    osProfile: {
      adminUsername: vmUser
      adminPassword: vmPassword
      allowExtensionOperations: true
      computerName: vmNameSpoke2
      linuxConfiguration: {
        disablePasswordAuthentication: false
        enableVMAgentPlatformUpdates: false
        patchSettings: {
          assessmentMode: 'ImageDefault'
          patchMode: 'ImageDefault'
        }
        provisionVMAgent: true
      }
      secrets: []
    }
    storageProfile: {
      dataDisks: []
      diskControllerType: 'SCSI'
      imageReference: {
        offer: '0001-com-ubuntu-server-focal'
        publisher: 'canonical'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        name: 'disk-${vmNameSpoke2}'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        deleteOption: 'Delete'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        osType: 'Linux'
      }
    }
  }
  zones: [
    '1'
  ]
}

resource vmSpoke1 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  location: locationSpoke1
  name: vmNameSpoke1
  properties: {
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    hardwareProfile: {
      vmSize: vmSize
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicVMSpoke1.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    osProfile: {
      adminUsername: vmUser
      adminPassword: vmPassword
      allowExtensionOperations: true
      computerName: vmNameSpoke1
      linuxConfiguration: {
        disablePasswordAuthentication: false
        enableVMAgentPlatformUpdates: false
        patchSettings: {
          assessmentMode: 'ImageDefault'
          patchMode: 'ImageDefault'
        }
        provisionVMAgent: true
      }
      secrets: []
    }
    storageProfile: {
      dataDisks: []
      diskControllerType: 'SCSI'
      imageReference: {
        offer: '0001-com-ubuntu-server-focal'
        publisher: 'canonical'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        name: 'disk-${vmNameSpoke1}'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        deleteOption: 'Delete'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        osType: 'Linux'
      }
    }
  }
  zones: [
    '1'
  ]
}

resource vmExtensionSpoke1 'Microsoft.Compute/virtualMachines/extensions@2020-06-01' = {
  parent: vmSpoke1
  name: 'install_mssql'
  location: locationSpoke1
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    autoUpgradeMinorVersion: true
    protectedSettings: {
      fileUris: [
        mssqlInstallScript
      ]
      commandToExecute: 'sh install_mssql.sh'
      // commandToExecute: 'sudo dpkg --configure -a && sudo apt-get -y update && && sudo apt-get -y install mssql-tools18 unixodbc-dev'
    }
  }
}

resource vmExtensionSpoke2 'Microsoft.Compute/virtualMachines/extensions@2020-06-01' = {
  parent: vmSpoke2
  name: 'install_mssql'
  location: locationSpoke2
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    autoUpgradeMinorVersion: true
    protectedSettings: {
      fileUris: [
        mssqlInstallScript
      ]
      commandToExecute: 'sh install_mssql.sh'
      // commandToExecute: 'sudo dpkg --configure -a && sudo apt-get -y update && && sudo apt-get -y install mssql-tools18 unixodbc-dev'
    }
  }
}

resource nsgNicVMSpoke2 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  location: locationSpoke2
  name: nsgNameNicVMSpoke2
  properties: {
    securityRules: [
      {
        name: 'AllowTagSSHInbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '22'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 100
          protocol: 'TCP'
          sourceAddressPrefix: 'VirtualNetwork'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
    ]
  }
}

resource nsgNicVMSpok1 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: nsgNameNicVMSpoke1
  location: locationSpoke1
  properties: {
    securityRules: [
      {
        name: 'AllowTagSSHInbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '22'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 100
          protocol: 'TCP'
          sourceAddressPrefix: 'VirtualNetwork'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
    ]
  }
}

resource privateDnsZoneSOARecord 'Microsoft.Network/privateDnsZones/SOA@2018-09-01' = {
  parent: privateDnsZone
  name: '@'
  properties: {
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
    ttl: 3600
  }
}

resource sqlServerDB 'Microsoft.Sql/servers/databases@2022-08-01-preview' = {
  parent: sqlServer
  location: locationHub
  name: 'db'
  properties: {
    availabilityZone: 'NoPreference'
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    isLedgerOn: false
    licenseType: 'LicenseIncluded'
    maxSizeBytes: 34359738368
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Local'
    zoneRedundant: false
  }
  sku: {
    capacity: 2
    family: 'Gen5'
    name: 'GP_Gen5'
    tier: 'GeneralPurpose'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2022-11-01' = {
  location: locationHub
  name: bstNameHub
  properties: {
    disableCopyPaste: false
    dnsName: 'bst-b0d1a2f4-c8d6-41cc-8432-343d8a5684c2.bastion.azure.com'
    enableIpConnect: false
    enableKerberos: false
    enableShareableLink: false
    enableTunneling: false
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pipHub.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNameHub, snetNameBastion)
          }
        }
      }
    ]
    scaleUnits: 2
  }
  sku: {
    name: 'Standard'
  }
  dependsOn: [
    vnetHub
  ]
}

resource nicVMSpoke2 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  location: locationSpoke2
  name: nicNameVMSpoke2
  properties: {
    disableTcpStateTracking: false
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          primary: true
          privateIPAddressVersion: 'IPv4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNameSpoke2, 'snet-vm')
          }
        }
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
      }
    ]
    networkSecurityGroup: {
      id: nsgNicVMSpoke2.id
    }
    nicType: 'Standard'
  }
  dependsOn: [
    vnetSpoke2
  ]
}

resource nicVMSpoke1 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  location: locationSpoke1
  name: nicNameVMSpoke1
  properties: {
    disableTcpStateTracking: false
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          primary: true
          privateIPAddressVersion: 'IPv4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNameSpoke1, 'snet-vm')
          }
        }
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
      }
    ]
    networkSecurityGroup: {
      id: nsgNicVMSpok1.id
    }
    nicType: 'Standard'
  }
  dependsOn: [
    vnetSpoke1
  ]
}

resource nsgSnetHub 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  location: locationHub
  name: nsgNameSnetHub
  properties: {
    securityRules: [
      {
        name: 'AllowCorpnet'
        properties: {
          access: 'Allow'
          description: 'CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '*'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 2700
          protocol: '*'
          sourceAddressPrefix: 'CorpNetPublic'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
      {
        name: 'AllowSAW'
        properties: {
          access: 'Allow'
          description: 'CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '*'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 2701
          protocol: '*'
          sourceAddressPrefix: 'CorpNetSaw'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
    ]
  }
}

resource privateDnsZoneVnetLinkHub 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZone
  location: 'global'
  name: 'hub'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnetNameHub)
    }
  }
}

resource privateDnsZoneVnetLinkSpoke2 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZone
  location: 'global'
  name: 'spoke-2'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnetNameSpoke2)
    }
  }
}

resource privateDnsZoneVnetLinkSpoke1 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZone
  location: 'global'
  name: 'spoke-1'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnetNameSpoke1)
    }
  }
}

resource privateEndpointSqlHub 'Microsoft.Network/privateEndpoints@2022-11-01' = {
  location: locationHub
  name: peNameSQL
  properties: {
    privateLinkServiceConnections: [
      {
        name: peNameSQL
        properties: {
          groupIds: [
            'sqlServer'
          ]
          privateLinkServiceId: sqlServer.id
        }
      }
    ]
    subnet: {
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNameHub, snetNameHubDefault)
    }
  }
  dependsOn: [
    vnetHub
  ]
}

resource privateEndpointSqlDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-11-01' = {
  parent: privateEndpointSqlHub
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-database-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}

resource vnetPeeringSpoke2ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  parent: vnetSpoke2
  name: 'hub'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    doNotVerifyRemoteGateways: false
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteAddressSpace: {
      addressPrefixes: [
        '10.5.0.0/24'
      ]
    }
    remoteVirtualNetwork: {
      id: vnetHub.id
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.5.0.0/24'
      ]
    }
    useRemoteGateways: false
  }
}

resource vnetPeeringSpoke1ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  parent: vnetSpoke1
  name: 'hub'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    doNotVerifyRemoteGateways: false
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteAddressSpace: {
      addressPrefixes: [
        '10.5.0.0/24'
      ]
    }
    remoteVirtualNetwork: {
      id: vnetHub.id
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.5.0.0/24'
      ]
    }
    useRemoteGateways: false
  }
}

resource vnetPeeringHubToSpoke2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  parent: vnetHub
  name: 'spoke-2'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    doNotVerifyRemoteGateways: false
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteAddressSpace: {
      addressPrefixes: [
        '10.10.0.0/24'
      ]
    }
    remoteVirtualNetwork: {
      id: vnetSpoke2.id
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.10.0.0/24'
      ]
    }
    useRemoteGateways: false
  }
}

resource vnetPeeringHubToSpoke1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  parent: vnetHub
  name: 'spoke-1'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    doNotVerifyRemoteGateways: false
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteAddressSpace: {
      addressPrefixes: [
        '10.20.0.0/24'
      ]
    }
    remoteVirtualNetwork: {
      id: vnetSpoke1.id
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.20.0.0/24'
      ]
    }
    useRemoteGateways: false
  }
}

resource nsgSnetVMSpoke2 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  location: locationSpoke2
  name: nsgNameSnetVMSpoke2
  properties: {
    securityRules: [
      {
        name: 'AllowCorpnet'
        properties: {
          access: 'Allow'
          description: 'CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '*'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 2700
          protocol: '*'
          sourceAddressPrefix: 'CorpNetPublic'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
      {
        name: 'AllowSAW'
        properties: {
          access: 'Allow'
          description: 'CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '*'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 2701
          protocol: '*'
          sourceAddressPrefix: 'CorpNetSaw'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
      {
        name: 'AllowTagSSHInbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '22'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 2711
          protocol: 'TCP'
          sourceAddressPrefix: 'VirtualNetwork'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
    ]
  }
}

resource networkSecurityGroups_vnet_spoke_westeu_001_snet_vm_nsg_westeurope_name_resource 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  location: locationSpoke1
  name: nsgNameSnetVMSpoke1
  properties: {
    securityRules: [
      {
        name: 'AllowCorpnet'
        properties: {
          access: 'Allow'
          description: 'CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '*'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 2700
          protocol: '*'
          sourceAddressPrefix: 'CorpNetPublic'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
      {
        name: 'AllowSAW'
        properties: {
          access: 'Allow'
          description: 'CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '*'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 2701
          protocol: '*'
          sourceAddressPrefix: 'CorpNetSaw'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
      {
        name: 'AllowTagSSHInbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '22'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 2711
          protocol: 'TCP'
          sourceAddressPrefix: 'VirtualNetwork'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
    ]
  }
}

resource vnetSpoke2 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  location: locationSpoke2
  name: vnetNameSpoke2
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/24'
      ]
    }
    dhcpOptions: {
      dnsServers: []
    }
    enableDdosProtection: false
    subnets: [
      {
        name: 'snet-vm'
        properties: {
          addressPrefix: '10.10.0.0/25'
          delegations: []
          networkSecurityGroup: {
            id: nsgSnetVMSpoke2.id
          }
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          serviceEndpoints: []
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
  }
}

resource vnetSpoke1 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  location: locationSpoke1
  name: vnetNameSpoke1
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/24'
      ]
    }
    dhcpOptions: {
      dnsServers: []
    }
    enableDdosProtection: false
    subnets: [
      {
        name: 'snet-vm'
        properties: {
          addressPrefix: '10.20.0.0/25'
          delegations: []
          networkSecurityGroup: {
            id: networkSecurityGroups_vnet_spoke_westeu_001_snet_vm_nsg_westeurope_name_resource.id
          }
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          serviceEndpoints: []
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
  }
}

resource nsgSnetHubBastion 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  location: locationHub
  name: nsgNameSnetHubBastion
  properties: {
    securityRules: [
      {
        name: 'AllowGatewayManager'
        properties: {
          access: 'Allow'
          description: 'Allow GatewayManager'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '443'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 2702
          protocol: '*'
          sourceAddressPrefix: 'GatewayManager'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
      {
        name: 'AllowHttpsInBound'
        properties: {
          access: 'Allow'
          description: 'Allow HTTPs'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '443'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 2703
          protocol: '*'
          sourceAddressPrefix: 'Internet'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
      {
        name: 'AllowSshRdpOutbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefixes: []
          destinationPortRanges: [
            '22'
            '3389'
          ]
          direction: 'Outbound'
          priority: 100
          protocol: '*'
          sourceAddressPrefix: '*'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
      {
        name: 'AllowAzureCloudOutbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: 'AzureCloud'
          destinationAddressPrefixes: []
          destinationPortRange: '443'
          destinationPortRanges: []
          direction: 'Outbound'
          priority: 110
          protocol: 'TCP'
          sourceAddressPrefix: '*'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
      {
        name: 'AllowCorpnet'
        properties: {
          access: 'Allow'
          description: 'CSS Governance Security Rule.  Allow Corpnet inbound.  https://aka.ms/casg'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '*'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 2700
          protocol: '*'
          sourceAddressPrefix: 'CorpNetPublic'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
      {
        name: 'AllowSAW'
        properties: {
          access: 'Allow'
          description: 'CSS Governance Security Rule.  Allow SAW inbound.  https://aka.ms/casg'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '*'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 2701
          protocol: '*'
          sourceAddressPrefix: 'CorpNetSaw'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
      }
    ]
  }
}

resource vnetHub 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  location: locationHub
  name: vnetNameHub
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.5.0.0/24'
      ]
    }
    dhcpOptions: {
      dnsServers: []
    }
    enableDdosProtection: false
    subnets: [
      {
        name: snetNameHubDefault
        properties: {
          addressPrefix: '10.5.0.0/25'
          delegations: []
          networkSecurityGroup: {
            id: nsgSnetHub.id
          }
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          serviceEndpoints: [
            {
              locations: [
                locationHub
              ]
              service: 'Microsoft.Sql'
            }
          ]
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: snetNameBastion
        properties: {
          addressPrefix: '10.5.0.128/26'
          delegations: []
          networkSecurityGroup: {
            id: nsgSnetHubBastion.id
          }
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          serviceEndpoints: []
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
  }
}
