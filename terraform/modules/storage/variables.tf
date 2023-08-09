variable "resource_group_name" {
    type = string
    description = "Resource group name."
}

variable "hub_location" {
    type = string
    description = "Location of the hub."
}

variable "sql_server_name" {
    type = string
    description = "Name of the SQL Server."
}

variable "sql_username" {
    type = string
    description = "Username for SQL Server."
}

variable "sql_password" {
    type = string
    sensitive = true
    description = "Password for SQL Server."
}