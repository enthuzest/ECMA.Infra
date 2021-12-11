locals{
    application_name        = "ecma"
    app_name_with_local_env = "${local.application_name}-${var.sub_environment}"
    location                = var.location
    service_bus_namespace   = "ecma-servicebus"
}

resource "azurerm_resource_group" "primary" {
  name      = local.app_name_with_local_env
  location  = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = "${local.application_name}2704${var.sub_environment}"
  resource_group_name      = azurerm_resource_group.primary.name
  location                 = azurerm_resource_group.primary.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "asp" {
  name                = "${app_name_with_local_env}-asp"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_function_app" "ecma_func_app" {
  name                       = local.app_name_with_local_env
  location                   = azurerm_resource_group.primary.location
  resource_group_name        = azurerm_resource_group.primary.name
  app_service_plan_id        = azurerm_app_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
}