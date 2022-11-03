targetScope = 'resourceGroup'

param asset string
param location string

param functionName string

param storageAccountId string
param appServicePlanId string

@secure()
param appInsightsInstrumentationKey string
@secure()
param appInsightsConnectionString string

resource functionApp 'Microsoft.Web/sites@2020-12-01' = {
  name: asset
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'powershell'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME_VERSION'
          value: '~7.2'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsInstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${last(split(storageAccountId, '/'))};AccountKey=${listKeys(storageAccountId, '2021-09-01').keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${last(split(storageAccountId, '/'))};AccountKey=${listKeys(storageAccountId, '2021-09-01').keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(asset)
        }
      ]
      connectionStrings: [
      ]
    }
  }
}

resource function 'Microsoft.Web/sites/functions@2021-03-01' = {
  parent: functionApp
  name: functionName
  properties: {
    config: {
      bindings: [
        {
          name: 'Timer'
          type: 'timerTrigger'
          direction: 'in'
          schedule: '0 */10 * * * *'
        }
      ]
    }
    files: {
      'run.ps1': loadTextContent('../ps-test/run.ps1')
    }
  }
}

output functionId string = function.id
