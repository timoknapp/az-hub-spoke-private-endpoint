param locationWestEurope string = 'westeurope'
param locationNorthEurope string = 'northeurope'

param bastionHosts_bst_hub_name string

param vmUser string = 'azureuser'

@secure()
param vmPassword string

@secure()
param sqlPassword string

@secure()
param extensions_enablevmaccess_expiration string

@secure()
param extensions_enablevmaccess_expiration_1 string

@secure()
param extensions_enablevmaccess_password string

@secure()
param extensions_enablevmaccess_password_1 string

@secure()
param extensions_enablevmaccess_remove_user string

@secure()
param extensions_enablevmaccess_remove_user_1 string

@secure()
param extensions_enablevmaccess_reset_ssh string

@secure()
param extensions_enablevmaccess_reset_ssh_1 string

@secure()
param extensions_enablevmaccess_ssh_key string

@secure()
param extensions_enablevmaccess_ssh_key_1 string

@secure()
param extensions_enablevmaccess_username string

@secure()
param extensions_enablevmaccess_username_1 string
param networkInterfaces_client_vm_spoke_northeu33_z1_name string
param networkInterfaces_client_vm_westeu116_z1_name string
param networkInterfaces_pe_sql_nic_name string
param networkSecurityGroups_client_vm_spoke_northeu_nsg_name string
param networkSecurityGroups_client_vm_westeu_nsg_name string
param networkSecurityGroups_vnet_hub_001_AzureBastionSubnet_nsg_westeurope_name string
param networkSecurityGroups_vnet_hub_001_snet_hub_nsg_westeurope_name string
param networkSecurityGroups_vnet_spoke_northeu_001_snet_vm_nsg_northeurope_name string
param networkSecurityGroups_vnet_spoke_westeu_001_snet_vm_nsg_westeurope_name string
param privateDnsZones_privatelink_database_windows_net_name string
param privateEndpoints_pe_sql_name string
param publicIPAddresses_vnet_hub_001_ip_name string
param servers_azsqltk_name string
param virtualMachines_client_vm_spoke_northeu_name string
param virtualMachines_client_vm_westeu_name string
param virtualNetworks_vnet_hub_001_name string
param virtualNetworks_vnet_spoke_northeu_001_name string
param virtualNetworks_vnet_spoke_westeu_001_name string

@secure()
param vulnerabilityAssessments_Default_storageContainerPath string

resource privateDnsZones_privatelink_database_windows_net_name_resource 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  location: 'global'
  name: privateDnsZones_privatelink_database_windows_net_name
}

resource publicIPAddresses_vnet_hub_001_ip_name_resource 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  location: locationWestEurope
  name: publicIPAddresses_vnet_hub_001_ip_name
  properties: {
    idleTimeoutInMinutes: 4
    // ipAddress: '20.16.56.178'
    ipTags: []
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
}

resource servers_azsqltk_name_resource 'Microsoft.Sql/servers@2022-08-01-preview' = {
  location: locationWestEurope
  name: servers_azsqltk_name
  properties: {
    administratorLogin: 'sqluser'
    administratorLoginPassword: sqlPassword
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: false
      login: 'timo.knapp_microsoft.com#EXT#@fdpo.onmicrosoft.com'
      principalType: 'User'
      sid: '91bf285c-b3de-4482-873d-a57edafb15e9'
      tenantId: '16b3c013-d300-468d-ac64-7eda0820b6d3'
    }
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
    restrictOutboundNetworkAccess: 'Disabled'
    version: '12.0'
  }
}

resource virtualMachines_client_vm_spoke_northeu_name_resource 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  location: locationNorthEurope
  name: virtualMachines_client_vm_spoke_northeu_name
  properties: {
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    hardwareProfile: {
      vmSize: 'Standard_B1ls'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_client_vm_spoke_northeu33_z1_name_resource.id
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
      computerName: virtualMachines_client_vm_spoke_northeu_name
      linuxConfiguration: {
        disablePasswordAuthentication: false
        enableVMAgentPlatformUpdates: false
        patchSettings: {
          assessmentMode: 'ImageDefault'
          patchMode: 'ImageDefault'
        }
        provisionVMAgent: true
      }
      requireGuestProvisionSignal: true
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
        caching: 'ReadWrite'
        createOption: 'FromImage'
        deleteOption: 'Delete'
        managedDisk: {
          id: resourceId('Microsoft.Compute/disks', '${virtualMachines_client_vm_spoke_northeu_name}_OsDisk_1_1b672174a0694cae9b4d33d036f05ba5')
        }
        name: '${virtualMachines_client_vm_spoke_northeu_name}_OsDisk_1_1b672174a0694cae9b4d33d036f05ba5'
        osType: 'Linux'
      }
    }
  }
  zones: [
    '1'
  ]
}

