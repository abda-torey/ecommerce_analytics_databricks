output "namespace_id" {
  description = "Event Hubs namespace ID"
  value       = azurerm_eventhub_namespace.main.id
}

output "namespace_name" {
  description = "Event Hubs namespace name"
  value       = azurerm_eventhub_namespace.main.name
}

output "eventhub_names" {
  description = "Names of created Event Hubs"
  value = {
    clickstream   = azurerm_eventhub.clickstream.name
    purchases     = azurerm_eventhub.purchases.name
    inventory     = azurerm_eventhub.inventory.name
    user_activity = azurerm_eventhub.user_activity.name
  }
}

output "connection_strings" {
  description = "Event Hub connection strings"
  value = {
    clickstream   = azurerm_eventhub_authorization_rule.clickstream.primary_connection_string
    purchases     = azurerm_eventhub_authorization_rule.purchases.primary_connection_string
    inventory     = azurerm_eventhub_authorization_rule.inventory.primary_connection_string
    user_activity = azurerm_eventhub_authorization_rule.user_activity.primary_connection_string
  }
  sensitive = true
}
