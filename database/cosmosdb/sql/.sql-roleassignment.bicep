param cosmosAccountId string
param roleName string
param roleAssignmentId string
param principalId string
param scope string

var supportedRoleDefinitions = {
  'Cosmos DB Built-in Data Reader': '00000000-0000-0000-0000-000000000001'
  'Cosmos DB Built-in Data Contributor': '00000000-0000-0000-0000-000000000002'
}

var cosmosDbAccountName = last(split(cosmosAccountId, '/'))
var roleId = supportedRoleDefinitions[roleName]

resource roleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2023-04-15' = {
  name: '${cosmosDbAccountName}/${roleAssignmentId}'

  properties: {
    principalId: principalId
    roleDefinitionId: '${cosmosAccountId}/sqlRoleDefinitions/${roleId}'
    scope: scope
  }
}
