
param resourceName string
param location string

@allowed([
  'Y1'
  'EP1'
])
param skuName string = 'Y1'

@allowed([
  'Dynamic'
  'ElasticPremium'
])
param skuTier string = 'Dynamic'

@allowed([
  'functionapp'
  'app'
])
param kind string = 'functionapp'

@allowed([
  'windows'
  'linux'
])
param os string = 'windows'

// variables
var varKind = os == 'windows' ? kind : '${kind},linux'

// resources
resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: resourceName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  kind: varKind

  properties: {
    reserved: os == 'linux'
  }
}

output resourceId string = plan.id
