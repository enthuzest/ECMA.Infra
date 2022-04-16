locals {
  application_name      = "ecma"
  app_name_with_env     = "${local.application_name}-${var.environment}"
  app_name_with_sub_env = "${local.application_name}-${var.sub_environment}"
  location              = var.location
  service_bus_namespace = "ecma-servicebus"
}

resource "azurerm_resource_group" "primary" {
  name     = local.app_name_with_sub_env
  location = local.location
}

resource "azurerm_storage_account" "sa" {
  name                     = "${local.application_name}2704${var.sub_environment}"
  resource_group_name      = azurerm_resource_group.primary.name
  location                 = azurerm_resource_group.primary.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "asp" {
  name                = "${local.app_name_with_sub_env}-asp"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  os_type             = "Windows"
  sku_name            = "S1"
}

resource "azurerm_application_insights" "ai" {
  name                = "${local.app_name_with_sub_env}-ai"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  application_type    = "web"
}

resource "azurerm_function_app" "ecma_func_app" {
  name                       = local.app_name_with_sub_env
  location                   = azurerm_resource_group.primary.location
  resource_group_name        = azurerm_resource_group.primary.name
  app_service_plan_id        = azurerm_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  version                    = "~4"

  app_settings = {
    #ServiceBusConnection           = "Endpoint=sb://${azurerm_servicebus_namespace.sb_namespace.name}.servicebus.windows.net/;Authentication=Managed Identity"
    ServiceBusConnection           = "${azurerm_servicebus_namespace.sb_namespace.default_primary_connection_string}"
    ConnectionString               = "Server=${azurerm_mssql_server.primary_server.name}.database.windows.net;Database=${azurerm_mssql_database.primary_db.name};Authentication=Active Directory Managed Identity"
    EcmaTopicName                  = "${azurerm_servicebus_topic.sb_topic.name}"
    EcmaSubscription               = "${azurerm_servicebus_subscription.ecma_sub.name}"
    WEBSITE_RUN_FROM_PACKAGE       = 1
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.ai.instrumentation_key
    FUNCTIONS_WORKER_RUNTIME       = "dotnet"
  }

  site_config {
    always_on = "true"
  }

  identity {
    type = "SystemAssigned"
  }
}
