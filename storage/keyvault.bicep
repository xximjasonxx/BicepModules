
targetScope = 'resourceGroup'

param resourceName string
param location string
param tenantId string = tenant().tenantId
param allowPublicAccess bool = false
param softDeleteRetentionInDays int = 90
param enableRbacAuthorization bool = false

param accessPolicies array = []

@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

// variables
var finalAccessPolicies = [for item in accessPolicies: {
  objectId: item.objectId
  tenantId: contains(item, 'tenantId') ? item.tenantId : tenantId
  permissions: {
    keys: contains(item, 'keyPermissions') ? item.keyPermissions : []
    secrets: contains(item, 'secretPermissions') ? item.secretPermissions : []
    certificates: contains(item, 'certificatePermissions') ? item.certificatePermissioons : []
    storage: contains(item, 'storagePermissions') ? item.storagePermissions : []
  }
}]

// resource
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: resourceName
  location: location

  properties: {
    sku: {
      name: skuName
      family: 'A'
    }
    tenantId: tenantId
    publicNetworkAccess: allowPublicAccess ? 'Enabled' : 'Disabled'
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enableRbacAuthorization: enableRbacAuthorization
    accessPolicies: finalAccessPolicies
  }
}
