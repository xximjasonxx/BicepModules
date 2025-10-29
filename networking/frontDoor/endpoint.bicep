
param endpoint object
param cdnProfileName string

resource cdnProfile 'Microsoft.Cdn/profiles@2023-07-01-preview' existing = {
  name: cdnProfileName
}

resource res_endpoint 'Microsoft.Cdn/profiles/afdendpoints@2022-11-01-preview' = {
  name: '${endpoint.name}-endpoint'
  location: 'global'
  parent: cdnProfile
}
