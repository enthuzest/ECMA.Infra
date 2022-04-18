resource "azurerm_resource_group" "sb_primary" {
  name     = local.service_bus_namespace
  location = var.location
}

resource "azurerm_servicebus_namespace" "sb_namespace" {
  name                = "ecma-servicebus-namespace"
  location            = azurerm_resource_group.sb_primary.location
  resource_group_name = azurerm_resource_group.sb_primary.name
  sku                 = "Standard"

  tags = var.tags
}