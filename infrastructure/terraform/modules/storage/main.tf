# Storage Account Module

locals {
  storage_account_name = replace("${var.project_name}${var.environment}${var.random_suffix}", "-", "")
}

resource "azurerm_storage_account" "main" {
  name                     = substr(local.storage_account_name, 0, 24)
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"
  
  is_hns_enabled           = true  # Enable hierarchical namespace for Data Lake Gen2
  min_tls_version          = "TLS1_2"
  
  
  tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}

# Containers for Medallion Architecture
resource "azurerm_storage_container" "bronze" {
  name                  = "bronze"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "silver" {
  name                  = "silver"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "gold" {
  name                  = "gold"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "raw_data" {
  name                  = "raw-data"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "checkpoints" {
  name                  = "checkpoints"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "logs" {
  name                  = "logs"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
