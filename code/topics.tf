resource "azurerm_servicebus_topic" "sb_topic" {
  name                = "root-${var.sub_environment}-tp"
  namespace_id        = azurerm_servicebus_namespace.sb_namespace.id
  enable_partitioning = true
}

resource "azurerm_role_assignment" "ecma_function_app_access" {
  scope                = azurerm_servicebus_topic.sb_topic.id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = azurerm_function_app.ecma_func_app.identity.0.principal_id
}

data "azuread_group" "developer_ad_group"{
  display_name = "learner-ad"
}

resource "azurerm_role_assignment" "developer_access" {
  scope                = azurerm_servicebus_topic.sb_topic.id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = data.azuread_group.developer_ad_group.object_id
}