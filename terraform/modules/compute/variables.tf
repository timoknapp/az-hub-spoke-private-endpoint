variable "resource_group_name" {
    type = string
    description = "Resource group name."
}

variable "spoke1_location" {
    type = string
    description = "Location of Spoke 1."
}

variable "spoke2_location" {
    type = string
    description = "Location of Spoke 2."
}

variable "snet_id_spoke1" {
    type = string
    description = "Resource ID of Subnet spoke 1."
}

variable "snet_id_spoke2" {
    type = string
    description = "Resource ID of Subnet spoke 2."
}

variable "vm_username" {
    type = string
    description = "Username for VM."
}

variable "vm_password" {
    type = string
    sensitive = true
    description = "Password for VM."
}