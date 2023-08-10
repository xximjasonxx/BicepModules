
param storageAccountName string
param queueName string
param rbacAssignments array = []

resource sa 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

resource queueService 'Microsoft.Storage/storageAccounts/queueServices@2022-05-01' = {
  name: 'default'
  parent: sa
  properties: {
  }
}

resource queue 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-05-01' = {
  name: queueName
  parent: queueService
  properties: {
    metadata: {}
  }
}

resource roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for assignment in rbacAssignments: {
  name: guid(assignment.principalId, assignment.roleDefinitionId, resourceGroup().name, queueName)
  scope: queue
  properties: {
    principalType: 'ServicePrincipal'
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', assignment.roleDefinitionId)
    principalId: assignment.principalId
  }
}]
