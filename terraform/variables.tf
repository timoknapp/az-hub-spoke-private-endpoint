variable "resource_group_name" {
    type = string
    default     = "rg-hub-spoke"
    description = "Resource group name."
}

variable "resource_group_location" {
    type = string
    default     = "westeurope"
    description = "Location of the resource group."
}

variable "hub_location" {
    type = string
    default     = "westeurope"
    description = "Location of the hub."
}

variable "spoke1_location" {
    type = string
    default     = "westeurope"
    description = "Location of Spoke 1."
}

variable "spoke2_location" {
    type = string
    default     = "northeurope"
    description = "Location of Spoke 2."
}