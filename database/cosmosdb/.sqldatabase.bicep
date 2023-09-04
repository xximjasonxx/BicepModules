
param accountName string

param databaseName string
param containers array

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

resource containerResources 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = [for container in containers: {
  name: container.name
  parent: sqlDatabase
  properties: {
    resource: {
      id: container.name
      partitionKey: {
        paths: [
          container.partitionKeyPath
        ]
        kind: 'Hash'
      }
    }
  }
}]
