targetScope = 'resourceGroup'

param eventHubNamespace string

var eventHubName = 'eventhub'

resource eventHubNamespace_resource 'Microsoft.EventHub/namespaces@2018-01-01-preview' existing = {
  name: eventHubNamespace
}

resource eventHubNamespace_eventHub 'Microsoft.EventHub/namespaces/EventHubs@2017-04-01' = {
  parent: eventHubNamespace_resource
  name: eventHubName
  properties: {
    messageRetentionInDays: 1
    partitionCount: 2
  }
}

output eventHubId string = eventHubNamespace_eventHub.id
