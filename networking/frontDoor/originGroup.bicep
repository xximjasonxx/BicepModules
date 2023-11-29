
param endpoint object
param cdnProfileName string

resource cdnProfile 'Microsoft.Cdn/profiles@2023-07-01-preview' existing = {
  name: cdnProfileName
}

resource originGroup 'Microsoft.Cdn/profiles/originGroups@2023-07-01-preview' = {
  name: '${endpoint.name}OriginGroup'
  parent: cdnProfile

  properties: {
  }
}

var origins = contains(endpoint, 'origins') ? endpoint.origins : [];
resource res_origins 'Microsoft.Cdn/profiles/originGroups/origins@2023-07-01-preview' = [for origin in origins: {
  name: origin.name
}]
