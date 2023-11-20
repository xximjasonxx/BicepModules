targetScope = 'resourceGroup'

@secure()
param adminPassword string

param location string = resourceGroup().location

module virtualNetwork 'networking/virtualNetwork.bicep' = {
  name: 'virtual-network-deployment'
  params: {
    resourceName: 'vnet-network-test'
    location: location
    addressSpacePrefixes: [
      '10.0.0.0/16'
    ]

    subnets: [
      {
        name: 'webservers'
        addressPrefix: '10.0.0.0/24'
      }
    ]
  }
}

module networkInterface 'networking/networkInterface.bicep' = {
  name: 'network-interface-deployment'
  params: {
    resourceName: 'nic-vm-webserver'
    location: location
    attachedSubnetId: virtualNetwork.outputs.subnets.webservers.id
  }
}

//module virtualMachine 'compute/virtualMachine.bicep' = {
//  name: 'virtual-machine-deployment'
//  params: {
//    location: location
//    adminPasswordSecure: adminPassword
//  }
//}
