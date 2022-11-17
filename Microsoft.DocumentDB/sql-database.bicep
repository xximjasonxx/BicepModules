
param cosmosdb_account_name string
param name string
param location string

param containers array = []

resource cosmosdb 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = {
  name: cosmosdb_account_name
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-08-15' = {
  name: name
  location: location
  parent: cosmosdb

  properties: {
    resource: {
      id: name
    }
  }
}

module created_containers 'br:crbicepmodulesjx01.azurecr.io/microsoft.documentdb/account/sql-database/container:1.0.0' = [for container in containers: {
  name: '${name}-${container.name}-deploy'
  params: {
    name: container.name
    sql_database_name: sqlDatabase.name
    cosmos_db_account_name: cosmosdb_account_name
    partition_keys: container.partition_keys
    unique_keys: contains(container, 'unique_keys') ? container.unique_keys : []
  }
}]