resource virtualMachines_client_vm_westeu_name_resource 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  location: locationWestEurope
  name: virtualMachines_client_vm_westeu_name
  properties: {
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    hardwareProfile: {
      vmSize: 'Standard_B1ls'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_client_vm_westeu116_z1_name_resource.id
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
      computerName: virtualMachines_client_vm_westeu_name
      linuxConfiguration: {
        disablePasswordAuthentication: false
        enableVMAgentPlatformUpdates: false
        patchSettings: {
          assessmentMode: 'ImageDefault'
          patchMode: 'ImageDefault'
        }
        provisionVMAgent: true
      }
      requireGuestProvisionSignal: true
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
        caching: 'ReadWrite'
        createOption: 'FromImage'
        deleteOption: 'Delete'
        managedDisk: {
          id: resourceId('Microsoft.Compute/disks', '${virtualMachines_client_vm_westeu_name}_OsDisk_1_4c85127ac624453f997cb5eff17b6450')
        }
        name: '${virtualMachines_client_vm_westeu_name}_OsDisk_1_4c85127ac624453f997cb5eff17b6450'
        osType: 'Linux'
      }
    }
  }
  zones: [
    '1'
  ]
}

resource virtualMachines_client_vm_spoke_northeu_name_enablevmaccess 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  parent: virtualMachines_client_vm_spoke_northeu_name_resource
  location: locationNorthEurope
  name: 'enablevmaccess'
  properties: {
    autoUpgradeMinorVersion: true
    protectedSettings: {
      expiration: extensions_enablevmaccess_expiration
      password: extensions_enablevmaccess_password
      remove_user: extensions_enablevmaccess_remove_user
      reset_ssh: extensions_enablevmaccess_reset_ssh
      ssh_key: extensions_enablevmaccess_ssh_key
      username: extensions_enablevmaccess_username
    }
    publisher: 'Microsoft.OSTCExtensions'
    settings: {
    }
    type: 'VMAccessForLinux'
    typeHandlerVersion: '1.4'
  }
}

resource virtualMachines_client_vm_westeu_name_enablevmaccess 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  parent: virtualMachines_client_vm_westeu_name_resource
  location: locationWestEurope
  name: 'enablevmaccess'
  properties: {
    autoUpgradeMinorVersion: true
    protectedSettings: {
      expiration: extensions_enablevmaccess_expiration_1
      password: extensions_enablevmaccess_password_1
      remove_user: extensions_enablevmaccess_remove_user_1
      reset_ssh: extensions_enablevmaccess_reset_ssh_1
      ssh_key: extensions_enablevmaccess_ssh_key_1
      username: extensions_enablevmaccess_username_1
    }
    publisher: 'Microsoft.OSTCExtensions'
    settings: {
    }
    type: 'VMAccessForLinux'
    typeHandlerVersion: '1.4'
  }
}

resource networkInterfaces_pe_sql_nic_name_resource 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  location: locationWestEurope
  name: networkInterfaces_pe_sql_nic_name
  properties: {
    disableTcpStateTracking: false
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    ipConfigurations: [
      {
        name: 'privateEndpointIpConfig.fa803a40-8fbd-4673-9f43-b84aea118ddd'
        properties: {
          primary: true
          privateIPAddress: '10.5.0.5'
          privateIPAddressVersion: 'IPv4'
          privateIPAllocationMethod: 'Static'
          privateLinkConnectionProperties: {
            fqdns: [
              'azsqltk.database.windows.net'
            ]
            groupId: 'sqlServer'
            requiredMemberName: 'sqlServer'
          }
          subnet: {
            id: virtualNetworks_vnet_hub_001_name_snet_hub.id
          }
        }
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
      }
    ]
    nicType: 'Standard'
  }
}

resource networkSecurityGroups_client_vm_spoke_northeu_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  location: locationNorthEurope
  name: networkSecurityGroups_client_vm_spoke_northeu_nsg_name
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

