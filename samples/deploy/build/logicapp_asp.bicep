@minLength(3)
@maxLength(11)
param namePrefix string
param location string

var appServicePlanNameLogicApp = '${namePrefix}-la-asp'

resource serverFarmLogicApp 'Microsoft.Web/serverfarms@2020-10-01' = {
  name: appServicePlanNameLogicApp
  location: location
  sku: {
    name: 'WS1'
    capacity: 1
  }
}

output appServicePlanNameLogicApp string = serverFarmLogicApp.name
output appServicePlanIdLogicApp string = serverFarmLogicApp.id
