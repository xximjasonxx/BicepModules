
param keyVaultName string
param keyVaultResourceGroupName string = resourceGroup().name

param cognitiveServicesName string
param cognitiveServicesResourceGroupName string = resourceGroup().name

param secretName string

resource cognitiveService 'Microsoft.CognitiveServices/accounts@2022-10-01' existing = {
  name: cognitiveServicesName
  scope: resourceGroup(cognitiveServicesResourceGroupName)
}

var accountKey = listKeys(cognitiveService.id, cognitiveService.apiVersion).key1
module accountConnectionStringSecret 'br:crbicepmodulesjx01.azurecr.io/microsoft.keyvault/vaults/secret:v1.0.0' = {
  name: 'cognitive-service-account-key-secret-deploy'
  scope: resourceGroup(keyVaultResourceGroupName)
  params: {
    keyVaultName: keyVaultName
    secretName: secretName
    secretValue: accountKey
  }
}
