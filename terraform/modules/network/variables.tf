variable "resource_group_name" {
    type = string
    description = "Resource group name."
}

variable "hub_location" {
    type = string
    description = "Location of the hub."
}

variable "spoke1_location" {
    type = string
    description = "Location of Spoke 1."
}

variable "spoke2_location" {
    type = string
    description = "Location of Spoke 2."
}

variable "sql_server_id" {
    type = string
    description = "SQL Server resource ID."
}