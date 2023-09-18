
@maxLength(24)
param resourceName string
param location string

@allowed([
  'BlobStorage'
  'StorageV2'
])
param accountType string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
])
param storageSkuName string = 'Standard_LRS'

param blobConfiguration object = {}

//resources
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: resourceName
  location: location
  kind: accountType
  sku: {
    name: storageSkuName
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
  }
}

var containerList = contains(blobConfiguration, 'containers') ? blobConfiguration.containers : []
resource containers 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = [for container in containerList: {
  name: container.name
  parent: blobService
  properties: {
    publicAccess: contains(container, 'publicAccess') ? container.publicAccess : 'None'
  }
}]

// outputs
output resourceId string = storageAccount.id
output resourceName string = storageAccount.name
