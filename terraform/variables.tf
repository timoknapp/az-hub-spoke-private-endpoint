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

variable "resource_group_name" {
    type = string
    default     = "rg-hub-spoke-tf"
    description = "Resource group name."
}

# variable "vnet_hub_name" {
#     type = string
#     default     = "vnet-hub-${var.hub_location}-001"
#     description = "Virtual network name hub."
# }

# variable "vnet_spoke1_name" {
#     type = string
#     default     = "vnet-spoke-${var.spoke1_location}-001"
#     description = "Virtual network name spoke 1."
# }

# variable "vnet_spoke2_name" {
#     type = string
#     default     = "vnet-spoke-${var.spoke2_location}-001"
#     description = "Virtual network name spoke 2."
# }
