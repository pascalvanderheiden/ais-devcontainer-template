@minLength(3)
@maxLength(11)
param namePrefix string
param location string

var appServicePlanNameFunctionApp = '${namePrefix}-fa-asp'

resource serverFarmFunctionApp 'Microsoft.Web/serverfarms@2020-10-01' = {
  name: appServicePlanNameFunctionApp
  location: location
  sku: {
    name: 'Y1' 
    tier: 'Dynamic'
  }
}

output appServicePlanNameFunctionApp string = serverFarmFunctionApp.name
output appServicePlanIdFunctionApp string = serverFarmFunctionApp.id
