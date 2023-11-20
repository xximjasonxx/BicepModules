
param resourceName string
param location string

param attachedSubnetId string

resource networkInterface 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: resourceName
  location: location

  properties: {
    ipConfigurations: [
      {
        name: 'private-configuration'
        properties: {
          privateIPAddressVersion: 'IPv4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: attachedSubnetId
          }
        }
      }
    ]
  }
}

output privateIpAddress string = networkInterface.properties.ipConfigurations[0].properties.privateIPAddress
output resourceId string = networkInterface.id
