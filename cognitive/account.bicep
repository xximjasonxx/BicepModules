
param resourceName string
param location string

@allowed([
  'S0'
])
param skuName string = 'S0'

param allowPublicNetworkAccess bool = true

resource account 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: resourceName
  location: location
  sku: {
    name: skuName
  }
  kind: 'CognitiveServices'
  properties: {
    networkAcls: {
      defaultAction: allowPublicNetworkAccess ? 'Allow' : 'Deny'
    }
    publicNetworkAccess: allowPublicNetworkAccess ? 'Enabled' : 'Disabled'
  }
}
