
param webAppName string
param appSettings object

resource appSetting 'Microsoft.Web/sites/config@2022-09-01' = {
  name: '${webAppName}/appsettings'
  properties: appSettings
}
