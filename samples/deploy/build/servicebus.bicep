@minLength(3)
@maxLength(11)
param namePrefix string
param location string

var uniqueServiceBusNamespaceName = '${namePrefix}${uniqueString(resourceGroup().id)}-ns'
var policySendOnlyName = 'SendOnly'
var policySendListenName = 'SendListen'

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: uniqueServiceBusNamespaceName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {}
}

resource serviceBusPolicySendOnly 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2021-11-01' = {
  name: policySendOnlyName
  parent: serviceBusNamespace
  properties: {
    rights: [
      'Send'
    ]
  }
}

resource serviceBusPolicySendListen 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2021-11-01' = {
  name: policySendListenName
  parent: serviceBusNamespace
  properties: {
    rights: [
      'Send'
      'Listen'
    ]
  }
}

output serviceBusNamespaceName string = serviceBusNamespace.name
