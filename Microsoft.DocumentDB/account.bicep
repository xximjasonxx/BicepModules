
param base_name string
param location string

param sql_databases array = []
param rbac_assignments array = []

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: 'cosmosdb-${base_name}'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    publicNetworkAccess: 'Enabled'
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
  }
}

module sqlDatabase 'br:crbicepmodulesjx01.azurecr.io/microsoft.documentdb/account/sql-database:1.1.0' = [for database in sql_databases: {
  name: 'sql-database-${database.name}-deploy'
  params: {
    cosmosdb_account_name: account.name
    location: location
    name: database.name
    containers: database.containers
  }
}]

// rbac assignments
resource rbac_assigns 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for assignment in rbac_assignments: {
  name: guid(assignment.principalId, assignment.roleDefinitionId, resourceGroup().name, account.name)
  scope: account
  properties: {
    principalType: 'ServicePrincipal'
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', assignment.roleDefinitionId)
    principalId: assignment.principalId
  }
}]

// outputs
output cosmosdb_name string = account.name
output cosmosdb_endpoint string = account.properties.documentEndpoint
