
param accountName string
param databaseName string
param collectionName string
param partitionKeyPaths array
param roleAssignments array

// get reference to account
resource account 'Microsoft.DocumentDB/databaseAccounts@2015-04-08' existing = {
  name: accountName
}

// get reference to database
resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' existing = {
  name: databaseName
  parent: account
}

resource collection 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = {
  name: collectionName
  parent: database
  properties: {
    resource: {
      id: collectionName
      partitionKey: {
        paths: partitionKeyPaths
        kind: 'Hash'
      }
    }
  }
}

module collectionRoleAssignments '.sql-roleassignment.bicep' = [for (assignment, index) in roleAssignments: {
  name: '${collectionName}-${index}-deployment'
  params: {
    cosmosAccountId: account.id
    roleName: assignment.roleName
    roleAssignmentId: guid('sql-role-definition-', assignment.principalId, accountName, databaseName, collectionName, assignment.roleName)
    principalId: assignment.principalId
    scope: '${account.id}/dbs/${databaseName}/colls/${collectionName}'
  }
}]
