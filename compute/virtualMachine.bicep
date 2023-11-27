targetScope = 'resourceGroup'
var appName = 'testapp'

param location string
param adminUsername string = 'azureuser'

@secure()
param adminPasswordSecure string

param networkInterfaceId string

@allowed([
  'Linux'
  'Windows'
])
param osType string = 'Linux'

var imageBlock = osType == 'Linux' ? {
  publisher: 'Canonical'
  offer: '0001-com-ubuntu-server-focal'
  sku: '20_04-lts-gen2'
  version: 'latest'
} : {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2019-Datacenter'
  version: 'latest'
}

@allowed([
  'Small'
  'Medium'
  'Large'
])
param vmSize string = 'Small'

var hardwareProfileBlock = {
  vmSize: vmSize == 'Small' ? 'Standard_D2as_v4' : vmSize == 'Medium' ? 'Standard_D4as_v4' : 'Standard_D8as_v4'
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: 'vm-${appName}-webserver'
  location: location

  properties: {
    hardwareProfile: hardwareProfileBlock

    storageProfile: {
      imageReference: imageBlock

      osDisk: {
        osType: osType
        name: 'disk-${appName}-webserver-osdisk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        deleteOption: 'Delete'
      }
      
      diskControllerType: 'SCSI'
    }

    osProfile: {
      computerName: 'vm-${appName}-webserver'
      adminUsername: adminUsername
      adminPassword: adminPasswordSecure
      linuxConfiguration: {
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
      }
    }

    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
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
