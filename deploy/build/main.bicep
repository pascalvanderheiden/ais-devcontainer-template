// set the target scope for this file
targetScope = 'subscription'

@minLength(3)
@maxLength(11)

// set the params
param namePrefix string
param location string = deployment().location

// set local var
var resourceGroupName = '${namePrefix}-rg'

// Create a Resource Group
resource newRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

// Create a Storage Account
module stgModule '../build/storage.bicep' = {
  name: 'storageDeploy'
  scope: newRG
  params: {
    namePrefix: namePrefix
    location: location
  }
}

// Create Application Insights & Log Analytics Workspace
module appInsightsModule '../build/appinsights_loganalytics.bicep' = {
  name: 'appInsightsDeploy'
  scope: newRG
  params: {
    namePrefix: namePrefix
    location: location
  }
}

// Create API Management instance
module apimModule '../build/apim.bicep' = {
  name: 'apimDeploy'
  scope: newRG
  params: {
    namePrefix: namePrefix
    publisherEmail: 'me@example.com'
    publisherName: 'Me Company Ltd.'
    sku: 'Developer'
    location: location
    appInsightsName: appInsightsModule.outputs.appInsightsName
    appInsightsInstrKey: appInsightsModule.outputs.appInsightsInstrKey
  }
  dependsOn:[
    appInsightsModule
  ]
}

// Create Frontdoor
module frontDoorModule '../build/frontdoor_waf.bicep' = {
  name: 'frontDoorDeploy'
  scope: newRG
  params: {
    namePrefix: namePrefix
    apimGwUrl: '${apimModule.outputs.apimName}.azure-api.net'
    apimName: apimModule.outputs.apimName
  }
  dependsOn:[
    apimModule
  ]
}

// Create App Service Plan for Logic Apps (Standard)
module logicAppAspModule '../build/logicapp_asp.bicep' = {
  name: 'logicAppAspDeploy'
  scope: newRG
  params: {
    namePrefix: namePrefix
    location: location
  }
}

// Create App Service Plan for Azure Functions
module FunctionAppAspModule '../build/azurefunction_asp.bicep' = {
  name: 'FunctionAppAspDeploy'
  scope: newRG
  params: {
    namePrefix: namePrefix
    location: location
  }
}

// Create Logic Apps (Standard)
module logicAppModule '../build/logicapp.bicep' = {
  name: 'logicAppDeploy'
  scope: newRG
  params: {
    namePrefix: namePrefix
    location: location
    appInsightsInstrKey: appInsightsModule.outputs.appInsightsInstrKey
    appInsightsEndpoint: appInsightsModule.outputs.appInsightsEndpoint
    storageConnectionString: stgModule.outputs.storageConnectionString
    appServicePlanId: logicAppAspModule.outputs.appServicePlanIdLogicApp
  }
  dependsOn:[
    logicAppAspModule
    stgModule
    appInsightsModule
  ]
}

// Create Azure Function
module azureFunctionModule '../build/azurefunction.bicep' = {
  name: 'azureFunctionDeploy'
  scope: newRG
  params: {
    namePrefix: namePrefix
    location: location
    appInsightsInstrKey: appInsightsModule.outputs.appInsightsInstrKey
    storageConnectionString: stgModule.outputs.storageConnectionString
    appServicePlanId: FunctionAppAspModule.outputs.appServicePlanIdFunctionApp
  }
  dependsOn:[
    FunctionAppAspModule
    stgModule
    appInsightsModule
  ]
}

// Create Event Hub Namespace
module eventHubModule '../build/eventhub.bicep' = {
  name: 'eventHubDeploy'
  scope: newRG
  params: {
    namePrefix: namePrefix
    location: location
  }
  dependsOn:[
    stgModule
  ]
}

// Create Service Bus Namespace
module serviceBusModule '../build/servicebus.bicep' = {
  name: 'serviceBusDeploy'
  scope: newRG
  params: {
    namePrefix: namePrefix
    location: location
  }
}
