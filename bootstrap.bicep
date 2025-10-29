targetScope = 'resourceGroup'

module frontdoor 'networking/frontDoor/frontdoor.bicep' = {
  name: 'front-door-deployment'
  params: {
    resourceName: 'fd-arkansas-jx02'
  }
}
