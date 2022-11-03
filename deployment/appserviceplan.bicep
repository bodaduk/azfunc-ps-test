targetScope = 'resourceGroup'

param asset string
param location string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: asset
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
    family: 'Y'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true
  }
}

output Id string = appServicePlan.id
