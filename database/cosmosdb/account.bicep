
param resourceName string
param location string

@allowed([
  'GlobalDocumentDB'
  'MongoDB'
  'Parse'
])
param kind string = 'GlobalDocumentDB'

param allowPublicAccess bool = true
param isServerless bool = false
param configuration object = {}

// local variables
var sqlDatabaseConfiguration = contains(configuration, 'sql') == false ? {} : configuration.sql

var sqlRoleAssignments = contains(sqlDatabaseConfiguration, 'roleAssignments') == false ? [] : sqlDatabaseConfiguration.roleAssignments

var capabilitities = isServerless == false ? [] : [
  {
    name: 'EnableServerless'
  }
]

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: resourceName

  location: location
  kind: kind
  properties: {
    publicNetworkAccess: allowPublicAccess ? 'Enabled' : 'Disabled'
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    capabilities: capabilitities
  }
}

// create the sql databases
module sqlDatabases 'sql/database.bicep' = [for config in items(sqlDatabaseConfiguration) : {
  name: '${account.name}-${config.key}-deployment'
  params: {
    accountName: account.name
    databaseName: config.key
    collections: contains(config.value, 'containers') == false ? [] : config.value.containers
    roleAssignments: contains(config.value, 'roleAssignments') == false ? [] : config.value.roleAssignments
  }
}]

// create the sql role assignments
module sqlRoleAssignmentResources 'sql/.sql-roleassignment.bicep' = [for (assignment, index) in sqlRoleAssignments : {
  name: '${account.name}-sql-roleAssignment${index}-deployment'
  params: {
    cosmosAccountId: account.id
    roleName: assignment.roleName
    roleAssignmentId: guid('sql-role-definition-', assignment.principalId, account.name,assignment.roleName)
    principalId: assignment.principalId
    scope: account.id
  }
}]
