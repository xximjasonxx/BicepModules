
param resourceName string
param resourceGroupName string = resourceGroup().name
param location string
param appServicePlanId string

@allowed([
  'none'
  'system'
  'managed'
])
param identityType string = 'none'
param managedIdentityId string = ''

@allowed([
  '1'
  '2'
  '3'
  '4'
])
param runtimeVersion string = '4'
param runFromPackage bool = false 

@allowed([
  'linux'
  'windows'
])
param osType string = 'windows'

param storageAccountName string
param storageAccountResourceGroup string = resourceGroup().name
param appSettings array = []

// create the resource
module functionApp '.functionApp.bicep' = {
  name: '${resourceName}-deployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    resourceName: resourceName
    location: location
    appServicePlanId: appServicePlanId
    identityType: identityType
    managedIdentityId: managedIdentityId
    runtimeVersion: runtimeVersion
    runFromPackage: runFromPackage
    osType: osType
    storageAccountName: storageAccountName
    storageAccountResourceGroup: storageAccountResourceGroup
    appSettings: appSettings
  }
}

output resourceId string = functionApp.outputs.resourceId
output resourceName string = functionApp.outputs.resourceName
output principalId string = identityType == 'system' ? functionApp.outputs.principalId : ''
