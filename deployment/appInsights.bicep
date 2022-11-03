targetScope = 'resourceGroup'

param asset string
param location string

param logAnalyticsWorkspaceId string

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: asset
  location: location
  kind: 'string'
  tags: {
    displayName: 'AppInsight'
    ProjectName: asset
  }
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspaceId
  }
}

output InstrumentationKey string = appInsights.properties.InstrumentationKey
output ConnectionString string = appInsights.properties.ConnectionString
