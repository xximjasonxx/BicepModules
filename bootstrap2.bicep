
targetScope = 'subscription'

module rg 'br:cradotesting01.azurecr.io/bicep/modules/general/resource-group:1.0.0' = {
  name: 'resource-group-deployment'
  params: {
    resourceName: 'rg-module-testing
  }
}