resource networkSecurityGroups_client_vm_westeu_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  location: locationWestEurope
  name: networkSecurityGroups_client_vm_westeu_nsg_name
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

resource privateDnsZones_privatelink_database_windows_net_name_azsqltk 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: privateDnsZones_privatelink_database_windows_net_name_resource
  name: 'azsqltk'
  properties: {
    aRecords: [
      {
        ipv4Address: '10.5.0.5'
      }
    ]
    metadata: {
      creator: 'created by private endpoint pe-sql with resource guid 37e57078-4e55-463b-b6b4-0ec692fd5f3e'
    }
    ttl: 10
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_database_windows_net_name 'Microsoft.Network/privateDnsZones/SOA@2018-09-01' = {
  parent: privateDnsZones_privatelink_database_windows_net_name_resource
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

resource servers_azsqltk_name_ActiveDirectory 'Microsoft.Sql/servers/administrators@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'ActiveDirectory'
  properties: {
    administratorType: 'ActiveDirectory'
    login: 'timo.knapp_microsoft.com#EXT#@fdpo.onmicrosoft.com'
    sid: '91bf285c-b3de-4482-873d-a57edafb15e9'
    tenantId: '16b3c013-d300-468d-ac64-7eda0820b6d3'
  }
}

resource servers_azsqltk_name_Default 'Microsoft.Sql/servers/advancedThreatProtectionSettings@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'Default'
  properties: {
    state: 'Enabled'
  }
}

resource servers_azsqltk_name_CreateIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_azsqltk_name_resource
  name: 'CreateIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_azsqltk_name_DbParameterization 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_azsqltk_name_resource
  name: 'DbParameterization'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_azsqltk_name_DefragmentIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_azsqltk_name_resource
  name: 'DefragmentIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_azsqltk_name_DropIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_azsqltk_name_resource
  name: 'DropIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_azsqltk_name_ForceLastGoodPlan 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_azsqltk_name_resource
  name: 'ForceLastGoodPlan'
  properties: {
    autoExecuteValue: 'Enabled'
  }
}

resource Microsoft_Sql_servers_auditingPolicies_servers_azsqltk_name_Default 'Microsoft.Sql/servers/auditingPolicies@2014-04-01' = {
  parent: servers_azsqltk_name_resource
  location: locationWestEurope
  name: 'Default'
  properties: {
    auditingState: 'Disabled'
  }
}

resource Microsoft_Sql_servers_auditingSettings_servers_azsqltk_name_Default 'Microsoft.Sql/servers/auditingSettings@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'default'
  properties: {
    auditActionsAndGroups: [
      'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
      'FAILED_DATABASE_AUTHENTICATION_GROUP'
      'BATCH_COMPLETED_GROUP'
    ]
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    isStorageSecondaryKeyInUse: false
    retentionDays: 60
    state: 'Enabled'
    storageAccountSubscriptionId: '6b76ff87-a921-49fe-a04a-92aebd1ac6fa'
    storageEndpoint: 'https://mcapsgovcsqlauditstorage.blob.core.windows.net/'
  }
}

resource Microsoft_Sql_servers_azureADOnlyAuthentications_servers_azsqltk_name_Default 'Microsoft.Sql/servers/azureADOnlyAuthentications@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'Default'
  properties: {
    azureADOnlyAuthentication: false
  }
}

resource Microsoft_Sql_servers_connectionPolicies_servers_azsqltk_name_default 'Microsoft.Sql/servers/connectionPolicies@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'default'
  properties: {
    connectionType: 'Default'
  }
}

