
param resourceName string

@minLength(1)
param endpoints array

@allowed([
  'Standard'
  'Premium'
])
param skuType string = 'Premium'

resource frontDoor 'Microsoft.Cdn/profiles@2022-11-01-preview' = {
  name: resourceName
  location: 'global'
  properties: {
  }
  sku: {
    name: '${skuType}_AzureFrontDoor'
  }
}

// endpoints
module mod_endpoints 'endpoint.bicep' = [for (endpoint, index) in endpoints: {
  name: '${resourceName}-endpoint${index}-deploy'
  params: {
    endpoint: endpoint
    cdnProfileName: frontDoor.name
  }
}]

// origin group
