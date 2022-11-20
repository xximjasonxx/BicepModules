
param baseName string
param location string

resource signalr 'Microsoft.SignalRService/signalR@2022-08-01-preview' = {
  name: 'sigr-${baseName}'
  location: location
  sku: {
    name: 'Free_F1'
  }
  properties: {
    features: [
      {
        flag: 'ServiceMode'
        value: 'Serverless'
      }
    ]
  }
}

// outputs
output signalr_name string = signalr.name
