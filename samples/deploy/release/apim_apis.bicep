targetScope = 'resourceGroup'

param apimName string
param appInsightsName string

resource apiManagement 'Microsoft.ApiManagement/service@2020-12-01' existing = {
  name: apimName
}

resource apiManagementLogger 'Microsoft.ApiManagement/service/loggers@2020-12-01' existing = {
  name: '${apimName}/${appInsightsName}'
}

// Petshop api Sample
resource petshopApi 'Microsoft.ApiManagement/service/apis@2020-12-01' = {
  name: 'petshop-api'
  parent: apiManagement
  properties: {
    path: 'petshop'
    apiRevision: '1'
    displayName: 'Petshop API'
    description: 'Petshop API Sample'
    subscriptionRequired: true
    serviceUrl: 'https://thijdemopetshop.azurewebsites.net/api'
    subscriptionKeyParameterNames: {
      header: 'api-key'
      query: 'api-key'
    }
    protocols: [
      'https'
    ]
  }
}

resource petshopApiPolicies 'Microsoft.ApiManagement/service/apis/policies@2020-12-01' = {
  name: 'policy'
  parent: petshopApi
  properties: {
    value: loadTextContent('./policies/petshopapi_policy.xml')
    format: 'rawxml'
  }
}

resource apiMonitoring 'Microsoft.ApiManagement/service/apis/diagnostics@2020-06-01-preview' = {
  name: 'applicationinsights'
  parent: petshopApi
  properties: {
    alwaysLog: 'allErrors'
    loggerId: apiManagementLogger.id  
    logClientIp: true
    httpCorrelationProtocol: 'W3C'
    verbosity: 'verbose'
    operationNameFormat: 'Url'
  }
}
