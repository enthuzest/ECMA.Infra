resource "azurerm_servicebus_topic" "sb_topic" {
  name                = "root-${var.sub_environment}-tp"
  resource_group_name = azurerm_resource_group.sb_primary.name
  namespace_name      = azurerm_servicebus_namespace.sb_namespace.name

  enable_partitioning = true
}
