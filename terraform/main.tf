# Create a resource group
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

resource "random_string" "resource_code" {
  length  = 4
  special = false
  upper   = false
}

# Create the network module
module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  hub_location        = var.hub_location
  spoke1_location     = var.spoke1_location
  spoke2_location     = var.spoke2_location
  sql_server_id       = module.storage.sql_server_id
}

# Create the storage module
module "storage" {
  source = "./modules/storage"
  resource_group_name = azurerm_resource_group.rg.name
  hub_location        = var.hub_location
  sql_server_name     = "sql-${random_string.resource_code.result}-${var.hub_location}-001"
  sql_username        = "sqluser"
  sql_password        = "<PW_PLACEHOLDER>"
}

# Create the compute module
module "compute" {
  source = "./modules/compute"
  resource_group_name = azurerm_resource_group.rg.name
  spoke1_location     = var.spoke1_location
  spoke2_location     = var.spoke2_location
  snet_id_spoke1      = module.network.snet_id_spoke1
  snet_id_spoke2      = module.network.snet_id_spoke2
  vm_username         = "azureuser"
  vm_password         = "<PW_PLACEHOLDER>"
}