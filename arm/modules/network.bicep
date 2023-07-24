param locationHub string
param locationSpoke1 string
param locationSpoke2 string
param vnetNameHub string
param vnetNameSpoke1 string
param vnetNameSpoke2 string
param sqlServerName string

var nsgNameSnetHubBastion = 'nsg-snet-hub-azurebastion-${locationHub}-001'
var nsgNameSnetHub = 'nsg-snet-hub-${locationHub}-001'
var nsgNameSnetVMSpoke1 = 'nsg-snet-spoke-vm-${locationSpoke1}-001'
var nsgNameSnetVMSpoke2 = 'nsg-snet-spoke-vm-${locationSpoke2}-001'
var privateDnsZoneName = 'privatelink${environment().suffixes.sqlServerHostname}'
var peNameSQL = 'pe-sql'
var pipNameHub = 'pip-vnet-hub-${locationHub}-001'
var bstNameHub = 'bst-hub-${locationHub}-001'
var snetNameHubDefault = 'snet-hub'
var snetNameBastion = 'AzureBastionSubnet'


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
            id: nsgSnetVMSpoke1.id
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

resource nsgSnetVMSpoke1 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
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
          privateLinkServiceId: resourceId('Microsoft.Sql/servers', sqlServerName)
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

resource bastion 'Microsoft.Network/bastionHosts@2022-11-01' = {
  location: locationHub
  name: bstNameHub
  properties: {
    disableCopyPaste: false
    // dnsName: 'bst-b0d1a2f4-c8d6-41cc-8432-343d8a5684c2.bastion.azure.com'
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

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  location: 'global'
  name: privateDnsZoneName
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
