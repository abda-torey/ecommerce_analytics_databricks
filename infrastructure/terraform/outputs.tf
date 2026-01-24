output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.resource_group.name
}

output "storage_account_name" {
  description = "Storage account name"
  value       = module.storage.storage_account_name
}

output "storage_account_key" {
  description = "Storage account primary key"
  value       = module.storage.storage_account_key
  sensitive   = true
}

output "eventhub_namespace" {
  description = "Event Hubs namespace name"
  value       = module.eventhubs.namespace_name
}

output "eventhub_connection_strings" {
  description = "Event Hub connection strings"
  value       = module.eventhubs.connection_strings
  sensitive   = true
}

output "data_factory_name" {
  description = "Data Factory name"
  value       = module.datafactory.name
}

output "databricks_workspace_url" {
  description = "Databricks workspace URL"
  value       = module.databricks.workspace_url
}

output "databricks_workspace_id" {
  description = "Databricks workspace ID"
  value       = module.databricks.workspace_id
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  value       = module.monitoring.workspace_id
}