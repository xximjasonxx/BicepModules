
param cosmos_db_account_name string
param sql_database_name string
param name string

@minLength(1)
param partition_keys array
param unique_keys array = []

resource cosmosdb 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = {
  name: cosmos_db_account_name
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-08-15' existing = {
  name: sql_database_name
  parent: cosmosdb
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-08-15' = {
  name: name
  parent: database
  properties: {
    resource: {
      id: name
      partitionKey: {
        paths: partition_keys
        kind: 'Hash'
      }
      uniqueKeyPolicy: {
        uniqueKeys: unique_keys
      }
    }
  }
}
