resource "azurerm_mssql_server" "primary_server" {
  name                         = local.app_name_with_env
  resource_group_name          = azurerm_resource_group.primary.name
  location                     = azurerm_resource_group.primary.location
  version                      = "12.0"
  administrator_login          = "azureadmin"
  administrator_login_password = "Welcome@1234"

  tags = var.tags
}

resource "azurerm_mssql_firewall_rule" "firewall_rule" {
  name                = "AllowAzureResources"
  server_id           = azurerm_mssql_server.primary_server.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "sql_admin_firewall_rule" {
  name                = "faraz ip address"
  server_id           = azurerm_mssql_server.primary_server.id
  start_ip_address    = "106.214.229.221"
  end_ip_address      = "106.214.229.221"
}

resource "azurerm_mssql_database" "primary_db" {
  name                = local.app_name_with_sub_env
  server_id           = azurerm_mssql_server.primary_server.id

  tags = var.tags
}

resource "azurerm_mssql_database_extended_auditing_policy" "extended_policy" {
  database_id                             = azurerm_mssql_database.primary_db.id
  storage_endpoint                        = azurerm_storage_account.sa.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.sa.primary_access_key
  storage_account_access_key_is_secondary = true
  retention_in_days                       = 6
}
