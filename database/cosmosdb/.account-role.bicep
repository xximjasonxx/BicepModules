
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



resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosAccountName
  scope: resourceGroup(cosmosAccountResourceGroupName)
}


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
