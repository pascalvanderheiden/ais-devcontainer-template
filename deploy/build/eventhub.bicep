@minLength(3)
@maxLength(11)
param namePrefix string
param location string

var eventHubNamespace = '${namePrefix}${uniqueString(resourceGroup().id)}-eh-ns'

resource eventHubNamespace_resource 'Microsoft.EventHub/namespaces@2018-01-01-preview' = {
  name: eventHubNamespace
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    isAutoInflateEnabled: true
    maximumThroughputUnits: 7
  }
}

output eventHubNamespaceName string = eventHubNamespace_resource.name
