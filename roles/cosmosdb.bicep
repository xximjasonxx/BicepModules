
@allowed([
  'Cosmos DB Account Reader Role'
  'Cosmos DB Operator'
  'CosmosBackupOperator'
  'DocumentDB Account Contributor'
])
param roleName string

param accountName string
param principalId string

@allowed([
  'ServicePrincipal'
  'User'
  'Group'
])
param principalType string = 'ServicePrincipal'

var roleIdNameLookup = {
  'Cosmos DB Account Reader Role': 'fbdf93bf-df7d-467e-a4d2-9458aa1360c8'
  'Cosmos DB Operator': '230815da-be43-4aae-9cb4-875f7bd000aa'
  'CosmosBackupOperator': 'db7b14f2-5adf-42da-9f96-f2ee17bab5cb'
  'DocumentDB Account Contributor': '5bd9cd88-fe45-4216-938b-f97437e15450'
}

// get the resource
resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: accountName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(cosmosAccount.name, roleName, principalId)
  scope: cosmosAccount
  properties: {
    principalId: principalId
    principalType: principalType
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleIdNameLookup[roleName])
  }
}
