# Create MS SQL Server
resource "azurerm_sql_server" "sql" {
    name                         = var.sql_server_name
    resource_group_name          = var.resource_group_name
    location                     = var.hub_location
    version                      = "12.0"
    administrator_login          = var.sql_username
    administrator_login_password = var.sql_password
    # public_network_access_enabled = false
}

# Create MS SQL Database
resource "azurerm_sql_database" "db" {
    name                = "db"
    resource_group_name = var.resource_group_name
    location            = var.hub_location
    server_name         = azurerm_sql_server.sql.name
    edition             = "Basic"
    collation           = "SQL_Latin1_General_CP1_CI_AS"
    max_size_gb         = 1
}