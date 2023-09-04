
param cosmosDbAccountName string
param roleAssignmentId string
param roleDefinitionId string
param principalId string
param scope string

resource roleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2023-04-15' = {
  name: '${cosmosDbAccountName}/${roleAssignmentId}'

  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
    scope: scope
  }
}
