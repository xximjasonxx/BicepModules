
param resourceName string
param location string = resourceGroup().location
param networkInterfaceId string

@allowed([
  '8'
  '9'
])
param redhatVersion string = '8'
param adminUsername string = 'azureuser'

@secure()
param adminPasswordSecure string

@allowed([
  'Small'
  'Medium'
  'Large'
])
param vmSize string = 'Small'

// create the block to indicate which linux image to use
var imageBlocks = {
  '8': {
    publisher: 'RedHat'
    offer: 'RHEL'
    sku: '8_8'
    version: 'latest'
  }

  '9': {
    publisher: 'RedHat'
    offer: 'RHEL'
    sku: '9_3'
    version: 'latest'
  }
}

// map the size string to the support sizes
var vmSizeActual = vmSize == 'Small' ? 'Standard_D2as_v4' : vmSize == 'Medium' ? 'Standard_D4as_v4' : 'Standard_D8as_v4'

module virtualMachine 'br:cradotesting01.azurecr.io/bicep/modules/compute/virtual-machine:1.0.0' = {
  name: 'create-linux-vm-deployment'
  params: {
    resourceName: resourceName
    location: location
    adminUsername: adminUsername
    adminPasswordSecure: adminPasswordSecure
    osType: 'Linux'
    imagePublisher: imageBlocks[redhatVersion].publisher
    imageOffer: imageBlocks[redhatVersion].offer
    imageSku: imageBlocks[redhatVersion].sku
    imageVersion: imageBlocks[redhatVersion].version
    networkInterfaceId: networkInterfaceId
    vmSize: vmSizeActual
  }
}
