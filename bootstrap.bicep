
module cosmos 'Microsoft.DocumentDB/account.bicep' = {
  name: 'CosmosDb-Deploy'
  params: {
    base_name: 'testdatabase-ym02'
    location: 'eastus2'
    sql_databases: [
      {
        name: 'testdatabase'
        containers: [
          {
            name: 'testcontainer'
            partition_keys: [
              '/id'
            ]
          }
        ]
      }
    ]
    rbac_assignments: [
      {
        principalId: 'c160ad2b-2298-4aab-bfa4-abd151a16849'
        roleDefinitionId: '5bd9cd88-fe45-4216-938b-f97437e15450'
      }
    ]
  }
}

/*resource account 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = {
  name: 'cosmosdb-testdatabase-ym02'
}

resource rbac_assign 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(assignment.principalId, '5bd9cd88-fe45-4216-938b-f97437e15450', resourceGroup().name, account.name)
  scope: account
  properties: {
    principalType: 'ServicePrincipal'
    roleDefinitionId: assignment.roleDefinitionId
    principalId: assignment.principalId
  }
}]*/
