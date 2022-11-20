
param keyVaultName string
param keyVaultResourceGroupName string = resourceGroup().name

param signalrServiceName string
param signalrSerrviceResourceGroupName string = resourceGroup().name

param secretName string

resource signalr 'Microsoft.SignalRService/signalR@2022-08-01-preview' existing = {
  name: signalrServiceName
  scope: resourceGroup(signalrSerrviceResourceGroupName)
}

var connectionString = listKeys(signalr.id, signalr.apiVersion).primaryConnectionString

module accountConnectionStringSecret 'br:crbicepmodulesjx01.azurecr.io/microsoft.keyvault/vaults/secret:v1.0.0' = {
  name: 'signalr-connection-string-secret-deploy'
  scope: resourceGroup(keyVaultResourceGroupName)
  params: {
    keyVaultName: keyVaultName
    secretName: secretName
    secretValue: connectionString
  }
}
