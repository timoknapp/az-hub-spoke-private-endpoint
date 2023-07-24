param locationHub string = 'westeurope'
param locationSpoke1 string = 'westeurope'
param locationSpoke2 string = 'northeurope'

param vmUser string = 'azureuser'
@secure()
param vmPassword string

param sqlUser string = 'sqluser'
@secure()
param sqlPassword string

var sqlServerName = 'sql${take(uniqueString(resourceGroup().id), 4)}'
var vnetNameHub = 'vnet-hub-${locationHub}-001'
var vnetNameSpoke1 = 'vnet-spoke-${locationSpoke1}-001'
var vnetNameSpoke2 = 'vnet-spoke-${locationSpoke2}-001'

module network 'modules/network.bicep' = {
  name: 'network'
  params: {
    locationHub: locationHub
    locationSpoke1: locationSpoke1
    locationSpoke2: locationSpoke2
    vnetNameHub: vnetNameHub
    vnetNameSpoke1: vnetNameSpoke1
    vnetNameSpoke2: vnetNameSpoke2
    sqlServerName: sqlServerName
  }
}

module storage 'modules/storage.bicep' = {
  name: 'storage'
  params: {
    locationHub: locationHub
    sqlServerName: sqlServerName
    sqlUser: sqlUser
    sqlPassword: sqlPassword
  }
}

module compute 'modules/compute.bicep' = {
  name: 'compute'
  params: {
    locationSpoke1: locationSpoke1
    locationSpoke2: locationSpoke2
    vnetNameSpoke1: vnetNameSpoke1
    vnetNameSpoke2: vnetNameSpoke2
    vmUser: vmUser
    vmPassword: vmPassword
  }
  dependsOn: [
    network
  ]
}
