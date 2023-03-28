targetScope = 'resourceGroup'

@minLength(3)
@maxLength(11)
param namePrefix string
param location string
param eventHubId string

var topicName = '${namePrefix}${uniqueString(resourceGroup().id)}-topic'
var subscriptionName = 'subSendToEventHubs'

resource topic 'Microsoft.EventGrid/topics@2020-06-01' = {
  name: topicName
  location: location
}

resource subscription 'Microsoft.EventGrid/eventSubscriptions@2020-06-01' = {
  scope: topic
  name: subscriptionName
  properties: {
    destination: {
      endpointType: 'EventHub'
      properties: {
        resourceId: eventHubId
      }
    }
    filter: {
      isSubjectCaseSensitive: false
    }
  }
}

output endpoint string = topic.properties.endpoint
