
param keyVaultName string
param secretName string

@secure()
param secretValue string

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: secretName
  parent: keyVault

  properties: {
    value: secretValue
  }
}

output secretUri string = secret.properties.secretUri
output secretVersion string = secret.id
