resource "azurerm_resource_group" "linux-function-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "linux-storage-account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.linux-function-rg.name
  location                 = azurerm_resource_group.linux-function-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "linux-function-plan" {
  name                = "${var.resource_group_name}-plan"
  location            = azurerm_resource_group.linux-function-rg.location
  resource_group_name = azurerm_resource_group.linux-function-rg.name
  os_type = "Linux"
  reserved = true
  sku_name = "B1"
}

resource "azure_linux_function_app" "linux-function-app" {
  name                       = "${var.resource_group_name}-functionapp"
  location                   = azurerm_resource_group.linux-function-rg.location
  resource_group_name        = azurerm_resource_group.linux-function-rg.name
  service_plan_id            = azurerm_service_plan.linux-function-plan.id
  storage_account_name       = azurerm_storage_account.linux-storage-account.name
  storage_account_access_key = azurerm_storage_account.linux-storage-account.primary_access_key
  version                    = "~4"
  site_config {
    application_stack {
        node_version = "18"
    }
    always_on        = true
  }
}

