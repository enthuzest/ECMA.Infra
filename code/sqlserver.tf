resource "azurerm_sql_server" "primary_server" {
  name                         = local.app_name_with_env
  resource_group_name          = azurerm_resource_group.primary.name
  location                     = azurerm_resource_group.primary.location
  version                      = "12.0"
  administrator_login          = "azureadmin"
  administrator_login_password = "Welcome@1234"

  tags = tomap(var.tags)
}

resource "azurerm_sql_database" "primary_db" {
  name                = local.app_name_with_sub_env
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location
  server_name         = azurerm_sql_server.primary_server.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.sa.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.sa.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }

  tags = var.tags
}
