output "storage_account_id" {
  description = "Storage account ID"
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.main.name
}

output "storage_account_key" {
  description = "Storage account primary access key"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "containers" {
  description = "Created container names"
  value = {
    bronze      = azurerm_storage_container.bronze.name
    silver      = azurerm_storage_container.silver.name
    gold        = azurerm_storage_container.gold.name
    raw_data    = azurerm_storage_container.raw_data.name
    checkpoints = azurerm_storage_container.checkpoints.name
    logs        = azurerm_storage_container.logs.name
    uploads     = azurerm_storage_container.uploads.name
  }
}
