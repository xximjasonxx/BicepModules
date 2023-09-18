
param webAppName string
param settingName string

@secure()
param settingValue string

var appSettingsResourceId = resourceId('Microsoft.Web/sites/config', webAppName, 'appsettings')
var currentAppSettings = list(appSettingsResourceId, '2022-09-01').properties
var finalAppSettings = union(currentAppSettings, { '${settingName}': settingValue })

module appsettings '.appsetting.bicep' = {
  name: '${webAppName}-${settingName}-deployment'
  params: {
    webAppName: webAppName
    appSettings: finalAppSettings
  }
}
