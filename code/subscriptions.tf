resource "azurerm_servicebus_subscription" "ecma_sub" {
  name                = "ecma-${local.sub_evironment}-sub"
  resource_group_name = azurerm_resource_group.sb_primary.name
  namespace_name      = azurerm_servicebus_namespace.sb_namespace.name
  topic_name          = azurerm_servicebus_topic.sb_topic.name
  max_delivery_count  = 1
}

resource "azurerm_servicebus_subscription" "downstream_sub" {
  name                = "downstream-${local.sub_evironment}-sub"
  resource_group_name = azurerm_resource_group.sb_primary.name
  namespace_name      = azurerm_servicebus_namespace.sb_namespace.name
  topic_name          = azurerm_servicebus_topic.sb_topic.name
  max_delivery_count  = 1
}