output "resource_group_name" {
  value = module.infrastructure.resource_group_name
}

output "storage_account_name" {
  value = module.infrastructure.storage_account_name
}

output "eventhub_namespace" {
  value = module.infrastructure.eventhub_namespace
}

output "databricks_url" {
  value = module.infrastructure.databricks_workspace_url
}
