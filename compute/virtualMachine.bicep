targetScope = 'resourceGroup'
var appName = 'testapp'

param location string
param adminUsername string = 'azureuser'

@secure()
param adminPasswordSecure string

resource virtualMachine 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: 'vm-${appName}-webserver'
  location: location

  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2as_v4'
    }

    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }

      osDisk: {
        osType: 'Linux'
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
      networkInterfaceConfigurations: [
        {
          name: 'nic-${appName}-webserver'
          properties: {
            deleteOption: 'Delete'
            ipConfigurations: [
              {
                name: 'ipconfig-${appName}-webserver'
                properties: {
                  privateIPAddressVersion: 'IPv4'
                }
              }  
            ]
          }
        }
      ]
    }

    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: 'https://diag${appName}sa.blob.core.windows.net/'
      }
    }
  }
}
