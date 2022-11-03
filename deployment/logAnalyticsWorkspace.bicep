targetScope = 'resourceGroup'

param asset string
param location string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: asset
  location: location
  tags: {
    displayName: 'Log Analytics'
    ProjectName: asset
  }
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 120
    features: {
      searchVersion: 1
      legacy: 0
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

output Id string = logAnalyticsWorkspace.id
