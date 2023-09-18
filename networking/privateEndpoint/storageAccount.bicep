
param resourceName string
param location string

@allowed([
  'blob'
  'table'
  'queue'
  'file'
  'web'
  'dfs'
])
param resourceType string

param storageAccountName string
param storageAccountResourceGroupName string = resourceGroup().name

param virtualNetworkName string
param virtualNetworkResourceGroupName string = resourceGroup().name
param subnetName string

param privateDnsZoneName string
param privateDnsZoneResourceGroupName string = resourceGroup().name

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' existing = {
  name: virtualNetworkName
  scope: resourceGroup(virtualNetworkResourceGroupName)
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' existing = {
  name: subnetName
  parent: virtualNetwork
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' existing = {
  name: storageAccountName
  scope: resourceGroup(storageAccountResourceGroupName)
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
  scope: resourceGroup(privateDnsZoneResourceGroupName)
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: resourceName
  location: location

  properties: {
    privateLinkServiceConnections: [
      {
        name: resourceName
        properties: {
          privateLinkServiceId: storageAccount.id
          groupIds: [
            resourceType
          ]
        }
      }
    ]
    subnet: {
      id: subnet.id
    }
  }
}

resource privateDnsZoneConfig 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-05-01' = {
  name: 'default'
  parent: privateEndpoint
  
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'default'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}
