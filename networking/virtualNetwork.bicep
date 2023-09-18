
param resourceName string
param location string

@minLength(1)
param addressSpacePrefixes array

param ddosProtectionPlanId string = ''
param subnets array = []

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: resourceName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressSpacePrefixes
    }

    ddosProtectionPlan: ddosProtectionPlanId == '' ? null : {
      id: ddosProtectionPlanId
    }

    subnets: [
      {
        name: 'privateEndpoints'
        properties: {
          addressPrefix: '10.0.0.0/24'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

output resourceName string = vnet.name
