# Event Hubs Module

resource "azurerm_eventhub_namespace" "main" {
  name                = "${var.project_name}-events-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"
  capacity            = 1
  
  tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}

# Event Hubs for different event types
resource "azurerm_eventhub" "clickstream" {
  name                = "clickstream"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub" "purchases" {
  name                = "purchases"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub" "inventory" {
  name                = "inventory"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub" "user_activity" {
  name                = "user-activity"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
  partition_count     = 2
  message_retention   = 1
}

# Authorization rules for each Event Hub
resource "azurerm_eventhub_authorization_rule" "clickstream" {
  name                = "SendListenPolicy"
  namespace_name      = azurerm_eventhub_namespace.main.name
  eventhub_name       = azurerm_eventhub.clickstream.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = true
  manage              = false
}

resource "azurerm_eventhub_authorization_rule" "purchases" {
  name                = "SendListenPolicy"
  namespace_name      = azurerm_eventhub_namespace.main.name
  eventhub_name       = azurerm_eventhub.purchases.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = true
  manage              = false
}

resource "azurerm_eventhub_authorization_rule" "inventory" {
  name                = "SendListenPolicy"
  namespace_name      = azurerm_eventhub_namespace.main.name
  eventhub_name       = azurerm_eventhub.inventory.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = true
  manage              = false
}

resource "azurerm_eventhub_authorization_rule" "user_activity" {
  name                = "SendListenPolicy"
  namespace_name      = azurerm_eventhub_namespace.main.name
  eventhub_name       = azurerm_eventhub.user_activity.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = true
  manage              = false
}