resource servers_azsqltk_name_db 'Microsoft.Sql/servers/databases@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  location: locationWestEurope
  name: 'db'
  properties: {
    availabilityZone: 'NoPreference'
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    isLedgerOn: false
    licenseType: 'LicenseIncluded'
    maintenanceConfigurationId: resourceId('Microsoft.Maintenance/publicMaintenanceConfigurations', 'SQL_Default')
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

resource servers_azsqltk_name_master_Default 'Microsoft.Sql/servers/databases/advancedThreatProtectionSettings@2022-08-01-preview' = {
  name: '${servers_azsqltk_name}/master/Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingPolicies_servers_azsqltk_name_master_Default 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  name: '${servers_azsqltk_name}/master/Default'
  properties: {
    auditingState: 'Disabled'
  }
  dependsOn: [
    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingSettings_servers_azsqltk_name_master_Default 'Microsoft.Sql/servers/databases/auditingSettings@2022-08-01-preview' = {
  name: '${servers_azsqltk_name}/master/Default'
  properties: {
    auditActionsAndGroups: []
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    isStorageSecondaryKeyInUse: false
    retentionDays: 0
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_extendedAuditingSettings_servers_azsqltk_name_master_Default 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2022-08-01-preview' = {
  name: '${servers_azsqltk_name}/master/Default'
  properties: {
    auditActionsAndGroups: []
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    isStorageSecondaryKeyInUse: false
    retentionDays: 0
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_geoBackupPolicies_servers_azsqltk_name_master_Default 'Microsoft.Sql/servers/databases/geoBackupPolicies@2022-08-01-preview' = {
  name: '${servers_azsqltk_name}/master/Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_azsqltk_name_resource
  ]
}

resource servers_azsqltk_name_master_Current 'Microsoft.Sql/servers/databases/ledgerDigestUploads@2022-08-01-preview' = {
  name: '${servers_azsqltk_name}/master/Current'
  properties: {
  }
  dependsOn: [
    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_securityAlertPolicies_servers_azsqltk_name_master_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2022-08-01-preview' = {
  name: '${servers_azsqltk_name}/master/Default'
  properties: {
    disabledAlerts: [
      ''
    ]
    emailAccountAdmins: false
    emailAddresses: [
      ''
    ]
    retentionDays: 0
    state: 'Disabled'
  }
  dependsOn: [
    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_transparentDataEncryption_servers_azsqltk_name_master_Current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2022-08-01-preview' = {
  name: '${servers_azsqltk_name}/master/Current'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_servers_azsqltk_name_master_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2022-08-01-preview' = {
  name: '${servers_azsqltk_name}/master/Default'
  properties: {
    recurringScans: {
      emailSubscriptionAdmins: true
      isEnabled: false
    }
  }
  dependsOn: [
    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_devOpsAuditingSettings_servers_azsqltk_name_Default 'Microsoft.Sql/servers/devOpsAuditingSettings@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'Default'
  properties: {
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource servers_azsqltk_name_current 'Microsoft.Sql/servers/encryptionProtector@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'current'
  properties: {
    autoRotationEnabled: false
    serverKeyName: 'ServiceManaged'
    serverKeyType: 'ServiceManaged'
  }
}

resource Microsoft_Sql_servers_extendedAuditingSettings_servers_azsqltk_name_Default 'Microsoft.Sql/servers/extendedAuditingSettings@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'default'
  properties: {
    auditActionsAndGroups: [
      'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
      'FAILED_DATABASE_AUTHENTICATION_GROUP'
      'BATCH_COMPLETED_GROUP'
    ]
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    isStorageSecondaryKeyInUse: false
    retentionDays: 60
    state: 'Enabled'
    storageAccountSubscriptionId: '6b76ff87-a921-49fe-a04a-92aebd1ac6fa'
    storageEndpoint: 'https://mcapsgovcsqlauditstorage.blob.core.windows.net/'
  }
}

resource servers_azsqltk_name_ServiceManaged 'Microsoft.Sql/servers/keys@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'ServiceManaged'
  properties: {
    serverKeyType: 'ServiceManaged'
  }
}

resource Microsoft_Sql_servers_securityAlertPolicies_servers_azsqltk_name_Default 'Microsoft.Sql/servers/securityAlertPolicies@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'Default'
  properties: {
    disabledAlerts: [
      ''
    ]
    emailAccountAdmins: false
    emailAddresses: [
      ''
    ]
    retentionDays: 0
    state: 'Enabled'
  }
}

resource Microsoft_Sql_servers_sqlVulnerabilityAssessments_servers_azsqltk_name_Default 'Microsoft.Sql/servers/sqlVulnerabilityAssessments@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
}

resource Microsoft_Sql_servers_vulnerabilityAssessments_servers_azsqltk_name_Default 'Microsoft.Sql/servers/vulnerabilityAssessments@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'Default'
  properties: {
    recurringScans: {
      emailSubscriptionAdmins: true
      isEnabled: false
    }
    storageContainerPath: vulnerabilityAssessments_Default_storageContainerPath
  }
}

resource bastionHosts_bst_hub_name_resource 'Microsoft.Network/bastionHosts@2022-11-01' = {
  location: locationWestEurope
  name: bastionHosts_bst_hub_name
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
            id: publicIPAddresses_vnet_hub_001_ip_name_resource.id
          }
          subnet: {
            id: virtualNetworks_vnet_hub_001_name_AzureBastionSubnet.id
          }
        }
      }
    ]
    scaleUnits: 2
  }
  sku: {
    name: 'Standard'
  }
}

