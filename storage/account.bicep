
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

//resources
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: resourceName
  location: location
  kind: accountType
  sku: {
    name: storageSkuName
  }
}

// outputs
output resourceId string = storageAccount.id
