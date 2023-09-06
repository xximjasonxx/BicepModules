
param accountName string

param databaseName string
param collections array
param roleAssignments array

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = {
  name: accountName
  scope: resourceGroup()
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' = {
  name: databaseName
  parent: account
  properties: {
    resource: {
      id: databaseName
    }
  }
}

module databaseRoleAssignments '.sql-roleassignment.bicep' = [for (assignment, index) in roleAssignments: {
  name: '${databaseName}-${index}-deployment'
  params: {
    cosmosAccountId: account.id
    roleName: assignment.roleName
    roleAssignmentId: guid('sql-role-definition-', assignment.principalId, accountName, databaseName, assignment.roleName)
    principalId: assignment.principalId
    scope: '${account.id}/dbs/${databaseName}'
  }
}]

module collectionResources 'collection.bicep' = [for (collection, index) in collections: {
  name: '${databaseName}-${collection.name}${index}-deployment'
  params: {
    accountName: accountName
    databaseName: databaseName
    collectionName: collection.name
    partitionKeyPaths: [collection.partitionKeyPath]
    roleAssignments: contains(collection, 'roleAssignments') ? collection.roleAssignments : []
  }
}]
