
param keyVaultName string
param secretName string

@secure()
param secretValue string

resource keyVaullt 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: secretName
  parent: keyVaullt
  properties: {
    value: secretValue
  }
}
