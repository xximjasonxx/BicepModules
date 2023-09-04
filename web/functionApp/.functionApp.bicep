
param resourceName string
param location string
param appServicePlanId string
param identityType string
param managedIdentityId string
param runtimeVersion string
param runFromPackage bool
param osType string
param storageAccountName string
param storageAccountResourceGroup string
param appSettings array

// get the access key for the storage account
resource backingStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
  scope: resourceGroup(storageAccountResourceGroup)
}

// define variables
var identityBlock = identityType == 'none' ? null : (identityType == 'system' ? {
  type: 'SystemAssigned'
} : {
  type: 'UserAssigned'
  userAssignedIdentities: {
    '${managedIdentityId}': {}
  }
})

var appKind = osType == 'linux' ? 'functionapp,linux' : 'functionapp'
var extensionRuntimeVersion = '~${runtimeVersion}'
var storageAccountKey = listKeys(backingStorageAccount.id, '2022-05-01').keys[0].value
var storageAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${backingStorageAccount.name};AccountKey=${storageAccountKey};EndpointSuffix=${environment().suffixes.storage}'

var standardAppSettings = [
  {
    name: 'AzureWebJobsStorage'
    value: storageAccountConnectionString
  }
  {
    name: 'FUNCTIONS_EXTENSION_VERSION'
    value: extensionRuntimeVersion
  }
]

var runFromPackageAppSettings = !runFromPackage ? [] : [
  {
    name: 'WEBSITE_RUN_FROM_PACKAGE'
    value: '1'
  }
]

var finalAppSettings = union(
  standardAppSettings,
  runFromPackageAppSettings,
  appSettings
)

// create the function app
resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: resourceName
  location: location
  kind: appKind
  identity: identityBlock

  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      appSettings: finalAppSettings
      linuxFxVersion: 'DOTNET|6.0'
    }
    httpsOnly: true
  }
}

// outputs
output principalId string = functionApp.identity.principalId
output resourceName string = functionApp.name
output resourceId string = functionApp.id
