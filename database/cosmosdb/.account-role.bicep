
@allowed([
  'Cosmos DB Built-in Data Reader'
  'Cosmos DB Built-in Data Contributor'
])
param roleName string

param cosmosAccountName string
param cosmosAccountResourceGroupName string = resourceGroup().name
param principalId string
param scope string

var cosmosAccountResourceId = resourceId(cosmosAccountResourceGroupName, 'Microsoft.DocumentDB/databaseAccounts', cosmosAccountName)
var roleAssignmentId = guid('sql-role-definition-', principalId, cosmosAccountResourceId)

var supportedRoleDefinitions = {
  'Cosmos DB Built-in Data Reader': '00000000-0000-0000-0000-000000000001'
  'Cosmos DB Built-in Data Contributor': '00000000-0000-0000-0000-000000000002'
}

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosAccountName
  scope: resourceGroup(cosmosAccountResourceGroupName)
}

var targetRoleDefinitionId = '${cosmosAccount.id}/sqlRoleDefinitions/${supportedRoleDefinitions[roleName]}'
module roleAssignment '.sql-roleassignment.bicep' = {
  name: '${cosmosAccountName}-sql-role-assignment-deployment'
  scope: resourceGroup(cosmosAccountResourceGroupName)

  params: {
    cosmosDbAccountName: cosmosAccountName
    roleAssignmentId: roleAssignmentId
    principalId: principalId
    roleDefinitionId: targetRoleDefinitionId
    scope: scope
  }
}
