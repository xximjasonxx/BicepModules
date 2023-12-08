
param resourceName string
param location string = resourceGroup().location
param networkInterfaceId string

@allowed([
  '2022-dc'
])
param windowsVersion string = '2022-dc'
param adminUsername string = 'azureuser'

@secure()
param adminPassword string

@allowed([
  'Small'
  'Medium'
  'Large'
])
param vmSize string = 'Small'

// create the block to indicate which linux image to use
var imageBlocks = {
  '2022-dc': {
    publisher: 'MicrosoftWindowsServer'
    offer: 'WindowsServer'
    sku: '2022-datacenter-azure-edition-hotpatch'
    version: '20348.1850.230707'
  }
}

var vmSizeActual = vmSize == 'Small' ? 'Standard_D2as_v4' : vmSize == 'Medium' ? 'Standard_D4as_v4' : 'Standard_D8as_v4'

module virtualMachine 'br:cradotesting01.azurecr.io/bicep/modules/compute/virtual-machine:1.0.0' = {
  name: 'create-linux-vm-deployment'
  params: {
    resourceName: resourceName
    location: location
    adminUsername: adminUsername
    adminPasswordSecure: adminPasswordSecure
    osType: 'Windows'
    imagePublisher: imageBlocks[redhatVersion].publisher
    imageOffer: imageBlocks[redhatVersion].offer
    imageSku: imageBlocks[redhatVersion].sku
    imageVersion: imageBlocks[redhatVersion].version
    networkInterfaceId: networkInterfaceId
    vmSize: vmSizeActual
  }
}
