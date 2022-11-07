targetScope = 'resourceGroup'

param asset string
param location string

module storage 'storage.bicep' = {
  name: 'storage'
  params: {
    asset: asset
    location: location
  }
}

module logAnalyticsWorkspace 'logAnalyticsWorkspace.bicep' = {
  name: 'logAnalyticsWorkspace'
  params: {
    asset: asset
    location: location
  }
}

module appInsights 'appInsights.bicep' = {
  name: 'appInsights'
  params: {
    asset: asset
    location: location
    logAnalyticsWorkspaceId: logAnalyticsWorkspace.outputs.Id
  }
}

module appServicePlan 'appserviceplan.bicep' = {
  name: 'appServicePlan'
  params: {
    asset: asset
    location: location
  }
}

module functionApp 'functionapp.bicep' = {
  name: 'functionApp'
  params: {
    asset: asset
    location: location
    functionName: 'ps-test'
    storageAccountId: storage.outputs.Id
    appServicePlanId: appServicePlan.outputs.Id
    appInsightsInstrumentationKey: appInsights.outputs.InstrumentationKey
    appInsightsConnectionString: appInsights.outputs.ConnectionString
  }
}
