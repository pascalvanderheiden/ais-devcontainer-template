targetScope = 'resourceGroup'

param apimName string
param appInsightsName string

resource apiManagement 'Microsoft.ApiManagement/service@2020-12-01' existing = {
  name: apimName
}

resource apiManagementLogger 'Microsoft.ApiManagement/service/loggers@2020-12-01' existing = {
  name: '${apimName}/${appInsightsName}'
}

resource apimApi 'Microsoft.ApiManagement/service/apis@2020-12-01' = {
  name: 'sample-api'
  parent: apiManagement
  properties: {
    path: 'sample-api'
    apiRevision: '1'
    displayName: 'Sample API'
    description: 'This is a sample API.'
    subscriptionRequired: false
    protocols: [
      'https'
    ]
  }
}

resource apiPolicies 'Microsoft.ApiManagement/service/apis/policies@2020-12-01' = {
  name: 'policy'
  parent: apimApi
  properties: {
    value: loadTextContent('./policies/api_policy.xml')
    format: 'rawxml'
  }
}

resource apiMonitoring 'Microsoft.ApiManagement/service/apis/diagnostics@2020-06-01-preview' = {
  name: 'applicationinsights'
  parent: apimApi
  properties: {
    alwaysLog: 'allErrors'
    loggerId: apiManagementLogger.id  
    logClientIp: true
    httpCorrelationProtocol: 'W3C'
    verbosity: 'verbose'
    operationNameFormat: 'Url'
  }
}
