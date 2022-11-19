
param keyVaultName string
param keyVaultResourceGroupName string = resourceGroup().name

param cosmosDbName string
param cosmosDbResourceGroupName string = resourceGroup().name

param secretName string

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = {
  name: cosmosDbName
  scope: resourceGroup(cosmosDbResourceGroupName)
}

var accountKey = listKeys(cosmosDb.id, cosmosDb.apiVersion).primaryMasterKey
var connectionString = 'AccountEndpoint=https://${cosmosDb.name}.documents.azure.com:443/;AccountKey=${accountKey}'

module accountConnectionStringSecret 'br:crbicepmodulesjx01.azurecr.io/microsoft.keyvault/vaults/secret:v1.0.0' = {
  name: 'account-connection-string-secret-deploy'
  scope: resourceGroup(keyVaultResourceGroupName)
  params: {
    keyVaultName: keyVaultName
    secretName: secretName
    secretValue: connectionString
  }
}
