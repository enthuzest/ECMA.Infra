resource "azurerm_servicebus_topic" "sb_topic" {
  name                = "root-${var.sub_environment}-tp"
  namespace_id        = azurerm_servicebus_namespace.sb_namespace.id
  enable_partitioning = true
}
