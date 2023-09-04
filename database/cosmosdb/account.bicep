
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

param roleAssignments array = []
param configuration object = {}

// local variables
var sqlDatabaseConfiguration = contains(configuration, 'sql') == false ? {} : configuration.sql

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

// add role assignments (if any)
module accountRoleAssignments '.account-role.bicep' = [for (assignment, index) in roleAssignments : {
  name: '${account.name}-roleAssignment${index}-deployment'
  params: {
    cosmosAccountName: account.name
    cosmosAccountResourceGroupName: resourceGroup().name
    roleName: assignment.roleName
    principalId: assignment.principalId
    scope: account.id
  }
}]

// create the sql databases
module sqlDatabases '.sqldatabase.bicep' = [for config in items(sqlDatabaseConfiguration) : {
  name: '${account.name}-${config.key}-deployment'
  params: {
    accountName: account.name
    databaseName: config.key
    containers: contains(config.value, 'containers') == false ? [] : config.value.containers
  }
}]
