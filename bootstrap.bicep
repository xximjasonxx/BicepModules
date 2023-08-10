
module storageAccount 'br:crbicepmodulesjx01.azurecr.io/microsoft.storage/account:1.1.0' = {
  name: 'sandbox-storageaccount-deploy'
  params: {
    baseName: 'testaccountjx01'
    queues: [
      {
        name: 'testqueue'
      }
    ]
  }
}
