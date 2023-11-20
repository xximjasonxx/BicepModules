
param resourceName string
param location string

@minLength(1)
param addressSpacePrefixes array

param ddosProtectionPlanId string = ''
param subnets array = []

var subnet_resources = [for subnet in subnets: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.addressPrefix
  }
}]

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

    subnets: subnet_resources
  }
}

output resourceName string = vnet.name
output subnets object = reduce(vnet.properties.subnets, {}, (prev, cur) => union(prev, { '${cur.name}': {
  id: cur.id
}}))
