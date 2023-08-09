param locationSpoke1 string
param locationSpoke2 string
param vnetNameSpoke1 string
param vnetNameSpoke2 string
param vmUser string
@secure()
param vmPassword string

var nicNameVMSpoke1 = 'nic-vm-spoke-${locationSpoke1}-001'
var nicNameVMSpoke2 = 'nic-vm-spoke-${locationSpoke2}-001'
var nsgNameNicVMSpoke1 = 'nsg-nic-spoke-vm-${locationSpoke1}'
var nsgNameNicVMSpoke2 = 'nsg-nic-spoke-vm-${locationSpoke2}'
var vmNameSpoke1 = 'vm-client-spoke-${locationSpoke1}'
var vmNameSpoke2 = 'vm-client-spoke-${locationSpoke2}'
var vmSize = 'Standard_B2s'
// Script consists of all installation stepts described here: https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver16&tabs=ubuntu-install#install-tools-on-linux
var mssqlInstallScript = 'https://raw.githubusercontent.com/timoknapp/az-hub-spoke-private-endpoint/master/util/install_mssql.sh'

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
    // vnetSpoke2
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
    // vnetSpoke1
  ]
}