resource networkInterfaces_client_vm_spoke_northeu33_z1_name_resource 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  kind: 'Regular'
  location: locationNorthEurope
  name: networkInterfaces_client_vm_spoke_northeu33_z1_name
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
          privateIPAddress: '10.10.0.4'
          privateIPAddressVersion: 'IPv4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'vnet-spoke-northeu-001', 'snet-vm')
          }
        }
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_client_vm_spoke_northeu_nsg_name_resource.id
    }
    nicType: 'Standard'
  }
}

resource networkInterfaces_client_vm_westeu116_z1_name_resource 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  kind: 'Regular'
  location: locationWestEurope
  name: networkInterfaces_client_vm_westeu116_z1_name
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
          privateIPAddress: '10.20.0.4'
          privateIPAddressVersion: 'IPv4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'vnet-spoke-westeu-001', 'snet-vm')
          }
        }
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_client_vm_westeu_nsg_name_resource.id
    }
    nicType: 'Standard'
  }
}

resource networkSecurityGroups_vnet_hub_001_snet_hub_nsg_westeurope_name_resource 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  location: locationWestEurope
  name: networkSecurityGroups_vnet_hub_001_snet_hub_nsg_westeurope_name
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

resource privateDnsZones_privatelink_database_windows_net_name_spoke_northeu 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZones_privatelink_database_windows_net_name_resource
  location: 'global'
  name: 'spoke-northeu'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', 'vnet-spoke-northeu-001')
    }
  }
}

resource privateDnsZones_privatelink_database_windows_net_name_spoke_westeu 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZones_privatelink_database_windows_net_name_resource
  location: 'global'
  name: 'spoke-westeu'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', 'vnet-spoke-westeu-001')
    }
  }
}

resource privateEndpoints_pe_sql_name_resource 'Microsoft.Network/privateEndpoints@2022-11-01' = {
  location: locationWestEurope
  name: privateEndpoints_pe_sql_name
  properties: {
    customDnsConfigs: []
    customNetworkInterfaceName: '${privateEndpoints_pe_sql_name}-nic'
    ipConfigurations: [
      {
        name: privateEndpoints_pe_sql_name
        properties: {
          groupId: 'sqlServer'
          memberName: 'sqlServer'
          privateIPAddress: '10.5.0.5'
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_pe_sql_name
        properties: {
          groupIds: [
            'sqlServer'
          ]
          privateLinkServiceConnectionState: {
            actionsRequired: 'None'
            description: 'Auto-approved'
            status: 'Approved'
          }
          privateLinkServiceId: servers_azsqltk_name_resource.id
        }
      }
    ]
    subnet: {
      id: virtualNetworks_vnet_hub_001_name_snet_hub.id
    }
  }
}

resource privateEndpoints_pe_sql_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-11-01' = {
  name: '${privateEndpoints_pe_sql_name}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-database-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZones_privatelink_database_windows_net_name_resource.id
        }
      }
    ]
  }
  dependsOn: [
    privateEndpoints_pe_sql_name_resource

  ]
}

resource virtualNetworks_vnet_spoke_northeu_001_name_hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  name: '${virtualNetworks_vnet_spoke_northeu_001_name}/hub'
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
      id: virtualNetworks_vnet_hub_001_name_resource.id
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.5.0.0/24'
      ]
    }
    useRemoteGateways: false
  }
  dependsOn: [
    virtualNetworks_vnet_spoke_northeu_001_name_resource

  ]
}

resource virtualNetworks_vnet_spoke_westeu_001_name_hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  name: '${virtualNetworks_vnet_spoke_westeu_001_name}/hub'
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
      id: virtualNetworks_vnet_hub_001_name_resource.id
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.5.0.0/24'
      ]
    }
    useRemoteGateways: false
  }
  dependsOn: [
    virtualNetworks_vnet_spoke_westeu_001_name_resource

  ]
}

