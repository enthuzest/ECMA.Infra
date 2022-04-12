resource "azurerm_servicebus_subscription" "ecma_sub" {
  name                = "ecma-${var.sub_environment}-sub"
  topic_id            = azurerm_servicebus_topic.sb_topic.id
  max_delivery_count  = 1
}

resource "azurerm_servicebus_subscription" "downstream_sub" {
  name                = "downstream-${var.sub_environment}-sub"
  topic_id            = azurerm_servicebus_topic.sb_topic.id
  max_delivery_count  = 1
}
