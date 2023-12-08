
param resourceName string
param location string
param networkInterfaceId string

param adminUsername string

@secure()
param adminPasswordSecure string

@allowed([
  'Linux'
  'Windows'
])
param osType string = 'Linux'

// image information
param imagePublisher string
param imageOffer string
param imageSku string
param imageVersion string

// create the block to be used
var imageBlock = {
  publisher: imagePublisher
  offer: imageOffer
  sku: imageSku
  version: imageVersion
}

param vmSize string

var hardwareProfileBlock = {
  vmSize: vmSize
}

var linuxConfiguration = osType == 'Linux' ? {
  disablePasswordAuthentication: false
  provisionVMAgent: true
  patchSettings: {
    patchMode: 'AutomaticByPlatform'
    automaticByPlatformSettings: {
      bypassPlatformSafetyChecksOnUserSchedule: true
    }
    assessmentMode: 'AutomaticByPlatform'
  }

  enableVMAgentPlatformUpdates: false
} : null

var windowsConfiguration = osType == 'Windows' ? {
  provisionVMAgent: true
  enableAutomaticUpdates: true
  patchSettings: {
      patchMode: 'AutomaticByPlatform'
      automaticByPlatformSettings: {
          rebootSetting: 'IfRequired'
          bypassPlatformSafetyChecksOnUserSchedule: false
      }
      assessmentMode: 'ImageDefault'
      enableHotpatching: true
  }

  enableVMAgentPlatformUpdates: false
} : null

resource virtualMachine 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: resourceName
  location: location

  properties: {
    hardwareProfile: hardwareProfileBlock

    storageProfile: {
      imageReference: imageBlock

      osDisk: {
        osType: osType
        name: 'disk-${resourceName}-osdisk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        deleteOption: 'Delete'
      }
    }

    osProfile: {
      computerName: resourceName
      adminUsername: adminUsername
      adminPassword: adminPasswordSecure
      linuxConfiguration: linuxConfiguration
      windowsConfiguration: windowsConfiguration
    }

    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceId
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
  }
}