resource virtualNetworks_vnet_hub_001_name_spoke_northeu 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  name: '${virtualNetworks_vnet_hub_001_name}/spoke-northeu'
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
      id: virtualNetworks_vnet_spoke_northeu_001_name_resource.id
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.10.0.0/24'
      ]
    }
    useRemoteGateways: false
  }
  dependsOn: [
    virtualNetworks_vnet_hub_001_name_resource

  ]
}

resource virtualNetworks_vnet_hub_001_name_spoke_westeu 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  name: '${virtualNetworks_vnet_hub_001_name}/spoke-westeu'
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
      id: virtualNetworks_vnet_spoke_westeu_001_name_resource.id
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.20.0.0/24'
      ]
    }
    useRemoteGateways: false
  }
  dependsOn: [
    virtualNetworks_vnet_hub_001_name_resource

  ]
}

resource servers_azsqltk_name_db_Default 'Microsoft.Sql/servers/databases/advancedThreatProtectionSettings@2022-08-01-preview' = {
  parent: servers_azsqltk_name_db
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource servers_azsqltk_name_db_CreateIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_azsqltk_name_db
  name: 'CreateIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource servers_azsqltk_name_db_DbParameterization 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_azsqltk_name_db
  name: 'DbParameterization'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource servers_azsqltk_name_db_DefragmentIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_azsqltk_name_db
  name: 'DefragmentIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource servers_azsqltk_name_db_DropIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_azsqltk_name_db
  name: 'DropIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource servers_azsqltk_name_db_ForceLastGoodPlan 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_azsqltk_name_db
  name: 'ForceLastGoodPlan'
  properties: {
    autoExecuteValue: 'Enabled'
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingPolicies_servers_azsqltk_name_db_Default 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  parent: servers_azsqltk_name_db
  location: 'West Europe'
  name: 'Default'
  properties: {
    auditingState: 'Disabled'
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingSettings_servers_azsqltk_name_db_Default 'Microsoft.Sql/servers/databases/auditingSettings@2022-08-01-preview' = {
  parent: servers_azsqltk_name_db
  name: 'Default'
  properties: {
    auditActionsAndGroups: []
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    isStorageSecondaryKeyInUse: false
    retentionDays: 0
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupLongTermRetentionPolicies_servers_azsqltk_name_db_default 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2022-08-01-preview' = {
  parent: servers_azsqltk_name_db
  name: 'default'
  properties: {
    monthlyRetention: 'PT0S'
    weekOfYear: 0
    weeklyRetention: 'PT0S'
    yearlyRetention: 'PT0S'
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupShortTermRetentionPolicies_servers_azsqltk_name_db_default 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2022-08-01-preview' = {
  parent: servers_azsqltk_name_db
  name: 'default'
  properties: {
    diffBackupIntervalInHours: 12
    retentionDays: 7
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_extendedAuditingSettings_servers_azsqltk_name_db_Default 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2022-08-01-preview' = {
  parent: servers_azsqltk_name_db
  name: 'Default'
  properties: {
    auditActionsAndGroups: []
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    isStorageSecondaryKeyInUse: false
    retentionDays: 0
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_geoBackupPolicies_servers_azsqltk_name_db_Default 'Microsoft.Sql/servers/databases/geoBackupPolicies@2022-08-01-preview' = {
  parent: servers_azsqltk_name_db
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource servers_azsqltk_name_db_Current 'Microsoft.Sql/servers/databases/ledgerDigestUploads@2022-08-01-preview' = {
  parent: servers_azsqltk_name_db
  name: 'Current'
  properties: {
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_securityAlertPolicies_servers_azsqltk_name_db_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2022-08-01-preview' = {
  parent: servers_azsqltk_name_db
  name: 'Default'
  properties: {
    disabledAlerts: [
      ''
    ]
    emailAccountAdmins: false
    emailAddresses: [
      ''
    ]
    retentionDays: 0
    state: 'Disabled'
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_transparentDataEncryption_servers_azsqltk_name_db_Current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2022-08-01-preview' = {
  parent: servers_azsqltk_name_db
  name: 'Current'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_servers_azsqltk_name_db_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2022-08-01-preview' = {
  parent: servers_azsqltk_name_db
  name: 'Default'
  properties: {
    recurringScans: {
      emailSubscriptionAdmins: true
      isEnabled: false
    }
  }
  dependsOn: [

    servers_azsqltk_name_resource
  ]
}

resource servers_azsqltk_name_pe_sql_1176c4ee_3b54_4678_8052_d46e6db91dcd 'Microsoft.Sql/servers/privateEndpointConnections@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'pe-sql-1176c4ee-3b54-4678-8052-d46e6db91dcd'
  properties: {
    privateEndpoint: {
      id: privateEndpoints_pe_sql_name_resource.id
    }
    privateLinkServiceConnectionState: {
      description: 'Auto-approved'
      status: 'Approved'
    }
  }
}

resource servers_azsqltk_name_vnet_hub_rule 'Microsoft.Sql/servers/virtualNetworkRules@2022-08-01-preview' = {
  parent: servers_azsqltk_name_resource
  name: 'vnet-hub-rule'
  properties: {
    ignoreMissingVnetServiceEndpoint: false
    virtualNetworkSubnetId: virtualNetworks_vnet_hub_001_name_snet_hub.id
  }
}

resource networkSecurityGroups_vnet_spoke_northeu_001_snet_vm_nsg_northeurope_name_resource 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  location: locationNorthEurope
  name: networkSecurityGroups_vnet_spoke_northeu_001_snet_vm_nsg_northeurope_name
  properties: {
    securityRules: [
      {
        id: networkSecurityGroups_vnet_spoke_northeu_001_snet_vm_nsg_northeurope_name_AllowCorpnet.id
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
        id: networkSecurityGroups_vnet_spoke_northeu_001_snet_vm_nsg_northeurope_name_AllowSAW.id
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
        id: networkSecurityGroups_vnet_spoke_northeu_001_snet_vm_nsg_northeurope_name_AllowTagSSHInbound.id
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
  location: locationWestEurope
  name: networkSecurityGroups_vnet_spoke_westeu_001_snet_vm_nsg_westeurope_name
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

resource virtualNetworks_vnet_spoke_northeu_001_name_resource 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  location: locationNorthEurope
  name: virtualNetworks_vnet_spoke_northeu_001_name
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
            id: networkSecurityGroups_vnet_spoke_northeu_001_snet_vm_nsg_northeurope_name_resource.id
          }
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          serviceEndpoints: []
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
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
            id: resourceId('Microsoft.Network/virtualNetworks', 'vnet-hub-001')
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.5.0.0/24'
            ]
          }
          useRemoteGateways: false
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
  }
}

resource virtualNetworks_vnet_spoke_westeu_001_name_resource 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  location: locationWestEurope
  name: virtualNetworks_vnet_spoke_westeu_001_name
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
    virtualNetworkPeerings: [
      {
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
            id: resourceId('Microsoft.Network/virtualNetworks', 'vnet-hub-001')
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.5.0.0/24'
            ]
          }
          useRemoteGateways: false
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
  }
}

resource networkSecurityGroups_vnet_hub_001_AzureBastionSubnet_nsg_westeurope_name_resource 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  location: locationWestEurope
  name: networkSecurityGroups_vnet_hub_001_AzureBastionSubnet_nsg_westeurope_name
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

resource virtualNetworks_vnet_hub_001_name_resource 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  location: locationWestEurope
  name: virtualNetworks_vnet_hub_001_name
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
        name: 'snet-hub'
        properties: {
          addressPrefix: '10.5.0.0/25'
          delegations: []
          networkSecurityGroup: {
            id: networkSecurityGroups_vnet_hub_001_snet_hub_nsg_westeurope_name_resource.id
          }
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          serviceEndpoints: [
            {
              locations: [
                locationWestEurope
              ]
              service: 'Microsoft.Sql'
            }
          ]
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.5.0.128/26'
          delegations: []
          networkSecurityGroup: {
            id: networkSecurityGroups_vnet_hub_001_AzureBastionSubnet_nsg_westeurope_name_resource.id
          }
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          serviceEndpoints: []
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'spoke-northeu'
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
            id: resourceId('Microsoft.Network/virtualNetworks', 'vnet-spoke-northeu-001')
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.10.0.0/24'
            ]
          }
          useRemoteGateways: false
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
      {
        name: 'spoke-westeu'
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
            id: virtualNetworks_vnet_spoke_westeu_001_name_resource.id
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.20.0.0/24'
            ]
          }
          useRemoteGateways: false
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
  }
}
