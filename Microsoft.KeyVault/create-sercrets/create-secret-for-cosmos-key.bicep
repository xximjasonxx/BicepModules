
param keyVaultName string
param keyVaultResourceGroupName string = resourceGroup().name

param cosmosDbName string
param cosmosDbResourceGroupName string = resourceGroup().name

param secretName string

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = {
  name: cosmosDbName
  scope: resourceGroup(cosmosDbResourceGroupName)
}

module accountKeySecret 'br:crbicepmodulesjx01.azurecr.io/microsoft.keyvault/vaults/secret:v1.0.0' = {
  name: 'account-key-secret-deploy'
  scope: resourceGroup(keyVaultResourceGroupName)
  params: {
    keyVaultName: keyVaultName
    secretName: secretName
    secretValue: listKeys(cosmosDb.id, cosmosDb.apiVersion).primaryMasterKey
  }
}
