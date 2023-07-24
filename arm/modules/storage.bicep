param locationHub string
param sqlServerName string
param sqlUser string
@secure()
param sqlPassword string

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
