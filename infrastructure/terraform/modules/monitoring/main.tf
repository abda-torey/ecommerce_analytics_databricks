# Monitoring Module - Log Analytics Workspace

resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.project_name}-logs-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  
  tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}

# Diagnostic settings for Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage" {
  name                       = "storage-diagnostics"
  target_resource_id         = var.storage_account_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  
  enabled_log {
    category = "StorageRead"
  }
  
  enabled_log {
    category = "StorageWrite"
  }
  
  metric {
    category = "Transaction"
  }
}

# Diagnostic settings for Event Hubs
resource "azurerm_monitor_diagnostic_setting" "eventhubs" {
  name                       = "eventhubs-diagnostics"
  target_resource_id         = var.eventhub_namespace_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  
  enabled_log {
    category = "ArchiveLogs"
  }
  
  enabled_log {
    category = "OperationalLogs"
  }
  
  metric {
    category = "AllMetrics"
  }
}
