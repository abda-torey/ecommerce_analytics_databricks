# Data Factory Module

resource "azurerm_data_factory" "main" {
  name                = "${var.project_name}-adf-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  
  identity {
    type = "SystemAssigned"
  }
  
  tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}
