
targetScope = 'subscription'

param resourceName string
param location string

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceName
  location: location
}
